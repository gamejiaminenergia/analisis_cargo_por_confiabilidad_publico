-- Test data for PostgreSQL schema based on Neo4j structure
-- This script populates the database with sample data for quantitative analysis

-- Insert into sistema
INSERT INTO sistema (nombre, tipo, relevancia_rd, funcion, indicador_clave, nombre_completo) VALUES
('Sistema de Transmisión', 'Eléctrico', 'Alta', 'Transmisión de Energía', 'Indicador1', 'Sistema Nacional de Transmisión Eléctrica'),
('Sistema de Generación', 'Eléctrico', 'Media', 'Generación de Energía', 'Indicador2', 'Sistema de Generación Hidroeléctrica');

-- Insert into mecanismo
INSERT INTO mecanismo (descripcion, nombre, tipo, problema, funcion) VALUES
('Mecanismo de control de frecuencia', 'Control de Frecuencia', 'Control', 'Problema de Estabilidad', 'Mantener frecuencia estable'),
('Mecanismo de protección contra sobrecargas', 'Protección Sobrecarga', 'Protección', 'Problema de Sobrecarga', 'Proteger contra sobrecargas'),
('Mecanismo de balance de carga', 'Balance de Carga', 'Balance', 'Problema de Desbalance', 'Balancear la carga');

-- Insert into problema
INSERT INTO problema (descripcion, riesgo, impacto, mecanismo, categoria, consecuencia, capas, evidencia, temas_ambiguos) VALUES
('Inestabilidad en la frecuencia del sistema', 'Riesgo de Apagón', 'Alto', 'Control de Frecuencia', 'Estabilidad', 'Apagón masivo', 'Capa Física', 'Registros de frecuencia', 'Ambiguos en límites'),
('Sobrecarga en líneas de transmisión', 'Riesgo de Daño', 'Medio', 'Protección Sobrecarga', 'Sobrecarga', 'Daño a infraestructura', 'Capa de Red', 'Mediciones de corriente', 'Ambiguos en umbrales'),
('Desbalance en la distribución de carga', 'Riesgo de Ineficiencia', 'Bajo', 'Balance de Carga', 'Balance', 'Pérdida de eficiencia', 'Capa de Aplicación', 'Datos de balance', 'Ambiguos en algoritmos');

-- Insert into riesgo
INSERT INTO riesgo (categoria, impacto, nombre, descripcion, causa, momento, momento_critico, efecto_cascada) VALUES
('Financiero', 'Alto', 'Riesgo de Apagón', 'Posible apagón generalizado', 'Falla en generación', 'Pico de demanda', 'Evento crítico', 'Efecto en cadena en usuarios'),
('Operacional', 'Medio', 'Riesgo de Daño', 'Daño a equipos', 'Sobrecarga', 'Operación normal', 'Sobrecarga extrema', 'Daño propagado'),
('Estratégico', 'Bajo', 'Riesgo de Ineficiencia', 'Ineficiencia operativa', 'Desbalance', 'Planificación', 'Desbalance prolongado', 'Pérdida de ingresos');

-- Insert into recomendacion
INSERT INTO recomendacion (impacto_esperado, descripcion, objetivo, caso_ejemplo, prioridad) VALUES
('Alto', 'Implementar controles automáticos de frecuencia', 'Mejorar estabilidad', 'Caso de apagón 2020', 'Alta'),
('Medio', 'Instalar sensores de sobrecarga', 'Prevenir daños', 'Caso de sobrecarga 2019', 'Media'),
('Bajo', 'Optimizar algoritmos de balance', 'Aumentar eficiencia', 'Caso de desbalance 2021', 'Baja');

-- Insert into documento
INSERT INTO documento (tipo, codigo, descripcion, proposito, relevancia, problema_identificado) VALUES
('Informe', 'DOC001', 'Informe sobre estabilidad del sistema', 'Analizar problemas de frecuencia', 'Alta', 'Inestabilidad en la frecuencia'),
('Guía', 'DOC002', 'Guía de protección contra sobrecargas', 'Proporcionar directrices', 'Media', 'Sobrecarga en líneas'),
('Estudio', 'DOC003', 'Estudio de balance de carga', 'Evaluar desbalances', 'Baja', 'Desbalance en distribución');

