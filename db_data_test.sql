-- Test data for PostgreSQL schema based on import.py analysis
-- This script populates the database with sample data for energy regulatory analysis
-- Graph-related data commented out as per import.py analysis

-- -- Insert into sistema
-- INSERT INTO sistema (nombre, tipo, relevancia_rd, funcion, indicador_clave, nombre_completo) VALUES
-- ('SIN Colombia', 'Sistema Interconectado Nacional', 'Alta', 'Interconexión de generación y demanda', 'IHF, ENFICC', 'Sistema Interconectado Nacional de Colombia'),
-- ('MEM', 'Mercado Eléctrico', 'El programa RD fue diseñado para activarse durante incrementos de precios de bolsa', 'Comercialización de energía eléctrica', 'Precios de bolsa', 'Mercado de Energía Mayorista');

-- -- Insert into mecanismo
-- INSERT INTO mecanismo (descripcion, nombre, tipo, problema, funcion) VALUES
-- ('Métrica de confiabilidad', 'IHF', 'Índice de Indisponibilidad Histórica Forzada', 'Distorsión por anillos de seguridad', 'Medir indisponibilidad de plantas'),
-- ('Mecanismo de respuesta de la demanda', 'DDV', 'Demanda Desconectable Voluntaria', 'No confiable en escasez', 'Reducir demanda en picos'),
-- ('Programa de respuesta de la demanda', 'RD', 'Respuesta de la Demanda', NULL, NULL),
-- ('Mecanismo complementario de respaldo energético', 'Mercado Secundario', 'Mecanismo de Respaldo', 'Permite descuentos en el cálculo del IHF que distorsionan la confiabilidad real', 'Cubrir indisponibilidades de plantas generadoras');

-- -- Insert into problema
-- INSERT INTO problema (descripcion, riesgo, impacto, mecanismo, categoria, consecuencia, capas, evidencia, temas_ambiguos) VALUES
-- ('Distorsión del IHF por cobertura de anillos de seguridad', 'Alto', 'Sobreestimación de la ENFICC', 'IHF', 'Cálculo de Métricas', 'Capacidad inflada', 'Regulatoria', 'Resoluciones CREG', 'Descuentos en IHF'),
-- ('Elusión de pruebas aleatorias en DDV mediante contratos diarios', 'Crítico', 'Validación no representativa de la capacidad real', NULL, 'Incentivos Económicos', NULL, NULL, NULL, NULL),
-- ('Discrepancia entre verificación administrativa y desconexión real', 'Alto', 'Falsa sensación de seguridad operativa', NULL, NULL, NULL, NULL, NULL, NULL),
-- ('Incentivo financiero perverso para minimizar IHF reportado', 'Alto', 'Plantas asumen OEF superiores a su capacidad real por beneficios económicos', 'ENFICC y OEF', 'Incentivos Económicos', 'Remuneración excesiva', 'Económica', 'Contratos de Cargo por Confiabilidad', 'Minimización de IHF'),
-- ('Doble capa de desacoplamiento de realidad operativa', 'Crítico', 'Falla de generador cubierta por DDV que posiblemente no ocurrió físicamente', NULL, NULL, 'Sistema vulnerable con dos niveles de confiabilidad ficticia', '1) Falla real cubierta administrativamente, 2) Desconexión DDV no materializada', NULL, NULL),
-- ('Incertidumbre normativa persistente en DDV', 'Medio', 'Múltiples consultas recurrentes demuestran ambigüedad regulatoria', NULL, NULL, NULL, NULL, 'Comunicaciones 013820-1 (2018) y 202144032409-1 requieren aclaraciones', 'Programación de pruebas, registro de fronteras, consecuencias por incumplimiento');

-- -- Insert into riesgo
-- INSERT INTO riesgo (categoria, impacto, nombre, descripcion, causa, momento, momento_critico, efecto_cascada) VALUES
-- ('Estructural', 'Alto', 'Sobreestimación de la confiabilidad', 'El sistema opera con una percepción de confiabilidad mayor a la real', NULL, NULL, NULL, NULL),
-- ('Operativo', 'Crítico', 'Falla en la respuesta de la demanda', 'Los mecanismos de DDV podrían no responder según lo esperado en situaciones críticas', NULL, NULL, NULL, NULL),
-- ('Regulatorio', 'Alto', 'Inoperatividad de mecanismos de respaldo', 'Mecanismos como el RD quedan inoperantes por inconsistencias regulatorias', NULL, NULL, NULL, NULL),
-- ('Temporal', 'Crítico', 'Pérdida de herramientas en momento crítico', 'Programa RD quedó inoperante justo cuando había incrementos de precios de bolsa', 'Descoordinación regulatoria entre derogación y referencias activas', 'Cuando más se necesitaba el mecanismo', 'Condiciones hidrológicas adversas', NULL),
-- ('Sistémico', 'Crítico', 'Vulnerabilidad sistémica agregada', 'Sistema vulnerable cuando más se necesita: baja hidrología o escasez', 'IHF distorsionado + DDV no confiable', 'Operación normal', 'Condiciones hidrológicas adversas', 'Suma de IHF distorsionado + DDV no confiable + RD inoperante');

