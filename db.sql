-- PostgreSQL schema based on detailed Neo4j graph structure for quantitative analysis
-- Updated with complete properties for each node type

-- Create tables for each node type with specific columns

-- Sistema table
CREATE TABLE sistema (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    tipo TEXT,
    relevancia_rd TEXT,
    funcion TEXT,
    indicador_clave TEXT,
    nombre_completo TEXT
);

-- Mecanismo table
CREATE TABLE mecanismo (
    id SERIAL PRIMARY KEY,
    descripcion TEXT,
    nombre TEXT,
    tipo TEXT,
    problema TEXT,
    funcion TEXT
);

-- Problema table
CREATE TABLE problema (
    id SERIAL PRIMARY KEY,
    descripcion TEXT,
    riesgo TEXT,
    impacto TEXT,
    mecanismo TEXT,
    categoria TEXT,
    consecuencia TEXT,
    capas TEXT,
    evidencia TEXT,
    temas_ambiguos TEXT
);

-- Recomendacion table
CREATE TABLE recomendacion (
    id SERIAL PRIMARY KEY,
    impacto_esperado TEXT,
    descripcion TEXT,
    objetivo TEXT,
    caso_ejemplo TEXT,
    prioridad TEXT
);

-- Documento table
CREATE TABLE documento (
    id SERIAL PRIMARY KEY,
    tipo TEXT,
    codigo TEXT,
    descripcion TEXT,
    proposito TEXT,
    relevancia TEXT,
    problema_identificado TEXT
);

-- Organizacion table
CREATE TABLE organizacion (
    id SERIAL PRIMARY KEY,
    tipo TEXT,
    rol TEXT,
    nombre TEXT
);

-- Resolucion table
CREATE TABLE resolucion (
    id SERIAL PRIMARY KEY,
    descripcion TEXT,
    articulo TEXT,
    formula_ihf TEXT,
    codigo TEXT,
    fecha DATE,
    estado TEXT,
    efecto TEXT
);

-- Comunicacion table
CREATE TABLE comunicacion (
    id SERIAL PRIMARY KEY,
    asunto TEXT,
    emisor TEXT,
    codigo TEXT,
    fecha DATE,
    receptor TEXT
);

-- Riesgo table
CREATE TABLE riesgo (
    id SERIAL PRIMARY KEY,
    categoria TEXT,
    impacto TEXT,
    nombre TEXT,
    descripcion TEXT,
    causa TEXT,
    momento TEXT,
    momento_critico TEXT,
    efecto_cascada TEXT
);

-- Concepto table
CREATE TABLE concepto (
    id SERIAL PRIMARY KEY,
    proposito TEXT,
    nombre TEXT,
    objetivo TEXT,
    contexto TEXT,
    tipo TEXT,
    problema_identificado TEXT,
    componentes TEXT
);

-- Metrica table
CREATE TABLE metrica (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    tipo TEXT,
    relacion_con_ihf TEXT,
    impacto TEXT,
    nombre_completo TEXT,
    definicion TEXT
);

-- Obligacion table
CREATE TABLE obligacion (
    id SERIAL PRIMARY KEY,
    tipo TEXT,
    definicion TEXT,
    incentivo_financiero TEXT,
    nombre TEXT,
    riesgo TEXT,
    nombre_completo TEXT
);

-- Consecuencia table
CREATE TABLE consecuencia (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    tipo TEXT,
    impacto TEXT,
    causa_directa TEXT,
    efecto_en_planeacion TEXT,
    descripcion TEXT,
    categoria TEXT,
    realidad TEXT,
    visibilidad TEXT,
    caracterizacion TEXT
);

-- Condicion table
CREATE TABLE condicion (
    id SERIAL PRIMARY KEY,
    relacionado_con TEXT,
    tipo TEXT,
    problema_identificado TEXT,
    relevancia TEXT,
    nombre TEXT,
    descripcion TEXT
);

-- Comportamiento table
CREATE TABLE comportamiento (
    id SERIAL PRIMARY KEY,
    descripcion TEXT,
    mecanismo TEXT,
    consecuencia TEXT,
    nombre TEXT,
    vacio_regulatorio TEXT,
    tipo TEXT
);

-- New tables based on Neo4j insights

-- Planta table (Power Plants)
CREATE TABLE planta (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    tipo TEXT,
    capacidad_mw REAL,
    ihf REAL,
    enficc REAL,
    oef REAL,
    estado TEXT
);

