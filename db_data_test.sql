-- Test data for PostgreSQL schema based on Neo4j structure
-- This script populates the database with sample data for quantitative analysis

-- Insert into sistema
INSERT INTO sistema (nombre, tipo, relevancia_rd, funcion, indicador_clave, nombre_completo) VALUES
('SIN Colombia', 'Sistema Interconectado Nacional', 'Alta', 'Interconexión de generación y demanda', 'IHF, ENFICC', 'Sistema Interconectado Nacional de Colombia');

-- Insert into mecanismo
INSERT INTO mecanismo (descripcion, nombre, tipo, problema, funcion) VALUES
('Métrica de confiabilidad', 'IHF', 'Índice de Indisponibilidad Histórica Forzada', 'Distorsión por anillos de seguridad', 'Medir indisponibilidad de plantas'),
('Mecanismo de respuesta de la demanda', 'DDV', 'Demanda Desconectable Voluntaria', 'No confiable en escasez', 'Reducir demanda en picos'),
('Mecanismo complementario de respaldo energético', 'Mercado Secundario', 'Mecanismo de Respaldo', 'Distorsiona IHF', 'Cubrir indisponibilidades de plantas generadoras');

-- Insert into problema
INSERT INTO problema (descripcion, riesgo, impacto, mecanismo, categoria, consecuencia, capas, evidencia, temas_ambiguos) VALUES
('Distorsión del IHF por cobertura de anillos de seguridad', 'Alto', 'Sobreestimación de la ENFICC', 'IHF', 'Cálculo de Métricas', 'Capacidad inflada', 'Regulatoria', 'Resoluciones CREG', 'Descuentos en IHF'),
('Incentivo financiero perverso para minimizar IHF reportado', 'Alto', 'Plantas asumen OEF superiores a su capacidad real por beneficios económicos', 'ENFICC y OEF', 'Incentivos Económicos', 'Remuneración excesiva', 'Económica', 'Contratos de Cargo por Confiabilidad', 'Minimización de IHF');

-- Insert into riesgo
INSERT INTO riesgo (categoria, impacto, nombre, descripcion, causa, momento, momento_critico, efecto_cascada) VALUES
('Sistémico', 'Crítico', 'Vulnerabilidad sistémica agregada', 'Sistema vulnerable cuando más se necesita: baja hidrología o escasez', 'IHF distorsionado + DDV no confiable', 'Operación normal', 'Condiciones hidrológicas adversas', 'Suma de IHF distorsionado + DDV no confiable + RD inoperante');

-- Insert into recomendacion
INSERT INTO recomendacion (impacto_esperado, descripcion, objetivo, caso_ejemplo, prioridad) VALUES
('Mayor precisión en la medición de confiabilidad', 'Revisar cálculo del IHF eliminando descuentos por anillos de seguridad', 'Eliminar distorsiones en IHF', 'Cálculo actual de IHF', 'Alta');

-- Insert into documento
INSERT INTO documento (tipo, codigo, descripcion, proposito, relevancia, problema_identificado) VALUES
('Solicitud', '201844009677-1', 'Solicitud de concepto sobre cálculo del IHF', 'Clarificar metodología de IHF', 'Alta', 'Distorsión en cálculo de IHF');

-- Insert into organizacion
INSERT INTO organizacion (tipo, rol, nombre) VALUES
('Regulatoria', 'Regulador', 'CREG'),
('Operativa', 'Operador del Sistema', 'XM');

-- Insert into resolucion
INSERT INTO resolucion (descripcion, articulo, formula_ihf, codigo, fecha, estado, efecto) VALUES
('Resolución sobre Cargo por Confiabilidad', 'Artículo sobre IHF', 'Fórmula de IHF', 'CREG-001', '2018-01-01', 'Vigente', 'Define cálculo de IHF');

-- Insert into comunicacion
INSERT INTO comunicacion (asunto, emisor, codigo, fecha, receptor) VALUES
('Solicitud de concepto sobre cálculo del IHF', 'XM', '201844009677-1', '2018-01-01', 'CREG');

-- Insert into concepto
INSERT INTO concepto (proposito, nombre, objetivo, contexto, tipo, problema_identificado, componentes) VALUES
('Definir confiabilidad', 'Confiabilidad', 'Asegurar suministro', 'Sistema eléctrico', 'Abstracto', 'Distorsión de métricas', 'IHF, ENFICC, OEF');

-- Insert into metrica
INSERT INTO metrica (nombre, tipo, relacion_con_ihf, impacto, nombre_completo, definicion) VALUES
('ENFICC', 'Métrica de Energía', 'Inversamente proporcional al IHF', 'Determina la capacidad de generación firme de una planta', 'Energía Firme para el Cargo por Confiabilidad', 'Máxima energía que una planta puede garantizar ininterrumpidamente durante condiciones de escasez hidrológica');

-- Insert into obligacion
INSERT INTO obligacion (tipo, definicion, incentivo_financiero, nombre, riesgo, nombre_completo) VALUES
('Compromiso Contractual', 'Compromiso de entrega de energía que asume una planta basado en su ENFICC', 'Mayor ENFICC permite mayor OEF y mayor remuneración', 'OEF', 'Puede estar por encima de la capacidad real de la planta', 'Obligación de Energía Firme');

-- Insert into consecuencia
INSERT INTO consecuencia (nombre, tipo, impacto, causa_directa, efecto_en_planeacion, descripcion, categoria, realidad, visibilidad, caracterizacion) VALUES
('Sobreestimación de ENFICC', 'Consecuencia Técnica', 'Sistema asume capacidad de respaldo inexistente', 'IHF artificialmente bajo por descuentos de anillos de seguridad', 'Cálculos de planeación basados en capacidad inflada', 'ENFICC declarada superior a capacidad real de generación', 'Técnica', 'Real', 'Alta', 'Inflada');

