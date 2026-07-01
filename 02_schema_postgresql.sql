-- ============================================================
-- SISTEMA BI - MADUREZ PMO (P3M3)
-- Esquema PostgreSQL - Star Schema optimizado para Power BI
-- ============================================================

-- ============================================================
-- TABLAS DE DIMENSIÓN
-- ============================================================

-- Perspectivas del modelo P3M3
CREATE TABLE dim_perspectiva (
    id_perspectiva      SERIAL PRIMARY KEY,
    codigo              VARCHAR(5)      NOT NULL UNIQUE,  -- GOV, MGT, BEN, RSK, STK, FIN, RES
    nombre              VARCHAR(100)    NOT NULL,
    descripcion         TEXT,
    peso_madurez        DECIMAL(5,4)    NOT NULL DEFAULT 0.1428,  -- Peso para el score global (suma = 1)
    activo              BOOLEAN         NOT NULL DEFAULT TRUE
);

-- Niveles de madurez P3M3
CREATE TABLE dim_nivel_madurez (
    id_nivel            SERIAL PRIMARY KEY,
    nivel               SMALLINT        NOT NULL UNIQUE CHECK (nivel BETWEEN 1 AND 5),
    nombre              VARCHAR(50)     NOT NULL,
    descripcion         TEXT,
    color_hex           VARCHAR(7)      NOT NULL  -- Para semáforos en Power BI
);

-- Proyectos
CREATE TABLE dim_proyecto (
    id_proyecto         SERIAL PRIMARY KEY,
    codigo_proyecto     VARCHAR(20)     NOT NULL UNIQUE,
    nombre_proyecto     VARCHAR(200)    NOT NULL,
    descripcion         TEXT,
    tipo_proyecto       VARCHAR(50),       -- Infraestructura, Desarrollo, Transformación, etc.
    area_negocio        VARCHAR(100),
    sponsor             VARCHAR(100),
    director_proyecto   VARCHAR(100),
    fecha_inicio_plan   DATE,
    fecha_fin_plan      DATE,
    fecha_inicio_real   DATE,
    fecha_fin_real      DATE,
    presupuesto_inicial DECIMAL(15,2),
    estado              VARCHAR(30)     NOT NULL DEFAULT 'En curso',  -- En curso, Completado, Cancelado, En pausa
    tiene_sponsor       BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_acta          BOOLEAN         NOT NULL DEFAULT FALSE,
    alineado_estrategia BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_comite        BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_business_case BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_plan_recursos BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_plan_comms    BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_risk_log      BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_pir           BOOLEAN         NOT NULL DEFAULT FALSE,  -- Post-Implementation Review
    activo              BOOLEAN         NOT NULL DEFAULT TRUE
);

-- Calendario (dimensión tiempo)
CREATE TABLE dim_tiempo (
    id_tiempo           INT PRIMARY KEY,  -- Clave surrogate formato YYYYMMDD
    fecha               DATE            NOT NULL UNIQUE,
    anio                SMALLINT        NOT NULL,
    trimestre           SMALLINT        NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    mes                 SMALLINT        NOT NULL CHECK (mes BETWEEN 1 AND 12),
    nombre_mes          VARCHAR(20)     NOT NULL,
    semana_iso          SMALLINT        NOT NULL,
    dia_semana          SMALLINT        NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    nombre_dia          VARCHAR(20)     NOT NULL,
    es_fin_semana       BOOLEAN         NOT NULL,
    periodo_label       VARCHAR(7)      NOT NULL  -- Formato YYYY-MM para agregaciones
);

-- Recursos humanos
CREATE TABLE dim_recurso (
    id_recurso          SERIAL PRIMARY KEY,
    nombre_recurso      VARCHAR(100)    NOT NULL,
    rol                 VARCHAR(50)     NOT NULL,
    departamento        VARCHAR(100),
    tipo_recurso        VARCHAR(30)     NOT NULL DEFAULT 'Interno',  -- Interno, Externo, Proveedor
    coste_hora          DECIMAL(8,2),
    horas_disponibles_semana DECIMAL(5,2) DEFAULT 40,
    activo              BOOLEAN         NOT NULL DEFAULT TRUE
);

