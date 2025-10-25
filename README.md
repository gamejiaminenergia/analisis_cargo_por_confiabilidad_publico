# Análisis de Cargo por Confiabilidad - Base de Datos PostgreSQL

Este proyecto contiene un esquema de base de datos PostgreSQL para el análisis cuantitativo de temas relacionados con la confiabilidad en sistemas eléctricos.

## Estructura del Proyecto

- `db.sql`: Esquema completo de la base de datos con tablas, índices y vistas para análisis cuantitativo.
- `db_data_test.sql`: Datos de prueba para poblar la base de datos.
- `import.py`: Script de Python para interactuar con la base de datos.
- `requirements.txt`: Dependencias de Python.
- `.gitignore`: Archivos a ignorar en el control de versiones.
- `explicacion.md`: Documentación detallada del análisis para determinar las top 5 plantas menos confiables, incluyendo pasos, lógica y consultas SQL.

## Requisitos

- PostgreSQL instalado y ejecutándose.
- Conexión a la base de datos (por defecto: `postgresql://postgres:postgres@localhost:5432/postgres`).
- Python 3.x instalado.
- Dependencias de Python (instala con `pip install -r requirements.txt`).

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

4. **Configurar Python**:
   - Instala las dependencias: `pip install -r requirements.txt`
   - Usa scripts como `import.py` para interactuar con la base de datos.

## Estructura de la Base de Datos

### Tablas Principales (Activas)
Las siguientes tablas están activas en el esquema actual y se utilizan para el análisis de confiabilidad de plantas eléctricas.

- **plantas**:
  - `id` (integer): Identificador único de la planta.
  - `nombre` (text): Nombre de la planta eléctrica.

- **agentes**:
  - `id` (integer): Identificador único del agente.
  - `nombre` (text): Nombre del agente involucrado en el sistema.

- **rrid_antes_066_24**:
  - `id` (integer): Identificador único del registro.
  - `planta_id` (integer): Referencia a la planta (FK a plantas.id).
  - `rrid_cop` (bigint): Valor de RRID en COP antes de la resolución 066-24 (índice de confiabilidad).
  - `rrid_sin_anillos_cop` (bigint): Valor de RRID sin anillos en COP.

- **rrid_despues_066_24**:
  - `id` (integer): Identificador único del registro.
  - `planta_id` (integer): Referencia a la planta (FK a plantas.id).
  - `rrid_cop` (bigint): Valor de RRID en COP después de la resolución 066-24.
  - `rrid_sin_anillos_cop` (bigint): Valor de RRID sin anillos en COP.

- **ddv_reg_vs_ddv_ver**:
  - `id` (integer): Identificador único del registro.
  - `planta_id` (integer): Referencia a la planta (FK a plantas.id).
  - `agente_id` (integer): Referencia al agente (FK a agentes.id).
  - `fecha_dia` (date): Fecha del registro.
  - `kwh_registrado` (bigint): Energía registrada en kWh.
  - `kwh_verificado` (bigint): Energía verificada en kWh.

- **ddv_verificada**:
  - `id` (integer): Identificador único del registro.
  - `planta_id` (integer): Referencia a la planta (FK a plantas.id).
  - `agente_id` (integer): Referencia al agente (FK a agentes.id).
  - `fecha_dia` (date): Fecha del registro.
  - `kwh_verificado` (bigint): Energía verificada en kWh.

- **msec_reg_vs_msec_desp**:
  - `id` (integer): Identificador único del registro.
  - `planta_id` (integer): Referencia a la planta (FK a plantas.id).
  - `agente_id` (integer): Referencia al agente (FK a agentes.id).
  - `kwh_registrado` (bigint): Energía registrada en kWh.
  - `kwh_despachado` (bigint): Energía despachada en kWh.

- **recursos**:
  - `id` (integer): Identificador único del recurso.
  - `codigo_sic` (text): Código SIC del recurso.
  - `tipo_generacion` (text): Tipo de generación (e.g., hidráulica, térmica).