-- -- Insert into recomendacion
-- INSERT INTO recomendacion (impacto_esperado, descripcion, objetivo, caso_ejemplo, prioridad) VALUES
-- ('Mayor precisión en la medición de confiabilidad', 'Revisar cálculo del IHF eliminando descuentos por anillos de seguridad', 'Eliminar distorsiones en IHF', 'Cálculo actual de IHF', 'Alta'),
-- ('Mayor confiabilidad en la respuesta de la demanda', 'Implementar verificaciones más estrictas en contratos DDV', NULL, NULL, NULL),
-- ('Evitar que derogación de normas deje inoperativos mecanismos críticos', 'Establecer proceso proactivo de armonización regulatoria continua', 'Mantener normativa energética actualizada y armonizada', 'Programa RD quedó inoperante por derogación de CREG 063/2010', 'Alta');

-- -- Insert into documento
-- INSERT INTO documento (tipo, codigo, descripcion, proposito, relevancia, problema_identificado) VALUES
-- ('Resolución', 'CREG-071-2006', 'Establece metodología para el cálculo del Cargo por Confiabilidad', NULL, NULL, NULL),
-- ('Comunicación XM', 'COM-202144032409-1', 'Solicitud de concepto sobre contratos DDV de un día', NULL, NULL, NULL),
-- ('Acuerdo Operativo', 'Acuerdo CNO 1336', 'Establecer curvas típicas de consumo de usuarios finales', 'Base para comparar curvas declaradas en contratos DDV con consumo real', NULL, 'Discrepancias entre curvas declaradas y curvas típicas del Acuerdo');

-- -- Insert into organizacion
-- INSERT INTO organizacion (tipo, rol, nombre) VALUES
-- ('Regulatoria', 'Regulador', 'CREG'),
-- ('Operativa', 'Operador del Sistema', 'XM'),
-- ('Operativa', 'Centro Nacional de Despacho', 'CND');

-- -- Insert into resolucion
-- INSERT INTO resolucion (descripcion, articulo, formula_ihf, codigo, fecha, estado, efecto) VALUES
-- ('Establece metodología para el cálculo del Cargo por Confiabilidad', 'Anexo 3, Numeral 3.4', '(HI + HD) / (HI + HO)', 'CREG 071 de 2006', '2006', NULL, NULL),
-- ('Regula el Programa de Respuesta de la Demanda (RD)', NULL, NULL, 'CREG 011 de 2015', '2015', 'Con referencias inoperantes', NULL),
-- ('Norma base para el Programa de RD', NULL, NULL, 'CREG 063 de 2010', '2010', 'Derogada por Resolución 101019 de 2022', NULL),
-- ('Deroga la Resolución 063 de 2010', NULL, NULL, 'CREG 101019 de 2022', '2022', NULL, 'Dejó inoperante el Programa de RD');

-- -- Insert into comunicacion
-- INSERT INTO comunicacion (asunto, emisor, codigo, fecha, receptor) VALUES
-- ('Solicitud de concepto sobre cálculo del IHF', 'XM', '201844009677-1', '2018', 'CREG'),
-- ('Discrepancias en curvas de consumo DDV', 'XM', '202444017182-1', '2024', 'CREG'),
-- ('Consulta sobre contratos DDV de un día', 'XM', '202144032409-1', '2021', 'CREG'),
-- ('Consulta sobre implementación DDV', 'XM', '013820-1', '2018', 'CREG'),
-- ('Validación de desconexiones DDV', 'XM', '202444024640-1', '2024', 'CREG'),
-- ('Inoperatividad del Programa RD', 'XM', '202344028418-1', '2023', 'CREG');