-- Tipos y categorías de riesgo
CREATE TABLE dim_tipo_riesgo (
    id_tipo_riesgo      SERIAL PRIMARY KEY,
    categoria           VARCHAR(50)     NOT NULL,  -- Técnico, Financiero, RRHH, Legal, Externo
    nombre              VARCHAR(100)    NOT NULL,
    descripcion         TEXT
);

-- KPI maestro (catálogo)
CREATE TABLE dim_kpi (
    id_kpi              SERIAL PRIMARY KEY,
    id_perspectiva      INT             NOT NULL REFERENCES dim_perspectiva(id_perspectiva),
    codigo_kpi          VARCHAR(10)     NOT NULL UNIQUE,  -- GOV_01, MGT_02, etc.
    nombre_kpi          VARCHAR(200)    NOT NULL,
    descripcion         TEXT,
    unidad              VARCHAR(30)     NOT NULL,  -- %, Ratio, Score, Días
    formula_descripcion TEXT,
    umbral_nivel_1      DECIMAL(10,4),
    umbral_nivel_2      DECIMAL(10,4),
    umbral_nivel_3      DECIMAL(10,4),
    umbral_nivel_4      DECIMAL(10,4),
    -- nivel 5 = por encima del umbral_nivel_4
    direccion           VARCHAR(10)     NOT NULL DEFAULT 'higher',  -- higher = mayor es mejor, lower = menor es mejor
    activo              BOOLEAN         NOT NULL DEFAULT TRUE
);

-- ============================================================
-- TABLAS DE HECHOS
-- ============================================================

-- Hechos: KPIs calculados por perspectiva y periodo
-- Snapshot mensual del estado de cada KPI
CREATE TABLE fact_kpi_snapshot (
    id_snapshot         BIGSERIAL PRIMARY KEY,
    id_kpi              INT             NOT NULL REFERENCES dim_kpi(id_kpi),
    id_perspectiva      INT             NOT NULL REFERENCES dim_perspectiva(id_perspectiva),
    id_tiempo           INT             NOT NULL REFERENCES dim_tiempo(id_tiempo),
    id_proyecto         INT             REFERENCES dim_proyecto(id_proyecto),  -- NULL = KPI agregado de cartera
    valor_real          DECIMAL(15,4),
    valor_objetivo      DECIMAL(15,4),
    score_madurez       SMALLINT        CHECK (score_madurez BETWEEN 1 AND 5),
    num_proyectos_base  INT             DEFAULT 1,  -- Número de proyectos usados para calcular este KPI
    notas               TEXT
);

-- Hechos: Métricas de rendimiento por proyecto y periodo (EVM)
CREATE TABLE fact_proyecto_rendimiento (
    id_rendimiento      BIGSERIAL PRIMARY KEY,
    id_proyecto         INT             NOT NULL REFERENCES dim_proyecto(id_proyecto),
    id_tiempo           INT             NOT NULL REFERENCES dim_tiempo(id_tiempo),
    -- Earned Value Management
    pv                  DECIMAL(15,2),  -- Planned Value
    ev                  DECIMAL(15,2),  -- Earned Value
    ac                  DECIMAL(15,2),  -- Actual Cost
    bac                 DECIMAL(15,2),  -- Budget at Completion
    eac                 DECIMAL(15,2),  -- Estimate at Completion (forecast)
    -- Índices derivados (calculados)
    spi                 DECIMAL(6,4)    GENERATED ALWAYS AS (
                            CASE WHEN pv IS NOT NULL AND pv <> 0 THEN ROUND(ev / pv, 4) ELSE NULL END
                        ) STORED,
    cpi                 DECIMAL(6,4)    GENERATED ALWAYS AS (
                            CASE WHEN ac IS NOT NULL AND ac <> 0 THEN ROUND(ev / ac, 4) ELSE NULL END
                        ) STORED,
    sv                  DECIMAL(15,2)   GENERATED ALWAYS AS (ev - pv) STORED,  -- Schedule Variance
    cv                  DECIMAL(15,2)   GENERATED ALWAYS AS (ev - ac) STORED,  -- Cost Variance
    -- Plazos
    fecha_inicio_plan   DATE,
    fecha_fin_plan      DATE,
    fecha_fin_forecast  DATE,
    -- % completado
    pct_completado      DECIMAL(5,2)    CHECK (pct_completado BETWEEN 0 AND 100),
    -- Hitos del periodo
    hitos_planificados  INT             DEFAULT 0,
    hitos_completados   INT             DEFAULT 0,
    tiene_baseline      BOOLEAN         NOT NULL DEFAULT FALSE,
    tiene_forecast      BOOLEAN         NOT NULL DEFAULT FALSE
);

