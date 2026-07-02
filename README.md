# Sistema BI para la Evaluación de Madurez de una PMO basado en el modelo P3M3

**TFG — Grado en Ingeniería Informática · Universidad Nebrija · Alberto González-Calero López**

Sistema de Business Intelligence que transforma datos operativos de gestión de proyectos en scores de madurez P3M3, eliminando la dependencia de cuestionarios subjetivos. El sistema produce un score global de madurez calculado automáticamente y lo visualiza en un dashboard interactivo de cinco páginas analíticas.

---

## Componentes del sistema

| Archivo | Descripción |
|---|---|
| `02_schema_postgresql.sql` | Crea el esquema de la base de datos: 7 tablas de dimensión, 7 tablas de hechos, 3 vistas analíticas e índices de rendimiento. |
| `03_datos_simulados.sql` | Puebla la base de datos con el dataset simulado: 10 proyectos, 12 meses de datos (enero–diciembre 2024) y 23 KPIs P3M3. |
| `CM_Medicion_Madurez_PMO.pbix` | Dashboard de Power BI con 5 páginas analíticas y 9 medidas DAX. Los datos están embebidos en modo Import: **solo se necesita Power BI Desktop para abrirlo**. |

---

## Requisitos previos

- [PostgreSQL 17](https://www.postgresql.org/download/) o superior
- [pgAdmin 4](https://www.pgadmin.org/) (administración y ejecución de scripts SQL)
- [Power BI Desktop](https://powerbi.microsoft.com/desktop/) versión mayo 2026 o posterior

---

## Instrucciones de despliegue

### 1 — Crear la base de datos

Abre pgAdmin 4, conéctate al servidor PostgreSQL y crea una base de datos nueva llamada `pmo_bi`.

### 2 — Ejecutar el esquema

En el Query Tool de pgAdmin, sobre la base de datos `pmo_bi`, ejecuta el primer script:

```sql
-- Ejecutar primero
\i 02_schema_postgresql.sql
```

Esto crea las 14 tablas, las 3 vistas analíticas y los índices de rendimiento. Si la ejecución finaliza sin errores, la estructura está lista.

### 3 — Cargar los datos simulados

A continuación, ejecuta el segundo script en el mismo Query Tool:

```sql
-- Ejecutar en segundo lugar
\i 03_datos_simulados.sql
```

Para verificar que la carga fue correcta:

```sql
SELECT * FROM v_score_global_pmo ORDER BY anio, mes;
-- Debe devolver 12 filas (enero–diciembre 2024) con Score Global ≈ 3,53 en diciembre.
```

### 4 — Abrir el dashboard

El archivo `CM_Medicion_Madurez_PMO.pbix` **funciona directamente sin necesidad de conectar a PostgreSQL**: los datos están embebidos en modo Import. Ábrelo con Power BI Desktop y el dashboard estará operativo.

Si quieres reconectar el modelo a tu propia instancia de PostgreSQL para trabajar con datos reales, ve a **Inicio → Transformar datos → Configuración del origen de datos** y actualiza los parámetros de conexión:

| Parámetro | Valor |
|---|---|
| Servidor | `localhost` (o la IP del servidor) |
| Base de datos | `pmo_bi` |
| Modo | Import |

---

## Estructura del modelo de datos

```
dim_perspectiva ──┬──► fact_madurez_pmo
                  └──► fact_kpi_snapshot
dim_tiempo ───────┬──► fact_madurez_pmo
                  ├──► fact_proyecto_rendimiento
                  ├──► fact_riesgo
                  ├──► fact_stakeholder
                  ├──► fact_beneficio
                  ├──► fact_recurso_asignacion
                  └──► fact_kpi_snapshot
dim_proyecto ─────┬──► fact_proyecto_rendimiento
                  ├──► fact_riesgo
                  ├──► fact_stakeholder
                  ├──► fact_beneficio
                  ├──► fact_recurso_asignacion
                  └──► fact_kpi_snapshot
dim_kpi ──────────►  fact_kpi_snapshot
dim_recurso ──────►  fact_recurso_asignacion
dim_tipo_riesgo ──►  fact_riesgo
dim_nivel_madurez ►  fact_madurez_pmo
```

---

## Resultados del sistema

El dataset simulado produce un **score global de madurez de 3,03 sobre 5** (media del ejercicio 2024), equivalente al nivel **"Defined"** del modelo P3M3. Las perspectivas con mayor margen de mejora son Gestión de Beneficios (2,33) y Gestión Financiera (2,49).

---

## Tecnologías utilizadas

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-336791?logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-F2C811?logo=powerbi&logoColor=black)
![License](https://img.shields.io/badge/Licencia-Académica-lightgrey)

---

*Trabajo de Fin de Grado · Grado en Ingeniería Informática · Universidad Nebrija · Junio 2026*