-- -- Insert into concepto
-- INSERT INTO concepto (proposito, nombre, objetivo, contexto, tipo, problema_identificado, componentes) VALUES
-- ('Garantizar seguridad y confiabilidad del suministro eléctrico', 'Cargo por Confiabilidad', 'Asegurar suficiente capacidad de generación para atender la demanda', 'Especialmente durante condiciones hidrológicas críticas o de escasez', 'Mecanismo de Mercado', NULL, NULL),
-- ('Proveer respaldos operativos al sistema', 'Anillos de Seguridad', NULL, NULL, 'Marco Conceptual', 'Pueden crear confiabilidad administrativa sin respaldo físico real', 'DDV, Mercado Secundario, RD');

-- -- Insert into metrica
-- INSERT INTO metrica (nombre, tipo, relacion_con_ihf, impacto, nombre_completo, definicion) VALUES
-- ('ENFICC', 'Métrica de Energía', 'Inversamente proporcional al IHF', 'Determina la capacidad de generación firme de una planta', 'Energía Firme para el Cargo por Confiabilidad', 'Máxima energía que una planta puede garantizar ininterrumpidamente durante condiciones de escasez hidrológica');

-- -- Insert into obligacion
-- INSERT INTO obligacion (tipo, definicion, incentivo_financiero, nombre, riesgo, nombre_completo) VALUES
-- ('Compromiso Contractual', 'Compromiso de entrega de energía que asume una planta basado en su ENFICC', 'Mayor ENFICC permite mayor OEF y mayor remuneración', 'OEF', 'Puede estar por encima de la capacidad real de la planta', 'Obligación de Energía Firme');

-- -- Insert into consecuencia
-- INSERT INTO consecuencia (nombre, tipo, impacto, causa_directa, efecto_en_planeacion, descripcion, categoria, realidad, visibilidad, caracterizacion) VALUES
-- ('Sobreestimación de ENFICC', 'Consecuencia Técnica', 'Sistema asume capacidad de respaldo inexistente', 'IHF artificialmente bajo por descuentos de anillos de seguridad', 'Cálculos de planeación basados en capacidad inflada', 'ENFICC declarada superior a capacidad real de generación', 'Técnica', 'Real', 'Alta', 'Inflada'),
-- ('Confiabilidad administrativa vs física', 'Consecuencia Sistémica', 'Vulnerabilidades físicas del sistema', NULL, NULL, 'Desconexión entre confiabilidad teórica asignada y capacidad física real', 'Riesgo Latente', 'Vulnerabilidades físicas del sistema', 'Confiabilidad en el papel', 'Confiabilidad puramente administrativa que enmascara fallas operativas');

-- -- Insert into condicion
-- INSERT INTO condicion (relacionado_con, tipo, problema_identificado, relevancia, nombre, descripcion) VALUES
-- ('Hidrología', 'Ambiental', 'Escasez hidrológica', 'Alta', 'Condiciones de Escasez', 'Baja hidrología afecta generación');

-- -- Insert into comportamiento
-- INSERT INTO comportamiento (descripcion, mecanismo, consecuencia, nombre, vacio_regulatorio, tipo) VALUES
-- ('Respuesta a indisponibilidades', 'Mercado Secundario', 'Distorsión de IHF', 'Uso de Anillos de Seguridad', 'Sí', 'Adaptativo');

-- -- Now insert relationships (using assumed ids: sistema 1; mecanismo 2,3,4; problema 5,6; riesgo 7; recomendacion 8; documento 9; organizacion 10,11; resolucion 12; comunicacion 13; concepto 14; metrica 15; obligacion 16; consecuencia 17; condicion 18; comportamiento 19; planta 20,21,22; hidrologia 23,24; anillo_seguridad 25,26; mercado 27; cargo_confiabilidad 28)