-- Hidrologia table (Hydrology Conditions)
CREATE TABLE hidrologia (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    tipo TEXT,
    descripcion TEXT,
    impacto_en_ihf TEXT,
    severidad TEXT
);

-- AnilloSeguridad table (Safety Rings)
CREATE TABLE anillo_seguridad (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    tipo TEXT,
    descripcion TEXT,
    efecto_en_ihf TEXT,
    regulacion TEXT
);

-- Mercado table (Secondary Market)
CREATE TABLE mercado (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    tipo TEXT,
    descripcion TEXT,
    funcion TEXT,
    impacto_en_confiabilidad TEXT
);

-- CargoConfiabilidad table (Reliability Charge)
CREATE TABLE cargo_confiabilidad (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    descripcion TEXT,
    formula TEXT,
    periodo TEXT,
    estado TEXT
);

-- Relationships table (general for all types)
CREATE TABLE relationships (
    id SERIAL PRIMARY KEY,
    from_table TEXT NOT NULL,
    from_id INTEGER NOT NULL,
    to_table TEXT NOT NULL,
    to_id INTEGER NOT NULL,
    type TEXT NOT NULL
);

-- Indexes for performance
CREATE INDEX idx_sistema_tipo ON sistema(tipo);
CREATE INDEX idx_mecanismo_tipo ON mecanismo(tipo);
CREATE INDEX idx_problema_impacto ON problema(impacto);
CREATE INDEX idx_riesgo_categoria ON riesgo(categoria);
CREATE INDEX idx_recomendacion_prioridad ON recomendacion(prioridad);
CREATE INDEX idx_resolucion_fecha ON resolucion(fecha);
CREATE INDEX idx_comunicacion_fecha ON comunicacion(fecha);
CREATE INDEX idx_planta_tipo ON planta(tipo);
CREATE INDEX idx_planta_ihf ON planta(ihf);
CREATE INDEX idx_hidrologia_tipo ON hidrologia(tipo);
CREATE INDEX idx_anillo_seguridad_tipo ON anillo_seguridad(tipo);
CREATE INDEX idx_mercado_tipo ON mercado(tipo);
CREATE INDEX idx_cargo_confiabilidad_estado ON cargo_confiabilidad(estado);
CREATE INDEX idx_relationships_from ON relationships(from_table, from_id);
CREATE INDEX idx_relationships_to ON relationships(to_table, to_id);
CREATE INDEX idx_relationships_type ON relationships(type);

-- Views for quantitative analysis

-- Node counts by type
CREATE VIEW node_counts AS
SELECT 'sistema' as table_name, COUNT(*) as count FROM sistema
UNION ALL
SELECT 'mecanismo', COUNT(*) FROM mecanismo
UNION ALL
SELECT 'problema', COUNT(*) FROM problema
UNION ALL
SELECT 'recomendacion', COUNT(*) FROM recomendacion
UNION ALL
SELECT 'documento', COUNT(*) FROM documento
UNION ALL
SELECT 'organizacion', COUNT(*) FROM organizacion
UNION ALL
SELECT 'resolucion', COUNT(*) FROM resolucion
UNION ALL
SELECT 'comunicacion', COUNT(*) FROM comunicacion
UNION ALL
SELECT 'riesgo', COUNT(*) FROM riesgo
UNION ALL
SELECT 'concepto', COUNT(*) FROM concepto
UNION ALL
SELECT 'metrica', COUNT(*) FROM metrica
UNION ALL
SELECT 'obligacion', COUNT(*) FROM obligacion
UNION ALL
SELECT 'consecuencia', COUNT(*) FROM consecuencia
UNION ALL
SELECT 'condicion', COUNT(*) FROM condicion
UNION ALL
SELECT 'comportamiento', COUNT(*) FROM comportamiento
UNION ALL
SELECT 'planta', COUNT(*) FROM planta
UNION ALL
SELECT 'hidrologia', COUNT(*) FROM hidrologia
UNION ALL
SELECT 'anillo_seguridad', COUNT(*) FROM anillo_seguridad
UNION ALL
SELECT 'mercado', COUNT(*) FROM mercado
UNION ALL
SELECT 'cargo_confiabilidad', COUNT(*) FROM cargo_confiabilidad
ORDER BY count DESC;

-- Relationship counts by type
CREATE VIEW relationship_counts AS
SELECT type, COUNT(*) as count
FROM relationships
GROUP BY type
ORDER BY count DESC;