- **mapeo_recursos**:
  - `id` (integer): Identificador único del mapeo.
  - `recurso_id` (integer): Referencia al recurso (FK a recursos.id).
  - `agente_id` (integer): Referencia al agente (FK a agentes.id).

- **mapeo_agentes**:
  - `id` (integer): Identificador único del mapeo.
  - `recurso_id` (integer): Referencia al recurso (FK a recursos.id).
  - `agente_id` (integer): Referencia al agente (FK a agentes.id).
  - `planta_id` (integer): Referencia a la planta (FK a plantas.id).

### Tablas Comentadas (No Activas)
Las siguientes tablas están comentadas en el esquema y no se utilizan en el análisis actual, pero representan entidades adicionales para análisis más amplio.

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
3. **Usar Python para Análisis**:
    - Ejecuta scripts de Python como `import.py` para interactuar con la base de datos y realizar análisis adicionales.

## Análisis de Confiabilidad de Plantas

Este análisis fue realizado por una inteligencia artificial (Kilo Code) utilizando el protocolo Model Context Protocol (MCP) para conectar y consultar la base de datos PostgreSQL. Se determinaron las top 5 plantas menos confiables basado en discrepancias en los reportes de energía (diferencias entre kWh registrados y verificados/despachados). El análisis utiliza consultas SQL para calcular métricas de inconsistencia.

- **Top 5 Plantas Menos Confiables**:
  1. Planta E
  2. Planta K
  3. Planta I
  4. Planta O
  5. Planta C

Para detalles completos, incluyendo pasos, lógica y consultas SQL, consulta `explicacion.md`.

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

## Modelo Relacional

```mermaid
erDiagram
    PLANTAS {
        int id PK
        string nombre
    }
    AGENTES {
        int id PK
        string nombre
    }
    RECURSOS {
        int id PK
        string codigo_sic
        string tipo_generacion
    }
    RRID_ANTES_066_24 {
        int id PK
        int planta_id FK
        bigint rrid_cop
        bigint rrid_sin_anillos_cop
    }
    RRID_DESPUES_066_24 {
        int id PK
        int planta_id FK
        bigint rrid_cop
        bigint rrid_sin_anillos_cop
    }
    DDV_REG_VS_DDV_VER {
        int id PK
        int planta_id FK
        int agente_id FK
        date fecha_dia
        bigint kwh_registrado
        bigint kwh_verificado
    }
    DDV_VERIFICADA {
        int id PK
        int planta_id FK
        int agente_id FK
        date fecha_dia
        bigint kwh_verificado
    }
    MSEC_REG_VS_MSEC_DESP {
        int id PK
        int planta_id FK
        int agente_id FK
        bigint kwh_registrado
        bigint kwh_despachado
    }
    MAPEO_RECURSOS {
        int id PK
        int recurso_id FK
        int agente_id FK
    }
    MAPEO_AGENTES {
        int id PK
        int recurso_id FK
        int agente_id FK
        int planta_id FK
    }

    PLANTAS ||--o{ RRID_ANTES_066_24 : has
    PLANTAS ||--o{ RRID_DESPUES_066_24 : has
    PLANTAS ||--o{ DDV_REG_VS_DDV_VER : has
    PLANTAS ||--o{ DDV_VERIFICADA : has
    PLANTAS ||--o{ MSEC_REG_VS_MSEC_DESP : has
    PLANTAS ||--o{ MAPEO_AGENTES : has
    AGENTES ||--o{ DDV_REG_VS_DDV_VER : has
    AGENTES ||--o{ DDV_VERIFICADA : has
    AGENTES ||--o{ MSEC_REG_VS_MSEC_DESP : has
    AGENTES ||--o{ MAPEO_RECURSOS : has
    AGENTES ||--o{ MAPEO_AGENTES : has
    RECURSOS ||--o{ MAPEO_RECURSOS : has
    RECURSOS ||--o{ MAPEO_AGENTES : has
```