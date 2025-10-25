# Análisis de Cargo por Confiabilidad - Base de Datos PostgreSQL

Este proyecto contiene un esquema de base de datos PostgreSQL para el análisis cuantitativo de temas relacionados con la confiabilidad en sistemas eléctricos.

## Estructura del Proyecto

- `db.sql`: Esquema completo de la base de datos con tablas, índices y vistas para análisis cuantitativo.
- `db_data_test.sql`: Datos de prueba para poblar la base de datos.
- `import.py`: Script de Python para interactuar con la base de datos.
- `requirements.txt`: Dependencias de Python.
- `.gitignore`: Archivos a ignorar en el control de versiones.

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
3. **Usar Python para Análisis**:
   - Ejecuta scripts de Python como `import.py` para interactuar con la base de datos y realizar análisis adicionales.


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