-- Problems by impact level
CREATE VIEW problem_impact_summary AS
SELECT impacto, COUNT(*) as count
FROM problema
GROUP BY impacto
ORDER BY count DESC;

-- Risks by category
CREATE VIEW risk_category_summary AS
SELECT categoria, COUNT(*) as count
FROM riesgo
GROUP BY categoria
ORDER BY count DESC;

-- Recommendations by priority
CREATE VIEW recommendation_priority_summary AS
SELECT prioridad, COUNT(*) as count
FROM recomendacion
GROUP BY prioridad
ORDER BY count DESC;

-- Systems and their associated mechanisms
CREATE VIEW system_mechanisms AS
SELECT s.nombre as system_name, COUNT(m.id) as mechanism_count
FROM sistema s
LEFT JOIN relationships r ON r.to_table = 'sistema' AND r.to_id = s.id AND r.type = 'PERTENECE_A'
LEFT JOIN mecanismo m ON r.from_table = 'mecanismo' AND r.from_id = m.id
GROUP BY s.id, s.nombre;

-- Problems affecting mechanisms
CREATE VIEW mechanism_problems AS
SELECT m.nombre as mechanism_name, COUNT(p.id) as problem_count
FROM mecanismo m
LEFT JOIN relationships r ON r.to_table = 'mecanismo' AND r.to_id = m.id AND r.type = 'AFECTA_A'
LEFT JOIN problema p ON r.from_table = 'problema' AND r.from_id = p.id
GROUP BY m.id, m.nombre;

-- Resolutions by year
CREATE VIEW resolution_timeline AS
SELECT EXTRACT(YEAR FROM fecha) as year, COUNT(*) as count
FROM resolucion
GROUP BY EXTRACT(YEAR FROM fecha)
ORDER BY year;

-- Communications by emisor
CREATE VIEW communication_summary AS
SELECT emisor, COUNT(*) as count
FROM comunicacion
GROUP BY emisor
ORDER BY count DESC;

-- New views for added tables

-- Plants by IHF level
CREATE VIEW plant_ihf_summary AS
SELECT ihf, COUNT(*) as count
FROM planta
GROUP BY ihf
ORDER BY ihf;

-- Hydrology impact on IHF
CREATE VIEW hydrology_ihf_impact AS
SELECT h.nombre as hydrology_name, h.impacto_en_ihf, COUNT(p.id) as affected_plants
FROM hidrologia h
LEFT JOIN relationships r ON r.to_table = 'hidrologia' AND r.to_id = h.id
LEFT JOIN planta p ON r.from_table = 'planta' AND r.from_id = p.id
GROUP BY h.id, h.nombre, h.impacto_en_ihf;

-- Safety rings effect on mechanisms
CREATE VIEW anillo_mecanismo_effect AS
SELECT a.nombre as anillo_name, a.efecto_en_ihf, COUNT(m.id) as related_mechanisms
FROM anillo_seguridad a
LEFT JOIN relationships r ON r.to_table = 'anillo_seguridad' AND r.to_id = a.id
LEFT JOIN mecanismo m ON r.from_table = 'mecanismo' AND r.from_id = m.id
GROUP BY a.id, a.nombre, a.efecto_en_ihf;

-- Sample data insertion (placeholders; replace with actual Neo4j export)
INSERT INTO sistema (nombre, tipo, relevancia_rd, funcion, indicador_clave, nombre_completo) VALUES
('SIN Colombia', 'Sistema Interconectado Nacional', 'Alta', 'Interconexión de generación y demanda', 'IHF, ENFICC', 'Sistema Interconectado Nacional de Colombia');

INSERT INTO mecanismo (descripcion, nombre, tipo, problema, funcion) VALUES
('Métrica de confiabilidad', 'IHF', 'Índice de Indisponibilidad Histórica Forzada', 'Distorsión por anillos de seguridad', 'Medir indisponibilidad de plantas');

INSERT INTO problema (descripcion, riesgo, impacto, mecanismo, categoria, consecuencia, capas, evidencia, temas_ambiguos) VALUES
('Distorsión del IHF por cobertura de anillos de seguridad', 'Alto', 'Sobreestimación de la ENFICC', 'IHF', 'Cálculo de Métricas', 'Capacidad inflada', 'Regulatoria', 'Resoluciones CREG', 'Descuentos en IHF');

-- Add more inserts as needed based on actual data

-- Note: To populate with real data, export from Neo4j using:
-- MATCH (n:Sistema) RETURN properties(n)
-- And map to INSERT statements for each table.