-- INSERT INTO relationships (from_table, from_id, to_table, to_id, type) VALUES
-- ('mecanismo', 2, 'sistema', 1, 'PERTENECE_A'),
-- ('mecanismo', 3, 'sistema', 1, 'PERTENECE_A'),
-- ('mecanismo', 4, 'sistema', 1, 'PERTENECE_A'),
-- ('problema', 5, 'mecanismo', 2, 'AFECTA_A'),
-- ('problema', 6, 'mecanismo', 2, 'AFECTA_A'),
-- ('problema', 6, 'metrica', 15, 'AFECTA_A'),
-- ('problema', 6, 'obligacion', 16, 'AFECTA_A'),
-- ('riesgo', 7, 'mecanismo', 2, 'GENERA'),
-- ('riesgo', 7, 'mecanismo', 3, 'GENERA'),
-- ('recomendacion', 8, 'problema', 5, 'SOLUCIONA'),
-- ('documento', 9, 'problema', 5, 'SOPORTA'),
-- ('resolucion', 12, 'mecanismo', 2, 'DEFINE'),
-- ('comunicacion', 13, 'mecanismo', 2, 'ABORDA'),
-- ('metrica', 15, 'mecanismo', 2, 'RELACIONADA_CON'),
-- ('obligacion', 16, 'metrica', 15, 'BASADA_EN'),
-- ('consecuencia', 17, 'problema', 5, 'RESULTA_DE'),
-- ('condicion', 18, 'riesgo', 7, 'AGRAVA'),
-- ('comportamiento', 19, 'mecanismo', 4, 'UTILIZA'),
-- ('planta', 20, 'metrica', 15, 'TIENE'),
-- ('planta', 21, 'metrica', 15, 'TIENE'),
-- ('planta', 22, 'metrica', 15, 'TIENE'),
-- ('planta', 20, 'obligacion', 16, 'CUMPLE'),
-- ('planta', 21, 'obligacion', 16, 'CUMPLE'),
-- ('planta', 22, 'obligacion', 16, 'CUMPLE'),
-- ('hidrologia', 23, 'mecanismo', 2, 'AFECTA'),
-- ('hidrologia', 24, 'mecanismo', 2, 'AFECTA'),
-- ('anillo_seguridad', 25, 'mecanismo', 2, 'MODIFICA'),
-- ('anillo_seguridad', 26, 'mecanismo', 2, 'MODIFICA'),
-- ('mercado', 27, 'mecanismo', 4, 'ES_TIPO_DE'),
-- ('cargo_confiabilidad', 28, 'metrica', 15, 'USA'),
-- ('cargo_confiabilidad', 28, 'obligacion', 16, 'REMUNERA');

-- New test data for tables from import.py

-- Insert into plantas
INSERT INTO plantas (nombre) VALUES
('Planta A'), ('Planta B'), ('Planta C'), ('Planta D'), ('Planta E'),
('Planta F'), ('Planta G'), ('Planta H'), ('Planta I'), ('Planta J'),
('Planta K'), ('Planta L'), ('Planta M'), ('Planta N'), ('Planta O'),
('Planta P'), ('Planta Q'), ('Planta R'), ('Planta S'), ('Planta T');

-- Insert into agentes
INSERT INTO agentes (nombre) VALUES
('Agente 1'), ('Agente 2'), ('Agente 3'), ('Agente 4'), ('Agente 5'),
('Agente 6'), ('Agente 7'), ('Agente 8'), ('Agente 9'), ('Agente 10'),
('Agente 11'), ('Agente 12'), ('Agente 13'), ('Agente 14'), ('Agente 15'),
('Agente 16'), ('Agente 17'), ('Agente 18'), ('Agente 19'), ('Agente 20');

-- Insert into recursos
INSERT INTO recursos (codigo_sic, tipo_generacion) VALUES
('SIC001', 'Hidroeléctrica'), ('SIC002', 'Térmica'), ('SIC003', 'Eólica'), ('SIC004', 'Solar'),
('SIC005', 'Hidroeléctrica'), ('SIC006', 'Térmica'), ('SIC007', 'Eólica'), ('SIC008', 'Solar'),
('SIC009', 'Hidroeléctrica'), ('SIC010', 'Térmica'), ('SIC011', 'Eólica'), ('SIC012', 'Solar'),
('SIC013', 'Hidroeléctrica'), ('SIC014', 'Térmica'), ('SIC015', 'Eólica'), ('SIC016', 'Solar'),
('SIC017', 'Hidroeléctrica'), ('SIC018', 'Térmica'), ('SIC019', 'Eólica'), ('SIC020', 'Solar');

-- Insert into rrid_antes_066_24
INSERT INTO rrid_antes_066_24 (planta_id, rrid_cop, rrid_sin_anillos_cop) VALUES
(1, 1000000, 950000),
(2, 1200000, 1100000),
(3, 800000, 750000),
(4, 1500000, 1400000),
(5, 900000, 850000),
(6, 1100000, 1050000),
(7, 1300000, 1250000),
(8, 700000, 650000),
(9, 1600000, 1550000),
(10, 950000, 900000),
(11, 1050000, 1000000),
(12, 1250000, 1200000),
(13, 850000, 800000),
(14, 1400000, 1350000),
(15, 750000, 700000),
(16, 1150000, 1100000),
(17, 1350000, 1300000),
(18, 650000, 600000),
(19, 1550000, 1500000),
(20, 1000000, 950000);