-- Hechos: Riesgos por proyecto y periodo
CREATE TABLE fact_riesgo (
    id_fact_riesgo      BIGSERIAL PRIMARY KEY,
    id_proyecto         INT             NOT NULL REFERENCES dim_proyecto(id_proyecto),
    id_tiempo           INT             NOT NULL REFERENCES dim_tiempo(id_tiempo),
    id_tipo_riesgo      INT             REFERENCES dim_tipo_riesgo(id_tipo_riesgo),
    codigo_riesgo       VARCHAR(20),
    descripcion_riesgo  TEXT,
    probabilidad        SMALLINT        CHECK (probabilidad BETWEEN 1 AND 5),
    impacto             SMALLINT        CHECK (impacto BETWEEN 1 AND 5),
    exposure            SMALLINT        GENERATED ALWAYS AS (probabilidad * impacto) STORED,
    estado              VARCHAR(30)     NOT NULL DEFAULT 'Abierto',  -- Abierto, Cerrado, Materializado, Mitigado
    tiene_plan_respuesta BOOLEAN        NOT NULL DEFAULT FALSE,
    respuesta_eficaz    BOOLEAN,        -- NULL si no esta materializado todavía
    fecha_identificacion DATE,
    fecha_cierre        DATE
);

-- Hechos: Asignación y utilización de recursos
CREATE TABLE fact_recurso_asignacion (
    id_asignacion       BIGSERIAL PRIMARY KEY,
    id_proyecto         INT             NOT NULL REFERENCES dim_proyecto(id_proyecto),
    id_recurso          INT             NOT NULL REFERENCES dim_recurso(id_recurso),
    id_tiempo           INT             NOT NULL REFERENCES dim_tiempo(id_tiempo),
    horas_planificadas  DECIMAL(8,2)    NOT NULL DEFAULT 0,
    horas_reales        DECIMAL(8,2)    DEFAULT 0,
    horas_extra         DECIMAL(8,2)    DEFAULT 0,
    coste_real          DECIMAL(12,2),
    activo_en_proyecto  BOOLEAN         NOT NULL DEFAULT TRUE  -- FALSE = el recurso salió del equipo
);

-- Hechos: Stakeholders y comunicación por proyecto y periodo
CREATE TABLE fact_stakeholder (
    id_fact_stk         BIGSERIAL PRIMARY KEY,
    id_proyecto         INT             NOT NULL REFERENCES dim_proyecto(id_proyecto),
    id_tiempo           INT             NOT NULL REFERENCES dim_tiempo(id_tiempo),
    num_stakeholders    INT             DEFAULT 0,
    satisfaccion_media  DECIMAL(3,2)    CHECK (satisfaccion_media BETWEEN 1 AND 5),
    reuniones_plan      INT             DEFAULT 0,
    reuniones_real      INT             DEFAULT 0,
    tiene_stakeholder_register BOOLEAN NOT NULL DEFAULT FALSE
);

-- Hechos: Beneficios por proyecto y periodo
CREATE TABLE fact_beneficio (
    id_fact_ben         BIGSERIAL PRIMARY KEY,
    id_proyecto         INT             NOT NULL REFERENCES dim_proyecto(id_proyecto),
    id_tiempo           INT             NOT NULL REFERENCES dim_tiempo(id_tiempo),
    beneficio_planificado DECIMAL(15,2) DEFAULT 0,
    beneficio_realizado DECIMAL(15,2)  DEFAULT 0,
    coste_total_proyecto DECIMAL(15,2) DEFAULT 0
);

-- Hechos: Score de madurez PMO agregado por periodo (resultado final)
CREATE TABLE fact_madurez_pmo (
    id_fact_madurez     BIGSERIAL PRIMARY KEY,
    id_perspectiva      INT             NOT NULL REFERENCES dim_perspectiva(id_perspectiva),
    id_tiempo           INT             NOT NULL REFERENCES dim_tiempo(id_tiempo),
    score_perspectiva   DECIMAL(4,2)    NOT NULL CHECK (score_perspectiva BETWEEN 1 AND 5),
    nivel_madurez       SMALLINT        NOT NULL CHECK (nivel_madurez BETWEEN 1 AND 5),
    num_proyectos_eval  INT             NOT NULL DEFAULT 0,
    notas               TEXT,
    UNIQUE (id_perspectiva, id_tiempo)
);