-- Insert into organizacion
INSERT INTO organizacion (tipo, rol, nombre) VALUES
('Regulatoria', 'Supervisor', 'CREG'),
('Operativa', 'Operador', 'XM'),
('Generadora', 'Productor', 'Empresa Generadora');

-- Insert into resolucion
INSERT INTO resolucion (descripcion, articulo, formula_ihf, codigo, fecha, estado, efecto) VALUES
('Resolución sobre tarifas de transmisión', 'Artículo 1', 'Fórmula IHF1', 'RES001', '2023-01-15', 'Vigente', 'Ajuste de tarifas'),
('Resolución sobre estándares de calidad', 'Artículo 2', 'Fórmula IHF2', 'RES002', '2023-02-20', 'Vigente', 'Mejora de estándares'),
('Resolución derogada sobre incentivos', 'Artículo 3', 'Fórmula IHF3', 'RES003', '2022-12-10', 'Derogada', 'Cambio de incentivos');

-- Insert into comunicacion
INSERT INTO comunicacion (asunto, emisor, codigo, fecha, receptor) VALUES
('Alerta de inestabilidad', 'XM', 'COM001', '2023-03-01', 'CREG'),
('Reporte de sobrecarga', 'Empresa Generadora', 'COM002', '2023-03-05', 'XM'),
('Propuesta de balance', 'CREG', 'COM003', '2023-03-10', 'XM');

-- Insert into concepto
INSERT INTO concepto (proposito, nombre, objetivo, contexto, tipo, problema_identificado, componentes) VALUES
('Definir confiabilidad', 'Confiabilidad', 'Asegurar suministro', 'Sistema eléctrico', 'Abstracto', 'Inestabilidad', 'Disponibilidad, Estabilidad'),
('Definir riesgo', 'Riesgo', 'Identificar amenazas', 'Operación', 'Abstracto', 'Sobrecarga', 'Probabilidad, Impacto'),
('Definir balance', 'Balance', 'Optimizar recursos', 'Planificación', 'Abstracto', 'Desbalance', 'Carga, Demanda');

-- Insert into metrica
INSERT INTO metrica (nombre, tipo, relacion_con_ihf, impacto, nombre_completo, definicion) VALUES
('Métrica de Frecuencia', 'Estabilidad', 'Directa', 'Alto', 'Métrica de Frecuencia del Sistema', 'Medida de variación de frecuencia'),
('Métrica de Carga', 'Balance', 'Indirecta', 'Medio', 'Métrica de Balance de Carga', 'Medida de distribución de carga'),
('Métrica de Eficiencia', 'Eficiencia', 'Directa', 'Bajo', 'Métrica de Eficiencia Operativa', 'Medida de eficiencia en operación');

-- Insert into obligacion
INSERT INTO obligacion (tipo, definicion, incentivo_financiero, nombre, riesgo, nombre_completo) VALUES
('Legal', 'Mantener frecuencia estable', 'Sí', 'Obligación de Estabilidad', 'Riesgo de Apagón', 'Obligación de Mantener Estabilidad en Frecuencia'),
('Contractual', 'Proteger contra sobrecargas', 'No', 'Obligación de Protección', 'Riesgo de Daño', 'Obligación de Proteger Infraestructura'),
('Regulatoria', 'Balancear carga', 'Sí', 'Obligación de Balance', 'Riesgo de Ineficiencia', 'Obligación de Balancear Carga');

-- Insert into consecuencia
INSERT INTO consecuencia (nombre, tipo, impacto, causa_directa, efecto_en_planeacion, descripcion, categoria, realidad, visibilidad, caracterizacion) VALUES
('Apagón Masivo', 'Negativa', 'Alto', 'Inestabilidad', 'Disrupción total', 'Apagón generalizado', 'Operacional', 'Real', 'Alta', 'Catastrófica'),
('Daño a Infraestructura', 'Negativa', 'Medio', 'Sobrecarga', 'Reparaciones', 'Daño a líneas', 'Técnica', 'Real', 'Media', 'Preventable'),
('Pérdida de Eficiencia', 'Negativa', 'Bajo', 'Desbalance', 'Optimización', 'Pérdida de ingresos', 'Económica', 'Real', 'Baja', 'Gradual');

