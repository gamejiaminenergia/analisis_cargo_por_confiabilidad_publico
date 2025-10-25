-- PostgreSQL schema based on detailed Neo4j graph structure for quantitative analysis
-- Updated with complete properties for each node type
-- Graph schema commented out as per import.py analysis

-- -- Create tables for each node type with specific columns

-- -- Sistema table
-- CREATE TABLE sistema (
--     id SERIAL PRIMARY KEY,
--     nombre TEXT,
--     tipo TEXT,
--     relevancia_rd TEXT,
--     funcion TEXT,
--     indicador_clave TEXT,
--     nombre_completo TEXT
-- );

-- -- Mecanismo table
-- CREATE TABLE mecanismo (
--     id SERIAL PRIMARY KEY,
--     descripcion TEXT,
--     nombre TEXT,
--     tipo TEXT,
--     problema TEXT,
--     funcion TEXT
-- );

-- -- Problema table
-- CREATE TABLE problema (
--     id SERIAL PRIMARY KEY,
--     descripcion TEXT,
--     riesgo TEXT,
--     impacto TEXT,
--     mecanismo TEXT,
--     categoria TEXT,
--     consecuencia TEXT,
--     capas TEXT,
--     evidencia TEXT,
--     temas_ambiguos TEXT
-- );

-- -- Recomendacion table
-- CREATE TABLE recomendacion (
--     id SERIAL PRIMARY KEY,
--     impacto_esperado TEXT,
--     descripcion TEXT,
--     objetivo TEXT,
--     caso_ejemplo TEXT,
--     prioridad TEXT
-- );

-- -- Documento table
-- CREATE TABLE documento (
--     id SERIAL PRIMARY KEY,
--     tipo TEXT,
--     codigo TEXT,
--     descripcion TEXT,
--     proposito TEXT,
--     relevancia TEXT,
--     problema_identificado TEXT
-- );

-- -- Organizacion table
-- CREATE TABLE organizacion (
--     id SERIAL PRIMARY KEY,
--     tipo TEXT,
--     rol TEXT,
--     nombre TEXT
-- );

-- -- Resolucion table
-- CREATE TABLE resolucion (
--     id SERIAL PRIMARY KEY,
--     descripcion TEXT,
--     articulo TEXT,
--     formula_ihf TEXT,
--     codigo TEXT,
--     fecha DATE,
--     estado TEXT,
--     efecto TEXT
-- );

-- -- Comunicacion table
-- CREATE TABLE comunicacion (
--     id SERIAL PRIMARY KEY,
--     asunto TEXT,
--     emisor TEXT,
--     codigo TEXT,
--     fecha DATE,
--     receptor TEXT
-- );

-- -- Riesgo table
-- CREATE TABLE riesgo (
--     id SERIAL PRIMARY KEY,
--     categoria TEXT,
--     impacto TEXT,
--     nombre TEXT,
--     descripcion TEXT,
--     causa TEXT,
--     momento TEXT,
--     momento_critico TEXT,
--     efecto_cascada TEXT
-- );

-- -- Concepto table
-- CREATE TABLE concepto (
--     id SERIAL PRIMARY KEY,
--     proposito TEXT,
--     nombre TEXT,
--     objetivo TEXT,
--     contexto TEXT,
--     tipo TEXT,
--     problema_identificado TEXT,
--     componentes TEXT
-- );

-- -- Metrica table
-- CREATE TABLE metrica (
--     id SERIAL PRIMARY KEY,
--     nombre TEXT,
--     tipo TEXT,
--     relacion_con_ihf TEXT,
--     impacto TEXT,
--     nombre_completo TEXT,
--     definicion TEXT
-- );

-- -- Obligacion table
-- CREATE TABLE obligacion (
--     id SERIAL PRIMARY KEY,
--     tipo TEXT,
--     definicion TEXT,
--     incentivo_financiero TEXT,
--     nombre TEXT,
--     riesgo TEXT,
--     nombre_completo TEXT
-- );

-- -- Consecuencia table
-- CREATE TABLE consecuencia (
--     id SERIAL PRIMARY KEY,
--     nombre TEXT,
--     tipo TEXT,
--     impacto TEXT,
--     causa_directa TEXT,
--     efecto_en_planeacion TEXT,
--     descripcion TEXT,
--     categoria TEXT,
--     realidad TEXT,
--     visibilidad TEXT,
--     caracterizacion TEXT
-- );

-- -- Condicion table
-- CREATE TABLE condicion (
--     id SERIAL PRIMARY KEY,
--     relacionado_con TEXT,
--     tipo TEXT,
--     problema_identificado TEXT,
--     relevancia TEXT,
--     nombre TEXT,
--     descripcion TEXT
-- );

