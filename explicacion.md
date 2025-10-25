# Explicación del Análisis para Determinar las Top 5 Plantas Menos Confiables

## Introducción
El objetivo fue calcular las top 5 plantas menos confiables basadas en la información de la base de datos PostgreSQL, utilizando el servidor MCP para consultas SQL. La confiabilidad se interpretó como la consistencia en los reportes de energía, midiendo discrepancias entre valores registrados y verificados/despachados.

## Pasos Realizados

### 1. Exploración de la Estructura de la Base de Datos
- **Consulta 1**: Listar todas las tablas y esquemas para entender la estructura.
  ```sql
  SELECT table_schema, table_name FROM information_schema.tables ORDER BY table_schema, table_name;
  ```
  - Resultado: Se identificaron tablas en el esquema "public" como `plantas`, `agentes`, `ddv_reg_vs_ddv_ver`, `ddv_verificada`, `msec_reg_vs_msec_desp`, `recursos`, etc.

- **Consulta 2**: Listar todos los esquemas.
  ```sql
  SELECT schema_name FROM information_schema.schemata ORDER BY schema_name;
  ```
  - Resultado: Solo se encontraron esquemas del sistema (`information_schema`, `pg_catalog`, `public`, etc.). No se encontraron los esquemas mencionados en los recursos MCP como `cargo_confiabilidad` o `planta`.

- **Consulta 3**: Listar vistas para verificar si hay vistas relevantes.
  ```sql
  SELECT table_schema, table_name FROM information_schema.views ORDER BY table_schema, table_name;
  ```
  - Resultado: Solo vistas del sistema, sin vistas definidas por el usuario en `public`.

- **Consulta 4**: Obtener columnas de la tabla `plantas`.
  ```sql
  SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'plantas' AND table_schema = 'public' ORDER BY ordinal_position;
  ```
  - Resultado: La tabla `plantas` tiene columnas `id` (integer) y `nombre` (text). No hay campos directos de confiabilidad.

### 2. Identificación de Métricas de Confiabilidad
- Basado en el archivo `db.sql`, se identificaron tablas relevantes para el análisis de energía:
  - `ddv_reg_vs_ddv_ver`: Contiene `kwh_registrado` y `kwh_verificado` por planta y agente.
  - `msec_reg_vs_msec_desp`: Contiene `kwh_registrado` y `kwh_despachado` por planta y agente.
- La lógica para medir confiabilidad: Las discrepancias entre valores registrados y verificados/despachados indican falta de confiabilidad. Se calculó la diferencia absoluta promedio para cada planta.
- **Consulta 5**: Verificar cantidad de datos en `ddv_reg_vs_ddv_ver`.
  ```sql
  SELECT COUNT(*) FROM ddv_reg_vs_ddv_ver;
  ```
  - Resultado: 20 filas.

- **Consulta 6**: Verificar cantidad de datos en `msec_reg_vs_msec_desp`.
  ```sql
  SELECT COUNT(*) FROM msec_reg_vs_msec_desp;
  ```
  - Resultado: 20 filas.

### 3. Cálculo de las Top 5 Plantas Menos Confiables
- **Métrica**: Para cada planta, se calculó el promedio de la diferencia absoluta entre `kwh_registrado` y `kwh_verificado` (de `ddv_reg_vs_ddv_ver`) y entre `kwh_registrado` y `kwh_despachado` (de `msec_reg_vs_msec_desp`). La suma de estos promedios se usó como indicador de falta de confiabilidad (valores más altos indican menos confiabilidad).
- **Consulta Principal**: Obtener todas las plantas ordenadas por la métrica de discrepancia.
  ```sql
  SELECT p.nombre, (AVG(ABS(d.kwh_registrado - d.kwh_verificado)) + AVG(ABS(m.kwh_registrado - m.kwh_despachado))) as total_avg_diff
  FROM plantas p
  LEFT JOIN ddv_reg_vs_ddv_ver d ON p.id = d.planta_id
  LEFT JOIN msec_reg_vs_msec_desp m ON p.id = m.planta_id
  GROUP BY p.id, p.nombre
  ORDER BY total_avg_diff DESC;
  ```
  - Resultado: Las plantas con `total_avg_diff` de 3000 son las menos confiables. Las top 5 son: Planta E, Planta K, Planta I, Planta O, Planta C.

- **Consulta para Top 5 Específica**:
  ```sql
  SELECT p.nombre, AVG(ABS(d.kwh_registrado - d.kwh_verificado)) as avg_diff_ddv, AVG(ABS(m.kwh_registrado - m.kwh_despachado)) as avg_diff_msec, (AVG(ABS(d.kwh_registrado - d.kwh_verificado)) + AVG(ABS(m.kwh_registrado - m.kwh_despachado))) as total_avg_diff
  FROM plantas p
  LEFT JOIN ddv_reg_vs_ddv_ver d ON p.id = d.planta_id
  LEFT JOIN msec_reg_vs_msec_desp m ON p.id = m.planta_id
  GROUP BY p.id, p.nombre
  ORDER BY total_avg_diff DESC
  LIMIT 5;
  ```
  - Resultado: Confirmó las top 5 con `total_avg_diff` de 3000.

## Lógica y Justificación
- **Definición de Confiabilidad**: En el contexto de "cargo por confiabilidad", la confiabilidad se mide por la precisión en los reportes de energía. Discrepancias grandes sugieren problemas en la operación o reporte, indicando menor confiabilidad.
- **Por qué esta Métrica**: Las tablas `ddv_reg_vs_ddv_ver` y `msec_reg_vs_msec_desp` proporcionan datos comparativos directos. El promedio de diferencias absolutas normaliza por el número de registros por planta.
- **Limitaciones**: Los datos parecen ser de prueba (valores idénticos para muchas plantas). En un escenario real, se podrían usar métricas adicionales como ratios o datos históricos.

## Resultados Obtenidos
Basado en la consulta principal, los resultados para las top 5 plantas menos confiables son:

1. **Planta E** - Diferencia promedio DDV: 2000, Diferencia promedio MSEC: 1000, Total: 3000
2. **Planta K** - Diferencia promedio DDV: 2000, Diferencia promedio MSEC: 1000, Total: 3000
3. **Planta I** - Diferencia promedio DDV: 2000, Diferencia promedio MSEC: 1000, Total: 3000
4. **Planta O** - Diferencia promedio DDV: 2000, Diferencia promedio MSEC: 1000, Total: 3000
5. **Planta C** - Diferencia promedio DDV: 2000, Diferencia promedio MSEC: 1000, Total: 3000

Estas plantas muestran las mayores inconsistencias en sus reportes de energía, indicando menor confiabilidad.

## Conclusión
Las top 5 plantas menos confiables son Planta E, Planta K, Planta I, Planta O y Planta C, basadas en las discrepancias calculadas. Este análisis se realizó utilizando consultas SQL a través del servidor MCP PostgreSQL.