-- ============================================================
-- DATOS SIMULADOS - SISTEMA BI MADUREZ PMO
-- 12 meses de datos, 10 proyectos
-- ============================================================

-- ============================================================
-- 1. DIMENSIÓN: Niveles de Madurez
-- ============================================================
INSERT INTO dim_nivel_madurez (nivel, nombre, descripcion, color_hex) VALUES
(1, 'Awareness',   'Procesos ad-hoc, sin estándares definidos. La PMO reacciona de forma reactiva.', '#D73027'),
(2, 'Repeatable',  'Procesos básicos aplicados por algunos equipos, pero de forma inconsistente.',  '#FC8D59'),
(3, 'Defined',     'Procesos estandarizados y documentados. Adoptados en la mayoría de proyectos.', '#FEE08B'),
(4, 'Managed',     'Procesos medidos y controlados con KPIs cuantitativos. Predictibilidad alta.',  '#91CF60'),
(5, 'Optimised',   'Mejora continua basada en datos. PMO referente en la organización.',            '#1A9850');

-- ============================================================
-- 2. DIMENSIÓN: Perspectivas P3M3
-- ============================================================
INSERT INTO dim_perspectiva (codigo, nombre, descripcion, peso_madurez) VALUES
('GOV', 'Gobernanza Organizacional', 'Alineación estratégica y estructuras formales de gobierno de proyectos', 0.15),
('MGT', 'Control de Gestión',        'Seguimiento de alcance, plazo y coste mediante métricas EVM',            0.20),
('BEN', 'Gestión de Beneficios',     'Definición, seguimiento y realización de beneficios esperados',          0.15),
('RSK', 'Gestión de Riesgos',        'Identificación, evaluación y respuesta sistemática a riesgos',           0.15),
('STK', 'Gestión de Stakeholders',   'Comunicación, engagement y satisfacción de grupos de interés',           0.10),
('FIN', 'Gestión Financiera',        'Control presupuestario y predictibilidad de costes',                     0.15),
('RES', 'Gestión de Recursos',       'Asignación y utilización eficiente de recursos humanos y materiales',    0.10);

-- ============================================================
-- 3. DIMENSIÓN: Tipos de Riesgo
-- ============================================================
INSERT INTO dim_tipo_riesgo (categoria, nombre, descripcion) VALUES
('Técnico',     'Riesgo tecnológico',       'Problemas de integración, deuda técnica, tecnología obsoleta'),
('Financiero',  'Riesgo de coste',          'Desviaciones presupuestarias, cambios de divisa, inflación'),
('RRHH',        'Riesgo de personal',       'Rotación, falta de habilidades, disponibilidad de recursos'),
('Legal',       'Riesgo regulatorio',       'Cambios normativos, cumplimiento, contratos'),
('Externo',     'Riesgo de proveedor',      'Incumplimiento de proveedores, dependencias externas'),
('Externo',     'Riesgo de mercado',        'Cambios en el entorno de negocio o competencia'),
('Técnico',     'Riesgo de seguridad',      'Ciberseguridad, protección de datos'),
('Financiero',  'Riesgo de alcance',        'Scope creep, cambios de requisitos');

-- ============================================================
-- 4. DIMENSIÓN: KPIs Maestro
-- ============================================================
-- GOV
INSERT INTO dim_kpi (id_perspectiva, codigo_kpi, nombre_kpi, unidad, formula_descripcion, umbral_nivel_1, umbral_nivel_2, umbral_nivel_3, umbral_nivel_4, direccion) VALUES
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='GOV'), 'GOV_01', '% Proyectos con sponsor asignado',           '%',    '(Proyectos con sponsor / Total proyectos) × 100', 20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='GOV'), 'GOV_02', '% Proyectos con acta de constitución',        '%',    '(Proyectos con acta / Total proyectos) × 100',    20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='GOV'), 'GOV_03', '% Proyectos alineados estratégicamente',      '%',    '(Proyectos alineados / Total proyectos) × 100',   20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='GOV'), 'GOV_04', '% Proyectos con comité de seguimiento',       '%',    '(Proyectos con comité / Total activos) × 100',    20, 40, 60, 80, 'higher');

-- MGT
INSERT INTO dim_kpi (id_perspectiva, codigo_kpi, nombre_kpi, unidad, formula_descripcion, umbral_nivel_1, umbral_nivel_2, umbral_nivel_3, umbral_nivel_4, direccion) VALUES
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='MGT'), 'MGT_01', '% Proyectos con baseline definido',           '%',    '(Proyectos con baseline / Total) × 100',          20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='MGT'), 'MGT_02', 'SPI promedio de cartera',                     'Ratio','Σ(EV/PV) / n proyectos',                         0.70, 0.85, 0.95, 1.05, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='MGT'), 'MGT_03', 'CPI promedio de cartera',                     'Ratio','Σ(EV/AC) / n proyectos',                         0.70, 0.85, 0.95, 1.05, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='MGT'), 'MGT_04', '% Hitos completados a tiempo',                '%',    '(Hitos a tiempo / Total hitos) × 100',            20, 40, 60, 80, 'higher');

-- BEN
INSERT INTO dim_kpi (id_perspectiva, codigo_kpi, nombre_kpi, unidad, formula_descripcion, umbral_nivel_1, umbral_nivel_2, umbral_nivel_3, umbral_nivel_4, direccion) VALUES
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='BEN'), 'BEN_01', '% Proyectos con caso de negocio',             '%',    '(Proyectos con business case / Total) × 100',     20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='BEN'), 'BEN_02', '% Beneficios realizados vs. planificados',    '%',    '(Beneficios realizados / Planificados) × 100',    20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='BEN'), 'BEN_03', '% Proyectos con revisión post-implementación','%',    '(Proyectos con PIR / Completados) × 100',         20, 40, 60, 80, 'higher');