-- ============================================================
-- VISTA: Score global PMO por periodo
-- ============================================================

CREATE VIEW v_score_global_pmo AS
SELECT
    t.periodo_label,
    t.anio,
    t.mes,
    ROUND(
        SUM(m.score_perspectiva * p.peso_madurez) / SUM(p.peso_madurez),
        2
    ) AS score_global,
    ROUND(
        SUM(m.score_perspectiva * p.peso_madurez) / SUM(p.peso_madurez)
    )::SMALLINT AS nivel_global
FROM fact_madurez_pmo m
JOIN dim_perspectiva p   ON m.id_perspectiva = p.id_perspectiva
JOIN dim_tiempo t        ON m.id_tiempo = t.id_tiempo
GROUP BY t.periodo_label, t.anio, t.mes
ORDER BY t.anio, t.mes;

-- ============================================================
-- VISTA: Radar de madurez por perspectiva (último periodo)
-- ============================================================

CREATE VIEW v_radar_madurez_actual AS
SELECT
    p.codigo,
    p.nombre,
    m.score_perspectiva,
    m.nivel_madurez,
    n.nombre        AS nombre_nivel,
    n.color_hex,
    t.periodo_label AS periodo
FROM fact_madurez_pmo m
JOIN dim_perspectiva p   ON m.id_perspectiva = p.id_perspectiva
JOIN dim_nivel_madurez n ON m.nivel_madurez = n.nivel
JOIN dim_tiempo t        ON m.id_tiempo = t.id_tiempo
WHERE t.id_tiempo = (
    SELECT MAX(id_tiempo) FROM fact_madurez_pmo
);

-- ============================================================
-- VISTA: Semáforo de salud de proyectos (SPI/CPI)
-- ============================================================

CREATE VIEW v_salud_proyectos AS
SELECT
    pr.id_proyecto,
    pr.codigo_proyecto,
    pr.nombre_proyecto,
    pr.area_negocio,
    pr.tipo_proyecto,
    r.spi,
    r.cpi,
    r.pct_completado,
    r.fecha_fin_plan,
    r.fecha_fin_forecast,
    CASE
        WHEN r.spi >= 0.95 AND r.cpi >= 0.95 THEN 'Verde'
        WHEN r.spi >= 0.85 OR r.cpi >= 0.85  THEN 'Ámbar'
        ELSE 'Rojo'
    END AS semaforo_salud,
    t.periodo_label
FROM fact_proyecto_rendimiento r
JOIN dim_proyecto pr ON r.id_proyecto = pr.id_proyecto
JOIN dim_tiempo t    ON r.id_tiempo = t.id_tiempo
WHERE t.id_tiempo = (
    SELECT MAX(id_tiempo) FROM fact_proyecto_rendimiento
)
AND pr.estado = 'En curso';

-- ============================================================
-- ÍNDICES para rendimiento en Power BI
-- ============================================================

CREATE INDEX idx_fact_kpi_tiempo        ON fact_kpi_snapshot(id_tiempo);
CREATE INDEX idx_fact_kpi_perspectiva   ON fact_kpi_snapshot(id_perspectiva);
CREATE INDEX idx_fact_kpi_proyecto      ON fact_kpi_snapshot(id_proyecto);
CREATE INDEX idx_fact_rendimiento_proj  ON fact_proyecto_rendimiento(id_proyecto, id_tiempo);
CREATE INDEX idx_fact_riesgo_proj       ON fact_riesgo(id_proyecto, id_tiempo);
CREATE INDEX idx_fact_recurso_proj      ON fact_recurso_asignacion(id_proyecto, id_tiempo);
CREATE INDEX idx_fact_madurez_tiempo    ON fact_madurez_pmo(id_tiempo);
CREATE INDEX idx_dim_tiempo_periodo     ON dim_tiempo(periodo_label);
CREATE INDEX idx_dim_tiempo_fecha       ON dim_tiempo(fecha);
