# Análisis de Cargo por Confiabilidad - Base de Datos PostgreSQL

Este proyecto contiene un esquema de base de datos PostgreSQL basado en la estructura de una base de datos Neo4j para el análisis cuantitativo de temas relacionados con la confiabilidad en sistemas eléctricos.

## Estructura del Proyecto

- `db.sql`: Esquema completo de la base de datos con tablas, índices y vistas para análisis cuantitativo.
- `db_data_test.sql`: Datos de prueba para poblar la base de datos.
- `.gitignore`: Archivos a ignorar en el control de versiones.

## Requisitos

- PostgreSQL instalado y ejecutándose.
- Conexión a la base de datos (por defecto: `postgresql://postgres:postgres@localhost:5432/postgres`).

## Instalación y Configuración

1. **Crear la Base de Datos**:
   - Asegúrate de que PostgreSQL esté ejecutándose.
   - Conecta a PostgreSQL y crea una base de datos si es necesario (opcional, ya que el script usa la base por defecto).

2. **Ejecutar el Esquema**:
   ```bash
   psql postgresql://postgres:postgres@localhost:5432/postgres -f db.sql
   ```
   Esto crea todas las tablas, índices y vistas.

3. **Poblar con Datos de Prueba**:
   ```bash
   psql postgresql://postgres:postgres@localhost:5432/postgres -f db_data_test.sql
   ```
   Esto inserta datos de ejemplo para análisis.

## Estructura de la Base de Datos

### Tablas Principales
- **sistema**: Sistemas eléctricos (e.g., Transmisión, Generación).
- **mecanismo**: Mecanismos de control y protección.
- **problema**: Problemas que afectan los mecanismos.
- **riesgo**: Riesgos asociados.
- **recomendacion**: Recomendaciones para solucionar problemas.
- **resolucion**: Resoluciones regulatorias.
- **documento**: Documentos de soporte.
- **comunicacion**: Comunicaciones entre entidades.
- **organizacion**: Organizaciones involucradas.
- **concepto**: Conceptos abstractos.
- **metrica**: Métricas de evaluación.
- **obligacion**: Obligaciones legales y contractuales.
- **consecuencia**: Consecuencias de riesgos.
- **condicion**: Condiciones que influyen en problemas.
- **comportamiento**: Comportamientos de los mecanismos.
- **relationships**: Relaciones entre nodos.

### Vistas para Análisis Cuantitativo
- `node_counts`: Conteo de nodos por tipo.
- `relationship_counts`: Conteo de relaciones por tipo.
- `problem_impact_summary`: Resumen de problemas por impacto.
- `risk_category_summary`: Resumen de riesgos por categoría.
- `system_mechanisms`: Sistemas y sus mecanismos asociados.
- `mechanism_problems`: Mecanismos y problemas que los afectan.
- `resolution_timeline`: Resoluciones por año.
- `communication_summary`: Comunicaciones por emisor.

## Uso

1. **Conectar a la Base de Datos**:
   Usa un cliente como psql, pgAdmin, o una aplicación que se conecte a PostgreSQL.

2. **Consultas de Análisis**:
   - Ver conteos: `SELECT * FROM node_counts;`
   - Ver impactos: `SELECT * FROM problem_impact_summary;`
   - Ver riesgos: `SELECT * FROM risk_category_summary;`

3. **Cargar Datos Reales**:
   - Exporta datos de Neo4j usando Cypher queries como `MATCH (n) RETURN labels(n), properties(n)`.
   - Convierte a INSERT statements y ejecútalos en PostgreSQL.

## Análisis Cuantitativo

El esquema permite calcular temas como:
- Número de problemas por impacto.
- Riesgos por categoría.
- Mecanismos por sistema.
- Relaciones entre entidades.

## Contribución

1. Haz cambios en los archivos SQL.
2. Prueba con datos de prueba.
3. Actualiza este README si es necesario.

## Licencia

Este proyecto es para fines educativos y de análisis.