-- RSK
INSERT INTO dim_kpi (id_perspectiva, codigo_kpi, nombre_kpi, unidad, formula_descripcion, umbral_nivel_1, umbral_nivel_2, umbral_nivel_3, umbral_nivel_4, direccion) VALUES
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='RSK'), 'RSK_01', '% Proyectos con registro de riesgos activo',  '%',    '(Proyectos con risk log / Total activos) × 100',  20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='RSK'), 'RSK_02', '% Riesgos con plan de respuesta',             '%',    '(Riesgos con plan / Total riesgos) × 100',        20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='RSK'), 'RSK_03', '% Riesgos materializados con respuesta eficaz','%',   '(Respuestas eficaces / Total materializados) × 100', 20, 40, 60, 80, 'higher');

-- STK
INSERT INTO dim_kpi (id_perspectiva, codigo_kpi, nombre_kpi, unidad, formula_descripcion, umbral_nivel_1, umbral_nivel_2, umbral_nivel_3, umbral_nivel_4, direccion) VALUES
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='STK'), 'STK_01', '% Proyectos con plan de comunicación',        '%',    '(Proyectos con plan comms / Total) × 100',        20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='STK'), 'STK_02', '% Reuniones de seguimiento realizadas',       '%',    '(Reuniones realizadas / Planificadas) × 100',     20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='STK'), 'STK_03', 'Satisfacción media de stakeholders',          'Score','Promedio encuestas (1-5)',                        2.0, 3.0, 3.5, 4.5, 'higher');

-- FIN
INSERT INTO dim_kpi (id_perspectiva, codigo_kpi, nombre_kpi, unidad, formula_descripcion, umbral_nivel_1, umbral_nivel_2, umbral_nivel_3, umbral_nivel_4, direccion) VALUES
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='FIN'), 'FIN_01', 'Desviación media de presupuesto',             '%',    'Σ((AC-BAC)/BAC) / n × 100',                       30, 15, 5, -5, 'lower'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='FIN'), 'FIN_02', '% Proyectos con forecast mensual actualizado','%',    '(Proyectos con forecast / Total activos) × 100',  20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='FIN'), 'FIN_03', '% Proyectos en rojo por coste (>+10%)',       '%',    '(Proyectos desviados >10% / Total) × 100',        80, 60, 40, 20, 'lower');

-- RES
INSERT INTO dim_kpi (id_perspectiva, codigo_kpi, nombre_kpi, unidad, formula_descripcion, umbral_nivel_1, umbral_nivel_2, umbral_nivel_3, umbral_nivel_4, direccion) VALUES
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='RES'), 'RES_01', '% Utilización de recursos',                  '%',    '(Horas reales / Horas disponibles) × 100',        40, 60, 70, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='RES'), 'RES_02', '% Proyectos con plan de recursos formal',     '%',    '(Proyectos con plan recursos / Total) × 100',     20, 40, 60, 80, 'higher'),
((SELECT id_perspectiva FROM dim_perspectiva WHERE codigo='RES'), 'RES_03', 'Índice de sobrecarga de recursos',            '%',    '(Horas extra / Horas planificadas) × 100',        30, 20, 10, 5, 'lower');

-- ============================================================
-- 5. DIMENSIÓN: Recursos
-- ============================================================
INSERT INTO dim_recurso (nombre_recurso, rol, departamento, tipo_recurso, coste_hora, horas_disponibles_semana) VALUES
('Ana García',      'Project Manager',       'PMO',                 'Interno', 55.00, 40),
('Carlos López',    'Business Analyst',      'PMO',                 'Interno', 45.00, 40),
('María Fernández', 'Desarrolladora Senior', 'Tecnología',          'Interno', 50.00, 40),
('Juan Martínez',   'Arquitecto TI',         'Tecnología',          'Interno', 65.00, 40),
('Laura Sánchez',   'Project Manager',       'PMO',                 'Interno', 55.00, 40),
('Pedro Ruiz',      'Consultor',             'Consultoría Externa',  'Externo', 90.00, 40),
('Sofía Torres',    'QA Tester',             'Tecnología',          'Interno', 40.00, 40),
('Diego Morales',   'Diseñadora UX',         'Producto',            'Interno', 42.00, 40),
('Elena Vega',      'Scrum Master',          'PMO',                 'Interno', 48.00, 40),
('Andrés Castro',   'Data Engineer',         'Tecnología',          'Interno', 52.00, 40);