-- -- Comportamiento table
-- CREATE TABLE comportamiento (
--     id SERIAL PRIMARY KEY,
--     descripcion TEXT,
--     mecanismo TEXT,
--     consecuencia TEXT,
--     nombre TEXT,
--     vacio_regulatorio TEXT,
--     tipo TEXT
-- );

-- -- Relationships table (general for all types)
-- CREATE TABLE relationships (
--     id SERIAL PRIMARY KEY,
--     from_table TEXT NOT NULL,
--     from_id INTEGER NOT NULL,
--     to_table TEXT NOT NULL,
--     to_id INTEGER NOT NULL,
--     type TEXT NOT NULL
-- );

-- New tables based on import.py for energy data analysis (normalized relational model)

-- Plantas table
CREATE TABLE plantas (
    id SERIAL PRIMARY KEY,
    nombre TEXT UNIQUE
);

-- Agentes table
CREATE TABLE agentes (
    id SERIAL PRIMARY KEY,
    nombre TEXT UNIQUE
);

-- RRID antes 066-24 table
CREATE TABLE rrid_antes_066_24 (
    id SERIAL PRIMARY KEY,
    planta_id INTEGER REFERENCES plantas(id),
    rrid_cop BIGINT,
    rrid_sin_anillos_cop BIGINT
);

-- RRID despues 066-24 table
CREATE TABLE rrid_despues_066_24 (
    id SERIAL PRIMARY KEY,
    planta_id INTEGER REFERENCES plantas(id),
    rrid_cop BIGINT,
    rrid_sin_anillos_cop BIGINT
);

-- DDV reg vs DDV ver table
CREATE TABLE ddv_reg_vs_ddv_ver (
    id SERIAL PRIMARY KEY,
    planta_id INTEGER REFERENCES plantas(id),
    agente_id INTEGER REFERENCES agentes(id),
    fecha_dia DATE,
    kwh_registrado BIGINT,
    kwh_verificado BIGINT
);

-- DDV verificada table
CREATE TABLE ddv_verificada (
    id SERIAL PRIMARY KEY,
    planta_id INTEGER REFERENCES plantas(id),
    agente_id INTEGER REFERENCES agentes(id),
    fecha_dia DATE,
    kwh_verificado BIGINT
);

-- MSEC reg vs MSEC desp table
CREATE TABLE msec_reg_vs_msec_desp (
    id SERIAL PRIMARY KEY,
    planta_id INTEGER REFERENCES plantas(id),
    agente_id INTEGER REFERENCES agentes(id),
    kwh_registrado BIGINT,
    kwh_despachado BIGINT
);

-- Recursos table
CREATE TABLE recursos (
    id SERIAL PRIMARY KEY,
    codigo_sic TEXT UNIQUE,
    tipo_generacion TEXT
);

-- Mapeo recursos table
CREATE TABLE mapeo_recursos (
    id SERIAL PRIMARY KEY,
    recurso_id INTEGER REFERENCES recursos(id),
    agente_id INTEGER REFERENCES agentes(id)
);

-- Mapeo agentes table
CREATE TABLE mapeo_agentes (
    id SERIAL PRIMARY KEY,
    recurso_id INTEGER REFERENCES recursos(id),
    agente_id INTEGER REFERENCES agentes(id),
    planta_id INTEGER REFERENCES plantas(id)
);

-- Indexes for performance on new tables
CREATE INDEX idx_ddv_plant_agent_date ON ddv_reg_vs_ddv_ver (planta_id, agente_id, fecha_dia);
CREATE INDEX idx_ddvv_plant_agent_date ON ddv_verificada (planta_id, agente_id, fecha_dia);
CREATE INDEX idx_mapeo_recursos_recurso_agent ON mapeo_recursos (recurso_id, agente_id);
CREATE INDEX idx_mapeo_agentes_recurso_agent_plant ON mapeo_agentes (recurso_id, agente_id, planta_id);
CREATE INDEX idx_rrid_antes_plant ON rrid_antes_066_24 (planta_id);
CREATE INDEX idx_rrid_despues_plant ON rrid_despues_066_24 (planta_id);
CREATE INDEX idx_plantas_nombre ON plantas (nombre);
CREATE INDEX idx_agentes_nombre ON agentes (nombre);
CREATE INDEX idx_recursos_codigo ON recursos (codigo_sic);