-- Insert into condicion
INSERT INTO condicion (relacionado_con, tipo, problema_identificado, relevancia, nombre, descripcion) VALUES
('Estabilidad', 'Ambiental', 'Inestabilidad', 'Alta', 'Condición Climática', 'Condiciones climáticas extremas'),
('Sobrecarga', 'Técnica', 'Sobrecarga', 'Media', 'Condición de Demanda', 'Alta demanda estacional'),
('Desbalance', 'Operativa', 'Desbalance', 'Baja', 'Condición de Mantenimiento', 'Mantenimiento programado');

-- Insert into comportamiento
INSERT INTO comportamiento (descripcion, mecanismo, consecuencia, nombre, vacio_regulatorio, tipo) VALUES
('Comportamiento de respuesta a frecuencia', 'Control de Frecuencia', 'Apagón Masivo', 'Respuesta a Frecuencia', 'No', 'Reactivo'),
('Comportamiento de protección', 'Protección Sobrecarga', 'Daño a Infraestructura', 'Protección Automática', 'Sí', 'Preventivo'),
('Comportamiento de ajuste', 'Balance de Carga', 'Pérdida de Eficiencia', 'Ajuste Dinámico', 'No', 'Adaptativo');

-- Now insert relationships (using assumed ids: sistema 1,2; mecanismo 3,4,5; problema 6,7,8; riesgo 9,10,11; recomendacion 12,13,14; documento 15,16,17; organizacion 18,19,20; resolucion 21,22,23; comunicacion 24,25,26; concepto 27,28,29; metrica 30,31,32; obligacion 33,34,35; consecuencia 36,37,38; condicion 39,40,41; comportamiento 42,43,44)

INSERT INTO relationships (from_table, from_id, to_table, to_id, type) VALUES
('mecanismo', 3, 'sistema', 1, 'PERTENECE_A'),
('mecanismo', 4, 'sistema', 1, 'PERTENECE_A'),
('mecanismo', 5, 'sistema', 2, 'PERTENECE_A'),
('problema', 6, 'mecanismo', 3, 'AFECTA_A'),
('problema', 7, 'mecanismo', 4, 'AFECTA_A'),
('problema', 8, 'mecanismo', 5, 'AFECTA_A'),
('riesgo', 9, 'mecanismo', 3, 'AFECTA_A'),
('riesgo', 10, 'mecanismo', 4, 'AFECTA_A'),
('riesgo', 11, 'mecanismo', 5, 'AFECTA_A'),
('recomendacion', 12, 'problema', 6, 'SOLUCIONA'),
('recomendacion', 13, 'problema', 7, 'SOLUCIONA'),
('recomendacion', 14, 'problema', 8, 'SOLUCIONA'),
('documento', 15, 'problema', 6, 'SOPORTA'),
('documento', 16, 'problema', 7, 'EVIDENCIA'),
('documento', 17, 'problema', 8, 'SOPORTA'),
('resolucion', 21, 'resolucion', 23, 'DEROGA'),
('resolucion', 22, 'resolucion', 21, 'HACE_REFERENCIA_A'),
('comunicacion', 24, 'mecanismo', 3, 'ABORDA'),
('comunicacion', 25, 'mecanismo', 4, 'ABORDA'),
('comunicacion', 26, 'mecanismo', 5, 'ABORDA'),
('riesgo', 9, 'consecuencia', 36, 'GENERA'),
('riesgo', 10, 'consecuencia', 37, 'GENERA'),
('riesgo', 11, 'consecuencia', 38, 'GENERA'),
('obligacion', 33, 'riesgo', 9, 'MITIGA'),
('obligacion', 34, 'riesgo', 10, 'MITIGA'),
('obligacion', 35, 'riesgo', 11, 'MITIGA'),
('metrica', 30, 'problema', 6, 'DEFINE'),
('metrica', 31, 'problema', 7, 'DEFINE'),
('metrica', 32, 'problema', 8, 'DEFINE'),
('concepto', 27, 'problema', 6, 'ABORDA'),
('concepto', 28, 'problema', 7, 'ABORDA'),
('concepto', 29, 'problema', 8, 'ABORDA'),
('condicion', 39, 'problema', 6, 'INCLUYE'),
('condicion', 40, 'problema', 7, 'INCLUYE'),
('condicion', 41, 'problema', 8, 'INCLUYE'),
('comportamiento', 42, 'mecanismo', 3, 'UTILIZA'),
('comportamiento', 43, 'mecanismo', 4, 'UTILIZA'),
('comportamiento', 44, 'mecanismo', 5, 'UTILIZA');