-- ============================================================
-- 6. DIMENSIÓN: Proyectos (10 proyectos, distintos estados y atributos)
-- ============================================================
INSERT INTO dim_proyecto (
    codigo_proyecto, nombre_proyecto, tipo_proyecto, area_negocio, sponsor, director_proyecto,
    fecha_inicio_plan, fecha_fin_plan, fecha_inicio_real,
    presupuesto_inicial, estado,
    tiene_sponsor, tiene_acta, alineado_estrategia, tiene_comite,
    tiene_business_case, tiene_plan_recursos, tiene_plan_comms, tiene_risk_log, tiene_pir
) VALUES
('PRJ-2024-001', 'Migración ERP a SAP S/4HANA',        'Transformación',   'Operaciones',  'CEO',       'Ana García',      '2024-01-15', '2024-12-31', '2024-01-20', 850000, 'Completado', TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE),
('PRJ-2024-002', 'Plataforma eCommerce B2B',            'Desarrollo',       'Comercial',    'CCO',       'Laura Sánchez',   '2024-02-01', '2024-09-30', '2024-02-05', 320000, 'Completado', TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE),
('PRJ-2024-003', 'Data Warehouse Corporativo',          'Infraestructura',  'Tecnología',   'CTO',       'Ana García',      '2024-03-01', '2025-03-31', '2024-03-10', 420000, 'En curso',   TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE),
('PRJ-2024-004', 'App Móvil Fuerza de Ventas',          'Desarrollo',       'Comercial',    'CCO',       'Laura Sánchez',   '2024-04-01', '2024-11-30', '2024-04-08', 180000, 'Completado', TRUE,  TRUE,  FALSE, TRUE,  FALSE, TRUE,  TRUE,  FALSE, FALSE),
('PRJ-2024-005', 'Programa de Transformación Digital',  'Transformación',   'Corporativo',  'CEO',       'Ana García',      '2024-01-01', '2025-06-30', '2024-01-15', 1200000,'En curso',  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE),
('PRJ-2024-006', 'Rediseño Web Corporativa',            'Desarrollo',       'Marketing',    'CMO',       'Laura Sánchez',   '2024-05-01', '2024-08-31', '2024-05-10', 75000,  'Completado', FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE),
('PRJ-2024-007', 'Sistema de Gestión Documental',       'Infraestructura',  'Administración','CFO',      'Carlos López',    '2024-06-01', '2025-01-31', '2024-06-15', 95000,  'En curso',   TRUE,  FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, TRUE,  FALSE),
('PRJ-2024-008', 'Certificación ISO 27001',             'Compliance',       'Tecnología',   'CTO',       'Elena Vega',      '2024-07-01', '2025-04-30', '2024-07-10', 60000,  'En curso',   TRUE,  TRUE,  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  TRUE,  FALSE),
('PRJ-2024-009', 'Portal de RRHH Self-Service',         'Desarrollo',       'RRHH',         'CHRO',      'Carlos López',    '2024-08-01', '2025-02-28', '2024-08-20', 130000, 'En curso',   FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
('PRJ-2024-010', 'Integración CRM-ERP',                 'Infraestructura',  'Operaciones',  'COO',       'Laura Sánchez',   '2024-09-01', '2025-05-31', '2024-09-05', 210000, 'En curso',   TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE);

-- ============================================================
-- 7. DIMENSIÓN: Calendario (Enero 2024 – Diciembre 2024)
-- Inserta el último día de cada mes (snapshots mensuales)
-- ============================================================
INSERT INTO dim_tiempo (id_tiempo, fecha, anio, trimestre, mes, nombre_mes, semana_iso, dia_semana, nombre_dia, es_fin_semana, periodo_label) VALUES
(20240131, '2024-01-31', 2024, 1, 1,  'Enero',      5,  3, 'Miércoles', FALSE, '2024-01'),
(20240229, '2024-02-29', 2024, 1, 2,  'Febrero',    9,  4, 'Jueves',    FALSE, '2024-02'),
(20240331, '2024-03-31', 2024, 1, 3,  'Marzo',      13, 7, 'Domingo',   TRUE,  '2024-03'),
(20240430, '2024-04-30', 2024, 2, 4,  'Abril',      18, 2, 'Martes',    FALSE, '2024-04'),
(20240531, '2024-05-31', 2024, 2, 5,  'Mayo',       22, 5, 'Viernes',   FALSE, '2024-05'),
(20240630, '2024-06-30', 2024, 2, 6,  'Junio',      26, 7, 'Domingo',   TRUE,  '2024-06'),
(20240731, '2024-07-31', 2024, 3, 7,  'Julio',      31, 3, 'Miércoles', FALSE, '2024-07'),
(20240831, '2024-08-31', 2024, 3, 8,  'Agosto',     35, 6, 'Sábado',    TRUE,  '2024-08'),
(20240930, '2024-09-30', 2024, 3, 9,  'Septiembre', 40, 1, 'Lunes',     FALSE, '2024-09'),
(20241031, '2024-10-31', 2024, 4, 10, 'Octubre',    44, 4, 'Jueves',    FALSE, '2024-10'),
(20241130, '2024-11-30', 2024, 4, 11, 'Noviembre',  48, 6, 'Sábado',    TRUE,  '2024-11'),
(20241231, '2024-12-31', 2024, 4, 12, 'Diciembre',  1,  2, 'Martes',    FALSE, '2024-12');

-- ============================================================
-- 8. HECHOS: Rendimiento EVM por proyecto y mes
-- (Los 10 proyectos de la cartera, con cobertura mensual desde
-- su fecha de inicio real hasta su cierre o hasta diciembre 2024)
-- ============================================================

-- PRJ-2024-001: Migración ERP a SAP S/4HANA (completado, gobernanza completa, cierre ejemplar)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240131, 70000,  65000,  68000,  850000, 880000, '2024-12-31'::date, '2025-01-15'::date, 8.0,   1,  0,  TRUE, TRUE),
    (20240229, 145000, 138000, 142000, 850000, 875000, '2024-12-31'::date, '2025-01-05'::date, 16.0,  2,  2,  TRUE, TRUE),
    (20240331, 215000, 210000, 213000, 850000, 868000, '2024-12-31'::date, '2024-12-28'::date, 25.0,  3,  3,  TRUE, TRUE),
    (20240430, 290000, 285000, 288000, 850000, 862000, '2024-12-31'::date, '2024-12-20'::date, 34.0,  4,  4,  TRUE, TRUE),
    (20240531, 360000, 358000, 360000, 850000, 855000, '2024-12-31'::date, '2024-12-15'::date, 42.0,  5,  5,  TRUE, TRUE),
    (20240630, 435000, 432000, 434000, 850000, 850000, '2024-12-31'::date, '2024-12-15'::date, 51.0,  6,  6,  TRUE, TRUE),
    (20240731, 505000, 505000, 505000, 850000, 848000, '2024-12-31'::date, '2024-12-10'::date, 59.0,  7,  7,  TRUE, TRUE),
    (20240831, 580000, 582000, 580000, 850000, 845000, '2024-12-31'::date, '2024-12-10'::date, 68.0,  8,  8,  TRUE, TRUE),
    (20240930, 650000, 655000, 650000, 850000, 842000, '2024-12-31'::date, '2024-12-05'::date, 77.0,  9,  9,  TRUE, TRUE),
    (20241031, 725000, 732000, 722000, 850000, 840000, '2024-12-31'::date, '2024-12-05'::date, 86.0,  10, 10, TRUE, TRUE),
    (20241130, 795000, 805000, 790000, 850000, 838000, '2024-12-31'::date, '2024-12-01'::date, 95.0,  11, 11, TRUE, TRUE),
    (20241231, 850000, 858000, 840000, 850000, 840000, '2024-12-31'::date, '2024-12-01'::date, 100.0, 12, 12, TRUE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-001' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-002: Plataforma eCommerce B2B (completado, gobernanza fuerte salvo PIR, cierre saludable)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240229, 35000,  30000,  33000,  320000, 335000, '2024-09-30'::date, '2024-10-10'::date, 9.0,   1, 0, TRUE, TRUE),
    (20240331, 75000,  68000,  72000,  320000, 332000, '2024-09-30'::date, '2024-10-05'::date, 21.0,  2, 1, TRUE, TRUE),
    (20240430, 120000, 112000, 116000, 320000, 329000, '2024-09-30'::date, '2024-09-28'::date, 35.0,  3, 3, TRUE, TRUE),
    (20240531, 165000, 158000, 162000, 320000, 326000, '2024-09-30'::date, '2024-09-25'::date, 49.0,  4, 4, TRUE, TRUE),
    (20240630, 210000, 205000, 208000, 320000, 320000, '2024-09-30'::date, '2024-09-25'::date, 64.0,  5, 5, TRUE, TRUE),
    (20240731, 255000, 252000, 253000, 320000, 316000, '2024-09-30'::date, '2024-09-20'::date, 79.0,  6, 6, TRUE, TRUE),
    (20240831, 290000, 290000, 288000, 320000, 312000, '2024-09-30'::date, '2024-09-20'::date, 91.0,  7, 7, TRUE, TRUE),
    (20240930, 320000, 312000, 308000, 320000, 308000, '2024-09-30'::date, '2024-09-30'::date, 100.0, 8, 8, TRUE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-002' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-003: Data Warehouse (en curso, tendencia mejorando)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240131, 35000,  28000,  31000,  420000, 445000, '2025-03-31'::date, '2025-04-15'::date, 8.0,  1, 0, TRUE, TRUE),
    (20240229, 70000,  58000,  64000,  420000, 443000, '2025-03-31'::date, '2025-04-10'::date, 16.0, 2, 1, TRUE, TRUE),
    (20240331, 105000, 92000,  98000,  420000, 440000, '2025-03-31'::date, '2025-04-05'::date, 25.0, 3, 2, TRUE, TRUE),
    (20240430, 140000, 128000, 133000, 420000, 437000, '2025-03-31'::date, '2025-04-01'::date, 35.0, 4, 4, TRUE, TRUE),
    (20240531, 175000, 163000, 168000, 420000, 434000, '2025-03-31'::date, '2025-03-31'::date, 45.0, 5, 5, TRUE, TRUE),
    (20240630, 210000, 200000, 203000, 420000, 426000, '2025-03-31'::date, '2025-03-25'::date, 55.0, 6, 6, TRUE, TRUE),
    (20240731, 245000, 238000, 240000, 420000, 423000, '2025-03-31'::date, '2025-03-20'::date, 63.0, 7, 7, TRUE, TRUE),
    (20240831, 280000, 272000, 274000, 420000, 422000, '2025-03-31'::date, '2025-03-20'::date, 70.0, 8, 8, TRUE, TRUE),
    (20240930, 315000, 305000, 307000, 420000, 422000, '2025-03-31'::date, '2025-03-31'::date, 77.0, 9, 9, TRUE, TRUE),
    (20241031, 350000, 340000, 341000, 420000, 421000, '2025-03-31'::date, '2025-03-31'::date, 83.0, 10, 10, TRUE, TRUE),
    (20241130, 385000, 375000, 376000, 420000, 421000, '2025-03-31'::date, '2025-03-31'::date, 90.0, 11, 11, TRUE, TRUE),
    (20241231, 420000, 410000, 411000, 420000, 420500, '2025-03-31'::date, '2025-03-31'::date, 97.0, 12, 12, TRUE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-003' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-004: App Móvil Fuerza de Ventas (completado, sin alineación estratégica ni caso de negocio ni risk log, sobrecoste moderado)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240430, 20000,  16000,  18000,  180000, 195000, '2024-11-30'::date, '2024-12-05'::date, 9.0,   1, 0, TRUE, TRUE),
    (20240531, 42000,  35000,  39000,  180000, 197000, '2024-11-30'::date, '2024-12-10'::date, 19.0,  2, 1, TRUE, TRUE),
    (20240630, 68000,  58000,  64000,  180000, 199000, '2024-11-30'::date, '2024-12-15'::date, 32.0,  3, 2, TRUE, TRUE),
    (20240731, 95000,  84000,  93000,  180000, 200000, '2024-11-30'::date, '2024-12-15'::date, 47.0,  4, 3, TRUE, TRUE),
    (20240831, 122000, 110000, 123000, 180000, 201000, '2024-11-30'::date, '2024-12-20'::date, 61.0,  5, 4, TRUE, TRUE),
    (20240930, 148000, 136000, 153000, 180000, 198000, '2024-11-30'::date, '2024-12-10'::date, 76.0,  6, 6, TRUE, TRUE),
    (20241031, 165000, 158000, 176000, 180000, 194000, '2024-11-30'::date, '2024-12-05'::date, 88.0,  7, 7, TRUE, TRUE),
    (20241130, 180000, 176000, 190000, 180000, 190000, '2024-11-30'::date, '2024-11-30'::date, 100.0, 8, 8, TRUE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-004' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-005: Transformación Digital (en curso, problemas en Q1, mejora progresiva)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240131, 100000, 60000,  110000, 1200000, 1380000, '2025-06-30'::date, '2025-10-31'::date, 5.0,  2, 0, TRUE, TRUE),
    (20240229, 200000, 130000, 225000, 1200000, 1360000, '2025-06-30'::date, '2025-10-15'::date, 11.0, 3, 1, TRUE, TRUE),
    (20240331, 300000, 220000, 335000, 1200000, 1340000, '2025-06-30'::date, '2025-10-01'::date, 18.0, 4, 2, TRUE, TRUE),
    (20240430, 400000, 330000, 440000, 1200000, 1300000, '2025-06-30'::date, '2025-09-15'::date, 28.0, 5, 3, TRUE, TRUE),
    (20240531, 500000, 445000, 540000, 1200000, 1260000, '2025-06-30'::date, '2025-09-01'::date, 37.0, 6, 5, TRUE, TRUE),
    (20240630, 600000, 565000, 635000, 1200000, 1230000, '2025-06-30'::date, '2025-08-31'::date, 47.0, 7, 6, TRUE, TRUE),
    (20240731, 700000, 672000, 720000, 1200000, 1210000, '2025-06-30'::date, '2025-08-15'::date, 56.0, 8, 8, TRUE, TRUE),
    (20240831, 800000, 778000, 805000, 1200000, 1205000, '2025-06-30'::date, '2025-07-31'::date, 65.0, 9, 9, TRUE, TRUE),
    (20240930, 900000, 883000, 905000, 1200000, 1202000, '2025-06-30'::date, '2025-07-15'::date, 74.0, 10, 10, TRUE, TRUE),
    (20241031, 1000000, 988000, 1005000, 1200000, 1200000, '2025-06-30'::date, '2025-06-30'::date, 82.0, 11, 11, TRUE, TRUE),
    (20241130, 1100000, 1092000, 1103000, 1200000, 1200000, '2025-06-30'::date, '2025-06-30'::date, 91.0, 12, 12, TRUE, TRUE),
    (20241231, 1200000, 1188000, 1198000, 1200000, 1200000, '2025-06-30'::date, '2025-06-30'::date, 99.0, 13, 13, TRUE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-005' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-006: Rediseño Web Corporativa (completado, sin sponsor ni comité ni caso de negocio ni plan de recursos ni risk log, cierre forzado con desviación)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240531, 12000, 9000,  11000, 75000, 82000, '2024-08-31'::date, '2024-09-05'::date, 12.0,  1, 0, FALSE, TRUE),
    (20240630, 30000, 22000, 27000, 75000, 84000, '2024-08-31'::date, '2024-09-10'::date, 29.0,  2, 1, FALSE, TRUE),
    (20240731, 52000, 40000, 49000, 75000, 86000, '2024-08-31'::date, '2024-09-10'::date, 53.0,  3, 2, FALSE, TRUE),
    (20240831, 75000, 68000, 82000, 75000, 82000, '2024-08-31'::date, '2024-08-31'::date, 100.0, 4, 4, FALSE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-006' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-007: Sistema de Gestión Documental (en curso, sin acta ni caso de negocio ni plan de recursos ni de comunicación, desviación moderada)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240630, 8000,  6000,  7500,  95000, 105000, '2025-01-31'::date, '2025-02-15'::date, 8.0,  1, 0, TRUE, FALSE),
    (20240731, 18000, 14000, 17000, 95000, 108000, '2025-01-31'::date, '2025-02-20'::date, 18.0, 2, 1, TRUE, FALSE),
    (20240831, 30000, 24000, 29000, 95000, 110000, '2025-01-31'::date, '2025-03-01'::date, 30.0, 3, 1, TRUE, FALSE),
    (20240930, 43000, 36000, 43000, 95000, 112000, '2025-01-31'::date, '2025-03-10'::date, 44.0, 4, 2, TRUE, FALSE),
    (20241031, 58000, 50000, 59000, 95000, 113000, '2025-01-31'::date, '2025-03-20'::date, 58.0, 5, 3, TRUE, FALSE),
    (20241130, 75000, 66000, 77000, 95000, 114000, '2025-01-31'::date, '2025-03-25'::date, 75.0, 6, 4, TRUE, FALSE),
    (20241231, 95000, 84000, 98000, 95000, 115000, '2025-01-31'::date, '2025-03-31'::date, 88.0, 7, 5, TRUE, FALSE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-007' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-008: Certificación ISO 27001 (en curso, gobernanza fuerte salvo caso de negocio, buen avance pendiente de auditoría externa)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240731, 8000,  7500,  7800,  60000, 61500, '2025-04-30'::date, '2025-04-20'::date, 13.0, 1, 0, TRUE, TRUE),
    (20240831, 18000, 17500, 17800, 60000, 61200, '2025-04-30'::date, '2025-04-10'::date, 29.0, 2, 2, TRUE, TRUE),
    (20240930, 29000, 29000, 28800, 60000, 60500, '2025-04-30'::date, '2025-04-01'::date, 48.0, 3, 3, TRUE, TRUE),
    (20241031, 40000, 40500, 39800, 60000, 59800, '2025-04-30'::date, '2025-03-20'::date, 67.0, 4, 4, TRUE, TRUE),
    (20241130, 51000, 52000, 50500, 60000, 59500, '2025-04-30'::date, '2025-03-15'::date, 85.0, 5, 5, TRUE, TRUE),
    (20241231, 60000, 61500, 59800, 60000, 59800, '2025-04-30'::date, '2025-03-31'::date, 96.0, 6, 6, TRUE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-008' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-009: Portal RRHH (proyecto problemático, baja madurez)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240831, 15000,  8000,   20000,  130000, 175000, '2025-02-28'::date, '2025-06-30'::date, 6.0,  2, 0, FALSE, FALSE),
    (20240930, 30000,  14000,  38000,  130000, 170000, '2025-02-28'::date, '2025-07-31'::date, 11.0, 3, 0, FALSE, FALSE),
    (20241031, 45000,  22000,  55000,  130000, 168000, '2025-02-28'::date, '2025-08-31'::date, 17.0, 4, 1, FALSE, FALSE),
    (20241130, 65000,  32000,  72000,  130000, 165000, '2025-02-28'::date, '2025-08-31'::date, 25.0, 5, 1, FALSE, FALSE),
    (20241231, 85000,  45000,  88000,  130000, 163000, '2025-02-28'::date, '2025-09-30'::date, 35.0, 6, 2, FALSE, FALSE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-009' AND t.id_tiempo = vals.id_tiempo_v;

-- PRJ-2024-010: Integración CRM-ERP (en curso, gobernanza completa salvo PIR, el mejor gestionado de la cartera)
INSERT INTO fact_proyecto_rendimiento (id_proyecto, id_tiempo, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_planificados, hitos_completados, tiene_baseline, tiene_forecast)
SELECT p.id_proyecto, t.id_tiempo, vals.pv, vals.ev, vals.ac, vals.bac, vals.eac, vals.fecha_fin_plan, vals.fecha_fin_forecast, vals.pct_completado, vals.hitos_plan, vals.hitos_comp, vals.tiene_b, vals.tiene_f
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    (20240930, 18000,  17000,  17500,  210000, 207000, '2025-05-31'::date, '2025-05-25'::date, 10.0, 1, 1, TRUE, TRUE),
    (20241031, 55000,  54000,  53000,  210000, 205000, '2025-05-31'::date, '2025-05-15'::date, 29.0, 2, 2, TRUE, TRUE),
    (20241130, 110000, 112000, 108000, 210000, 203000, '2025-05-31'::date, '2025-05-05'::date, 59.0, 3, 3, TRUE, TRUE),
    (20241231, 170000, 176000, 168000, 210000, 200000, '2025-05-31'::date, '2025-04-30'::date, 92.0, 4, 4, TRUE, TRUE)
) AS vals(id_tiempo_v, pv, ev, ac, bac, eac, fecha_fin_plan, fecha_fin_forecast, pct_completado, hitos_plan, hitos_comp, tiene_b, tiene_f)
WHERE p.codigo_proyecto = 'PRJ-2024-010' AND t.id_tiempo = vals.id_tiempo_v;

-- ============================================================
-- 9. HECHOS: Riesgos representativos
-- ============================================================
INSERT INTO fact_riesgo (id_proyecto, id_tiempo, id_tipo_riesgo, codigo_riesgo, descripcion_riesgo, probabilidad, impacto, estado, tiene_plan_respuesta, respuesta_eficaz, fecha_identificacion)
SELECT p.id_proyecto, t.id_tiempo, tr.id_tipo_riesgo, vals.codigo_r, vals.descripcion_r, vals.prob, vals.imp, vals.estado_r, vals.tiene_plan, vals.resp_eficaz, vals.fecha_id
FROM dim_proyecto p, dim_tiempo t, dim_tipo_riesgo tr,
(VALUES
    ('PRJ-2024-003', 20240131, 'Técnico',    'RSK-003-01', 'Incompatibilidad de datos históricos en migración',  4, 5, 'Mitigado',     TRUE,  TRUE,  '2024-01-25'::date),
    ('PRJ-2024-003', 20240229, 'RRHH',       'RSK-003-02', 'Rotación del equipo técnico clave',                  3, 4, 'Abierto',      TRUE,  NULL,  '2024-02-10'::date),
    ('PRJ-2024-005', 20240131, 'Financiero', 'RSK-005-01', 'Desviación presupuestaria por scope creep',          5, 5, 'Materializado',TRUE,  FALSE, '2024-01-20'::date),
    ('PRJ-2024-005', 20240331, 'Externo',    'RSK-005-02', 'Dependencia de proveedor de consultoría',            4, 4, 'Mitigado',     TRUE,  TRUE,  '2024-03-05'::date),
    ('PRJ-2024-005', 20240630, 'Técnico',    'RSK-005-03', 'Deuda técnica en sistemas legacy',                   3, 3, 'Abierto',      TRUE,  NULL,  '2024-06-15'::date),
    ('PRJ-2024-009', 20240831, 'RRHH',       'RSK-009-01', 'Falta de sponsor ejecutivo activo',                  5, 5, 'Materializado',FALSE, FALSE, '2024-08-25'::date),
    ('PRJ-2024-009', 20240930, 'Financiero', 'RSK-009-02', 'Presupuesto insuficiente para alcance real',         5, 4, 'Abierto',      FALSE, NULL,  '2024-09-10'::date),
    ('PRJ-2024-010', 20240930, 'Técnico',    'RSK-010-01', 'Complejidad de integración APIs legado',             4, 4, 'Abierto',      TRUE,  NULL,  '2024-09-08'::date),
    ('PRJ-2024-008', 20240731, 'Legal',      'RSK-008-01', 'Cambio en regulación GDPR durante auditoría',        3, 5, 'Cerrado',      TRUE,  TRUE,  '2024-07-20'::date),
    ('PRJ-2024-004', 20240430, 'Externo',    'RSK-004-01', 'Retraso en entrega de dispositivos móviles',         3, 3, 'Cerrado',      TRUE,  TRUE,  '2024-04-15'::date)
) AS vals(cod_proj, id_tiempo_v, cat_riesgo, codigo_r, descripcion_r, prob, imp, estado_r, tiene_plan, resp_eficaz, fecha_id)
WHERE p.codigo_proyecto = vals.cod_proj
  AND t.id_tiempo = vals.id_tiempo_v
  AND tr.categoria = vals.cat_riesgo;

-- ============================================================
-- 10. HECHOS: Stakeholders por proyecto y mes (selección)
-- ============================================================
INSERT INTO fact_stakeholder (id_proyecto, id_tiempo, num_stakeholders, satisfaccion_media, reuniones_plan, reuniones_real, tiene_stakeholder_register)
SELECT p.id_proyecto, t.id_tiempo, vals.num_stk, vals.satisfaccion, vals.reun_plan, vals.reun_real, vals.tiene_reg
FROM dim_proyecto p, dim_tiempo t,
(VALUES
    ('PRJ-2024-003', 20240131, 12, 3.8, 4, 4, TRUE),
    ('PRJ-2024-003', 20240630, 12, 4.0, 4, 4, TRUE),
    ('PRJ-2024-003', 20241231, 12, 4.3, 4, 4, TRUE),
    ('PRJ-2024-005', 20240131, 25, 2.5, 8, 5, TRUE),
    ('PRJ-2024-005', 20240630, 25, 3.2, 8, 7, TRUE),
    ('PRJ-2024-005', 20241231, 25, 3.8, 8, 8, TRUE),
    ('PRJ-2024-009', 20240831, 5,  2.0, 4, 1, FALSE),
    ('PRJ-2024-009', 20241231, 5,  1.8, 4, 1, FALSE),
    ('PRJ-2024-010', 20240930, 8,  3.5, 4, 3, TRUE),
    ('PRJ-2024-010', 20241231, 8,  3.8, 4, 4, TRUE)
) AS vals(cod_proj, id_tiempo_v, num_stk, satisfaccion, reun_plan, reun_real, tiene_reg)
WHERE p.codigo_proyecto = vals.cod_proj AND t.id_tiempo = vals.id_tiempo_v;

-- ============================================================
-- 11. HECHOS: Score de Madurez PMO por perspectiva y mes
-- (Estos son los datos que Power BI usa para el radar y evolución)
-- ============================================================
INSERT INTO fact_madurez_pmo (id_perspectiva, id_tiempo, score_perspectiva, nivel_madurez, num_proyectos_eval, notas)
SELECT p.id_perspectiva, t.id_tiempo, vals.score, vals.nivel::SMALLINT, vals.n_proj, vals.nota
FROM dim_perspectiva p, dim_tiempo t,
(VALUES
-- GOV: arranca en nivel 3, mejora a 4
    ('GOV', 20240131, 3.1, 3, 8,  'Mayoría proyectos con sponsor y acta'),
    ('GOV', 20240229, 3.1, 3, 8,  NULL),
    ('GOV', 20240331, 3.2, 3, 9,  NULL),
    ('GOV', 20240430, 3.3, 3, 9,  NULL),
    ('GOV', 20240531, 3.4, 3, 9,  NULL),
    ('GOV', 20240630, 3.6, 4, 10, 'Nuevos proyectos con mejor gobernanza'),
    ('GOV', 20240731, 3.7, 4, 10, NULL),
    ('GOV', 20240831, 3.7, 4, 10, NULL),
    ('GOV', 20240930, 3.8, 4, 10, NULL),
    ('GOV', 20241031, 3.9, 4, 10, NULL),
    ('GOV', 20241130, 3.9, 4, 10, NULL),
    ('GOV', 20241231, 4.0, 4, 10, 'Cierre de año: mejora consolidada en gobernanza'),
-- MGT: arranca en nivel 2, sube a 3
    ('MGT', 20240131, 2.3, 2, 8,  'SPI/CPI bajo por problemas PRJ-005'),
    ('MGT', 20240229, 2.3, 2, 8,  NULL),
    ('MGT', 20240331, 2.5, 2, 9,  NULL),
    ('MGT', 20240430, 2.7, 3, 9,  NULL),
    ('MGT', 20240531, 2.9, 3, 9,  NULL),
    ('MGT', 20240630, 3.0, 3, 10, NULL),
    ('MGT', 20240731, 3.1, 3, 10, NULL),
    ('MGT', 20240831, 3.2, 3, 10, NULL),
    ('MGT', 20240930, 3.3, 3, 10, NULL),
    ('MGT', 20241031, 3.4, 3, 10, NULL),
    ('MGT', 20241130, 3.5, 4, 10, NULL),
    ('MGT', 20241231, 3.6, 4, 10, 'Control EVM implantado en 80% de proyectos'),
-- BEN: estable en nivel 2
    ('BEN', 20240131, 2.0, 2, 8,  'Pocos proyectos con business case formal'),
    ('BEN', 20240229, 2.0, 2, 8,  NULL),
    ('BEN', 20240331, 2.1, 2, 9,  NULL),
    ('BEN', 20240430, 2.1, 2, 9,  NULL),
    ('BEN', 20240531, 2.2, 2, 9,  NULL),
    ('BEN', 20240630, 2.3, 2, 10, NULL),
    ('BEN', 20240731, 2.3, 2, 10, NULL),
    ('BEN', 20240831, 2.4, 2, 10, NULL),
    ('BEN', 20240930, 2.5, 2, 10, NULL),
    ('BEN', 20241031, 2.6, 3, 10, NULL),
    ('BEN', 20241130, 2.7, 3, 10, NULL),
    ('BEN', 20241231, 2.8, 3, 10, 'Iniciativa PIR lanzada en Q4'),
-- RSK: nivel 3, mejora a 4
    ('RSK', 20240131, 2.8, 3, 8,  NULL),
    ('RSK', 20240229, 2.9, 3, 8,  NULL),
    ('RSK', 20240331, 3.0, 3, 9,  NULL),
    ('RSK', 20240430, 3.1, 3, 9,  NULL),
    ('RSK', 20240531, 3.2, 3, 9,  NULL),
    ('RSK', 20240630, 3.3, 3, 10, NULL),
    ('RSK', 20240731, 3.4, 3, 10, NULL),
    ('RSK', 20240831, 3.5, 4, 10, NULL),
    ('RSK', 20240930, 3.6, 4, 10, NULL),
    ('RSK', 20241031, 3.7, 4, 10, NULL),
    ('RSK', 20241130, 3.8, 4, 10, NULL),
    ('RSK', 20241231, 3.9, 4, 10, '85% riesgos con plan de respuesta'),
-- STK: nivel 3 estable
    ('STK', 20240131, 3.0, 3, 8,  NULL),
    ('STK', 20240229, 3.0, 3, 8,  NULL),
    ('STK', 20240331, 3.1, 3, 9,  NULL),
    ('STK', 20240430, 3.1, 3, 9,  NULL),
    ('STK', 20240531, 3.2, 3, 9,  NULL),
    ('STK', 20240630, 3.2, 3, 10, NULL),
    ('STK', 20240731, 3.3, 3, 10, NULL),
    ('STK', 20240831, 3.3, 3, 10, NULL),
    ('STK', 20240930, 3.4, 3, 10, NULL),
    ('STK', 20241031, 3.5, 4, 10, NULL),
    ('STK', 20241130, 3.5, 4, 10, NULL),
    ('STK', 20241231, 3.6, 4, 10, NULL),
-- FIN: nivel 2, sube a 3
    ('FIN', 20240131, 1.8, 2, 8,  'Desviación alta por PRJ-005'),
    ('FIN', 20240229, 1.9, 2, 8,  NULL),
    ('FIN', 20240331, 2.0, 2, 9,  NULL),
    ('FIN', 20240430, 2.2, 2, 9,  NULL),
    ('FIN', 20240531, 2.4, 2, 9,  NULL),
    ('FIN', 20240630, 2.5, 2, 10, NULL),
    ('FIN', 20240731, 2.6, 3, 10, NULL),
    ('FIN', 20240831, 2.7, 3, 10, NULL),
    ('FIN', 20240930, 2.8, 3, 10, NULL),
    ('FIN', 20241031, 2.9, 3, 10, NULL),
    ('FIN', 20241130, 3.0, 3, 10, NULL),
    ('FIN', 20241231, 3.1, 3, 10, 'Forecast mensual implantado en todos los proyectos'),
-- RES: nivel 3 estable
    ('RES', 20240131, 3.2, 3, 8,  NULL),
    ('RES', 20240229, 3.2, 3, 8,  NULL),
    ('RES', 20240331, 3.3, 3, 9,  NULL),
    ('RES', 20240430, 3.3, 3, 9,  NULL),
    ('RES', 20240531, 3.4, 3, 9,  NULL),
    ('RES', 20240630, 3.5, 4, 10, NULL),
    ('RES', 20240731, 3.5, 4, 10, NULL),
    ('RES', 20240831, 3.5, 4, 10, NULL),
    ('RES', 20240930, 3.6, 4, 10, NULL),
    ('RES', 20241031, 3.6, 4, 10, NULL),
    ('RES', 20241130, 3.7, 4, 10, NULL),
    ('RES', 20241231, 3.8, 4, 10, NULL)
) AS vals(cod_persp, id_tiempo_v, score, nivel, n_proj, nota)
WHERE p.codigo = vals.cod_persp AND t.id_tiempo = vals.id_tiempo_v;