-- Indexes for performance (commented out as irrelevant to new schema)
-- CREATE INDEX idx_sistema_tipo ON sistema(tipo);
-- CREATE INDEX idx_mecanismo_tipo ON mecanismo(tipo);
-- CREATE INDEX idx_problema_impacto ON problema(impacto);
-- CREATE INDEX idx_riesgo_categoria ON riesgo(categoria);
-- CREATE INDEX idx_recomendacion_prioridad ON recomendacion(prioridad);
-- CREATE INDEX idx_resolucion_fecha ON resolucion(fecha);
-- CREATE INDEX idx_comunicacion_fecha ON comunicacion(fecha);
-- CREATE INDEX idx_relationships_from ON relationships(from_table, from_id);
-- CREATE INDEX idx_relationships_to ON relationships(to_table, to_id);
-- CREATE INDEX idx_relationships_type ON relationships(type);

-- Views for quantitative analysis (commented out as irrelevant to new schema)

-- -- Node counts by type
-- CREATE VIEW node_counts AS
-- SELECT 'sistema' as table_name, COUNT(*) as count FROM sistema
-- UNION ALL
-- SELECT 'mecanismo', COUNT(*) FROM mecanismo
-- UNION ALL
-- SELECT 'problema', COUNT(*) FROM problema
-- UNION ALL
-- SELECT 'recomendacion', COUNT(*) FROM recomendacion
-- UNION ALL
-- SELECT 'documento', COUNT(*) FROM documento
-- UNION ALL
-- SELECT 'organizacion', COUNT(*) FROM organizacion
-- UNION ALL
-- SELECT 'resolucion', COUNT(*) FROM resolucion
-- UNION ALL
-- SELECT 'comunicacion', COUNT(*) FROM comunicacion
-- UNION ALL
-- SELECT 'riesgo', COUNT(*) FROM riesgo
-- UNION ALL
-- SELECT 'concepto', COUNT(*) FROM concepto
-- UNION ALL
-- SELECT 'metrica', COUNT(*) FROM metrica
-- UNION ALL
-- SELECT 'obligacion', COUNT(*) FROM obligacion
-- UNION ALL
-- SELECT 'consecuencia', COUNT(*) FROM consecuencia
-- UNION ALL
-- SELECT 'condicion', COUNT(*) FROM condicion
-- UNION ALL
-- SELECT 'comportamiento', COUNT(*) FROM comportamiento
-- ORDER BY count DESC;

-- -- Relationship counts by type
-- CREATE VIEW relationship_counts AS
-- SELECT type, COUNT(*) as count
-- FROM relationships
-- GROUP BY type
-- ORDER BY count DESC;

-- -- Problems by impact level
-- CREATE VIEW problem_impact_summary AS
-- SELECT impacto, COUNT(*) as count
-- FROM problema
-- GROUP BY impacto
-- ORDER BY count DESC;

-- -- Risks by category
-- CREATE VIEW risk_category_summary AS
-- SELECT categoria, COUNT(*) as count
-- FROM riesgo
-- GROUP BY categoria
-- ORDER BY count DESC;

-- -- Recommendations by priority
-- CREATE VIEW recommendation_priority_summary AS
-- SELECT prioridad, COUNT(*) as count
-- FROM recomendacion
-- GROUP BY prioridad
-- ORDER BY count DESC;

-- -- Systems and their associated mechanisms
-- CREATE VIEW system_mechanisms AS
-- SELECT s.nombre as system_name, COUNT(m.id) as mechanism_count
-- FROM sistema s
-- LEFT JOIN relationships r ON r.to_table = 'sistema' AND r.to_id = s.id AND r.type = 'PERTENECE_A'
-- LEFT JOIN mecanismo m ON r.from_table = 'mecanismo' AND r.from_id = m.id
-- GROUP BY s.id, s.nombre;

-- -- Problems affecting mechanisms
-- CREATE VIEW mechanism_problems AS
-- SELECT m.nombre as mechanism_name, COUNT(p.id) as problem_count
-- FROM mecanismo m
-- LEFT JOIN relationships r ON r.to_table = 'mecanismo' AND r.to_id = m.id AND r.type = 'AFECTA_A'
-- LEFT JOIN problema p ON r.from_table = 'problema' AND r.from_id = p.id
-- GROUP BY m.id, m.nombre;

-- -- Resolutions by year
-- CREATE VIEW resolution_timeline AS
-- SELECT EXTRACT(YEAR FROM fecha) as year, COUNT(*) as count
-- FROM resolucion
-- GROUP BY EXTRACT(YEAR FROM fecha)
-- ORDER BY year;

-- -- Communications by emisor
-- CREATE VIEW communication_summary AS
-- SELECT emisor, COUNT(*) as count
-- FROM comunicacion
-- GROUP BY emisor
-- ORDER BY count DESC;