-- Insert into rrid_despues_066_24
INSERT INTO rrid_despues_066_24 (planta_id, rrid_cop, rrid_sin_anillos_cop) VALUES
(1, 1050000, 1000000),
(2, 1250000, 1150000),
(3, 850000, 800000),
(4, 1550000, 1500000),
(5, 950000, 900000),
(6, 1150000, 1100000),
(7, 1350000, 1300000),
(8, 750000, 700000),
(9, 1650000, 1600000),
(10, 1000000, 950000),
(11, 1100000, 1050000),
(12, 1300000, 1250000),
(13, 900000, 850000),
(14, 1450000, 1400000),
(15, 800000, 750000),
(16, 1200000, 1150000),
(17, 1400000, 1350000),
(18, 700000, 650000),
(19, 1600000, 1550000),
(20, 1050000, 1000000);

-- Insert into ddv_reg_vs_ddv_ver
INSERT INTO ddv_reg_vs_ddv_ver (planta_id, agente_id, fecha_dia, kwh_registrado, kwh_verificado) VALUES
(1, 1, '2023-01-01', 50000, 48000),
(2, 2, '2023-01-02', 60000, 59000),
(3, 3, '2023-01-03', 55000, 53000),
(4, 4, '2023-01-04', 65000, 64000),
(5, 5, '2023-01-05', 45000, 43000),
(6, 6, '2023-01-06', 70000, 69000),
(7, 7, '2023-01-07', 48000, 46000),
(8, 8, '2023-01-08', 62000, 61000),
(9, 9, '2023-01-09', 53000, 51000),
(10, 10, '2023-01-10', 58000, 57000),
(11, 11, '2023-01-11', 51000, 49000),
(12, 12, '2023-01-12', 64000, 63000),
(13, 13, '2023-01-13', 47000, 45000),
(14, 14, '2023-01-14', 69000, 68000),
(15, 15, '2023-01-15', 46000, 44000),
(16, 16, '2023-01-16', 71000, 70000),
(17, 17, '2023-01-17', 49000, 47000),
(18, 18, '2023-01-18', 63000, 62000),
(19, 19, '2023-01-19', 54000, 52000),
(20, 20, '2023-01-20', 59000, 58000);

-- Insert into ddv_verificada
INSERT INTO ddv_verificada (planta_id, agente_id, fecha_dia, kwh_verificado) VALUES
(1, 1, '2023-01-01', 48000),
(2, 2, '2023-01-02', 59000),
(3, 3, '2023-01-03', 53000),
(4, 4, '2023-01-04', 64000),
(5, 5, '2023-01-05', 43000),
(6, 6, '2023-01-06', 69000),
(7, 7, '2023-01-07', 46000),
(8, 8, '2023-01-08', 61000),
(9, 9, '2023-01-09', 51000),
(10, 10, '2023-01-10', 57000),
(11, 11, '2023-01-11', 49000),
(12, 12, '2023-01-12', 63000),
(13, 13, '2023-01-13', 45000),
(14, 14, '2023-01-14', 68000),
(15, 15, '2023-01-15', 44000),
(16, 16, '2023-01-16', 70000),
(17, 17, '2023-01-17', 47000),
(18, 18, '2023-01-18', 62000),
(19, 19, '2023-01-19', 52000),
(20, 20, '2023-01-20', 58000);

-- Insert into msec_reg_vs_msec_desp
INSERT INTO msec_reg_vs_msec_desp (planta_id, agente_id, kwh_registrado, kwh_despachado) VALUES
(1, 1, 45000, 44000),
(2, 2, 55000, 54000),
(3, 3, 48000, 47000),
(4, 4, 62000, 61000),
(5, 5, 41000, 40000),
(6, 6, 68000, 67000),
(7, 7, 46000, 45000),
(8, 8, 59000, 58000),
(9, 9, 50000, 49000),
(10, 10, 56000, 55000),
(11, 11, 47000, 46000),
(12, 12, 61000, 60000),
(13, 13, 43000, 42000),
(14, 14, 66000, 65000),
(15, 15, 42000, 41000),
(16, 16, 69000, 68000),
(17, 17, 45000, 44000),
(18, 18, 60000, 59000),
(19, 19, 51000, 50000),
(20, 20, 57000, 56000);

-- Insert into mapeo_recursos
INSERT INTO mapeo_recursos (recurso_id, agente_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20);

-- Insert into mapeo_agentes
INSERT INTO mapeo_agentes (recurso_id, agente_id, planta_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20);