-- Insert into condicion
INSERT INTO condicion (relacionado_con, tipo, problema_identificado, relevancia, nombre, descripcion) VALUES
('Hidrología', 'Ambiental', 'Escasez hidrológica', 'Alta', 'Condiciones de Escasez', 'Baja hidrología afecta generación');

-- Insert into comportamiento
INSERT INTO comportamiento (descripcion, mecanismo, consecuencia, nombre, vacio_regulatorio, tipo) VALUES
('Respuesta a indisponibilidades', 'Mercado Secundario', 'Distorsión de IHF', 'Uso de Anillos de Seguridad', 'Sí', 'Adaptativo');

-- Insert into new tables

-- Insert into planta
INSERT INTO planta (nombre, tipo, capacidad_mw, ihf, enficc, oef, estado) VALUES
('Planta Hidroeléctrica 1', 'Hidroeléctrica', 500.0, 0.05, 450.0, 450.0, 'Operativa'),
('Planta Térmica 1', 'Térmica', 300.0, 0.10, 250.0, 260.0, 'Operativa'),
('Planta Eólica 1', 'Eólica', 200.0, 0.15, 150.0, 150.0, 'Operativa');

-- Insert into hidrologia
INSERT INTO hidrologia (nombre, tipo, descripcion, impacto_en_ihf, severidad) VALUES
('Condiciones Normales', 'Normal', 'Hidrología favorable', 'IHF bajo', 'Baja'),
('Escasez Hidrológica', 'Adversa', 'Baja hidrología afecta generación', 'IHF alto', 'Alta');

-- Insert into anillo_seguridad
INSERT INTO anillo_seguridad (nombre, tipo, descripcion, efecto_en_ihf, regulacion) VALUES
('Anillo de Seguridad Primario', 'Primario', 'Respaldo inmediato para indisponibilidades', 'Reduce IHF reportado', 'Resolución CREG-001'),
('Anillo de Seguridad Secundario', 'Secundario', 'Respaldo adicional', 'Mayor reducción en IHF', 'Resolución CREG-002');

-- Insert into mercado
INSERT INTO mercado (nombre, tipo, descripcion, funcion, impacto_en_confiabilidad) VALUES
('Mercado Secundario de Energía', 'Secundario', 'Mecanismo complementario de respaldo energético', 'Cubrir indisponibilidades', 'Mejora confiabilidad pero distorsiona IHF');

-- Insert into cargo_confiabilidad
INSERT INTO cargo_confiabilidad (nombre, descripcion, formula, periodo, estado) VALUES
('Cargo por Confiabilidad', 'Mecanismo para remunerar capacidad firme', 'ENFICC * Tarifa', 'Mensual', 'Activo');

-- Now insert relationships (using assumed ids: sistema 1; mecanismo 2,3,4; problema 5,6; riesgo 7; recomendacion 8; documento 9; organizacion 10,11; resolucion 12; comunicacion 13; concepto 14; metrica 15; obligacion 16; consecuencia 17; condicion 18; comportamiento 19; planta 20,21,22; hidrologia 23,24; anillo_seguridad 25,26; mercado 27; cargo_confiabilidad 28)

INSERT INTO relationships (from_table, from_id, to_table, to_id, type) VALUES
('mecanismo', 2, 'sistema', 1, 'PERTENECE_A'),
('mecanismo', 3, 'sistema', 1, 'PERTENECE_A'),
('mecanismo', 4, 'sistema', 1, 'PERTENECE_A'),
('problema', 5, 'mecanismo', 2, 'AFECTA_A'),
('problema', 6, 'mecanismo', 2, 'AFECTA_A'),
('problema', 6, 'metrica', 15, 'AFECTA_A'),
('problema', 6, 'obligacion', 16, 'AFECTA_A'),
('riesgo', 7, 'mecanismo', 2, 'GENERA'),
('riesgo', 7, 'mecanismo', 3, 'GENERA'),
('recomendacion', 8, 'problema', 5, 'SOLUCIONA'),
('documento', 9, 'problema', 5, 'SOPORTA'),
('resolucion', 12, 'mecanismo', 2, 'DEFINE'),
('comunicacion', 13, 'mecanismo', 2, 'ABORDA'),
('metrica', 15, 'mecanismo', 2, 'RELACIONADA_CON'),
('obligacion', 16, 'metrica', 15, 'BASADA_EN'),
('consecuencia', 17, 'problema', 5, 'RESULTA_DE'),
('condicion', 18, 'riesgo', 7, 'AGRAVA'),
('comportamiento', 19, 'mecanismo', 4, 'UTILIZA'),
('planta', 20, 'metrica', 15, 'TIENE'),
('planta', 21, 'metrica', 15, 'TIENE'),
('planta', 22, 'metrica', 15, 'TIENE'),
('planta', 20, 'obligacion', 16, 'CUMPLE'),
('planta', 21, 'obligacion', 16, 'CUMPLE'),
('planta', 22, 'obligacion', 16, 'CUMPLE'),
('hidrologia', 23, 'mecanismo', 2, 'AFECTA'),
('hidrologia', 24, 'mecanismo', 2, 'AFECTA'),
('anillo_seguridad', 25, 'mecanismo', 2, 'MODIFICA'),
('anillo_seguridad', 26, 'mecanismo', 2, 'MODIFICA'),
('mercado', 27, 'mecanismo', 4, 'ES_TIPO_DE'),
('cargo_confiabilidad', 28, 'metrica', 15, 'USA'),
('cargo_confiabilidad', 28, 'obligacion', 16, 'REMUNERA');