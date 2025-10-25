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

## Modelo Relacional

```mermaid
erDiagram
    SISTEMA {
        int id PK
        string nombre
        string tipo
        string relevancia_rd
        string funcion
        string indicador_clave
        string nombre_completo
    }
    MECANISMO {
        int id PK
        string descripcion
        string nombre
        string tipo
        string problema
        string funcion
    }
    PROBLEMA {
        int id PK
        string descripcion
        string riesgo
        string impacto
        string mecanismo
        string categoria
        string consecuencia
        string capas
        string evidencia
        string temas_ambiguos
    }
    RECOMENDACION {
        int id PK
        string impacto_esperado
        string descripcion
        string objetivo
        string caso_ejemplo
        string prioridad
    }
    DOCUMENTO {
        int id PK
        string tipo
        string codigo
        string descripcion
        string proposito
        string relevancia
        string problema_identificado
    }
    ORGANIZACION {
        int id PK
        string tipo
        string rol
        string nombre
    }
    RESOLUCION {
        int id PK
        string descripcion
        string articulo
        string formula_ihf
        string codigo
        date fecha
        string estado
        string efecto
    }
    COMUNICACION {
        int id PK
        string asunto
        string emisor
        string codigo
        date fecha
        string receptor
    }
    RIESGO {
        int id PK
        string categoria
        string impacto
        string nombre
        string descripcion
        string causa
        string momento
        string momento_critico
        string efecto_cascada
    }
    CONCEPTO {
        int id PK
        string proposito
        string nombre
        string objetivo
        string contexto
        string tipo
        string problema_identificado
        string componentes
    }
    METRICA {
        int id PK
        string nombre
        string tipo
        string relacion_con_ihf
        string impacto
        string nombre_completo
        string definicion
    }
    OBLIGACION {
        int id PK
        string tipo
        string definicion
        string incentivo_financiero
        string nombre
        string riesgo
        string nombre_completo
    }
    CONSECUENCIA {
        int id PK
        string nombre
        string tipo
        string impacto
        string causa_directa
        string efecto_en_planeacion
        string descripcion
        string categoria
        string realidad
        string visibilidad
        string caracterizacion
    }
    CONDICION {
        int id PK
        string relacionado_con
        string tipo
        string problema_identificado
        string relevancia
        string nombre
        string descripcion
    }
    COMPORTAMIENTO {
        int id PK
        string descripcion
        string mecanismo
        string consecuencia
        string nombre
        string vacio_regulatorio
        string tipo
    }
    PLANTA {
        int id PK
        string nombre
        string tipo
        real capacidad_mw
        real ihf
        real enficc
        real oef
        string estado
    }
    HIDROLOGIA {
        int id PK
        string nombre
        string tipo
        string descripcion
        string impacto_en_ihf
        string severidad
    }
    ANILLO_SEGURIDAD {
        int id PK
        string nombre
        string tipo
        string descripcion
        string efecto_en_ihf
        string regulacion
    }
    MERCADO {
        int id PK
        string nombre
        string tipo
        string descripcion
        string funcion
        string impacto_en_confiabilidad
    }
    CARGO_CONFIABILIDAD {
        int id PK
        string nombre
        string descripcion
        string formula
        string periodo
        string estado
    }
    RELATIONSHIPS {
        int id PK
        string from_table
        int from_id
        string to_table
        int to_id
        string type
    }

    SISTEMA ||--o{ MECANISMO : "PERTENECE_A"
    MECANISMO ||--o{ PROBLEMA : "AFECTA_A"
    PROBLEMA ||--o{ RIESGO : "GENERA"
    PROBLEMA ||--o{ RECOMENDACION : "SOLUCIONA"
    PROBLEMA ||--o{ DOCUMENTO : "SOPORTA"
    MECANISMO ||--o{ RESOLUCION : "DEFINE"
    MECANISMO ||--o{ COMUNICACION : "ABORDA"
    MECANISMO ||--o{ METRICA : "RELACIONADA_CON"
    METRICA ||--o{ OBLIGACION : "BASADA_EN"
    PROBLEMA ||--o{ CONSECUENCIA : "RESULTA_DE"
    RIESGO ||--o{ CONDICION : "AGRAVA"
    MECANISMO ||--o{ COMPORTAMIENTO : "UTILIZA"
    PLANTA ||--o{ METRICA : "TIENE"
    PLANTA ||--o{ OBLIGACION : "CUMPLE"
    HIDROLOGIA ||--o{ MECANISMO : "AFECTA"
    ANILLO_SEGURIDAD ||--o{ MECANISMO : "MODIFICA"
    MERCADO ||--o{ MECANISMO : "ES_TIPO_DE"
    CARGO_CONFIABILIDAD ||--o{ METRICA : "USA"
    CARGO_CONFIABILIDAD ||--o{ OBLIGACION : "REMUNERA"
    PROBLEMA }o--o{ MECANISMO : "relationships"
    RIESGO }o--o{ MECANISMO : "relationships"
    METRICA }o--o{ MECANISMO : "relationships"
    OBLIGACION }o--o{ METRICA : "relationships"
    CONSECUENCIA }o--o{ PROBLEMA : "relationships"
    CONDICION }o--o{ RIESGO : "relationships"
    COMPORTAMIENTO }o--o{ MECANISMO : "relationships"
    PLANTA }o--o{ METRICA : "relationships"
    PLANTA }o--o{ OBLIGACION : "relationships"
    HIDROLOGIA }o--o{ MECANISMO : "relationships"
    ANILLO_SEGURIDAD }o--o{ MECANISMO : "relationships"
    MERCADO }o--o{ MECANISMO : "relationships"
    CARGO_CONFIABILIDAD }o--o{ METRICA : "relationships"
    CARGO_CONFIABILIDAD }o--o{ OBLIGACION : "relationships"
```