-- =====================================================================
-- SCRIPT DE GENERACIÓN DE DATOS DE PRUEBA (VERSIÓN OPTIMIZADA Y NORMALIZADA)
-- Objetivo: Mejorar la estructura para integridad, normalización y rendimiento.
-- Modificado para cumplir con los requisitos del Cargo por Confiabilidad
-- =====================================================================

SET search_path TO public;

-- =====================================================================
-- PASO 0: Tablas Maestras (Normalización 2NF/3NF)
-- Evita la duplicación de cadenas de texto de Agentes y Tipos.
-- =====================================================================

DROP TABLE IF EXISTS tipo_generacion_maestro CASCADE;
CREATE TABLE tipo_generacion_maestro (
    id_tipo_generacion SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) UNIQUE NOT NULL,
    factor_disponibilidad NUMERIC(5,4) NOT NULL DEFAULT 0.95,
    prioridad_despacho INTEGER NOT NULL DEFAULT 1,
    requiere_combustible BOOLEAN NOT NULL DEFAULT FALSE,
    es_renovable BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Inserción de tipos de generación con factores de disponibilidad y prioridades
INSERT INTO tipo_generacion_maestro (nombre_tipo, factor_disponibilidad, prioridad_despacho, requiere_combustible, es_renovable) VALUES
('TÉRMICA', 0.90, 2, TRUE, FALSE),
('HIDRÁULICA', 0.85, 1, FALSE, TRUE),
('SOLAR', 0.25, 4, FALSE, TRUE),
('EÓLICA', 0.35, 5, FALSE, TRUE),
('GEOTÉRMICA', 0.80, 3, FALSE, TRUE),
('BIOMASA', 0.75, 3, TRUE, TRUE);


DROP TABLE IF EXISTS agente_maestro CASCADE;
CREATE TABLE agente_maestro (
    id_agente SERIAL PRIMARY KEY,
    nombre_agente VARCHAR(100) UNIQUE NOT NULL,
    nit VARCHAR(20) UNIQUE NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    correo_electronico VARCHAR(100),
    representante_legal VARCHAR(100),
    fecha_creacion DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO', 'INACTIVO', 'SUSPENDIDO')),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Inserción de agentes con información adicional
INSERT INTO agente_maestro (nombre_agente, nit, direccion, telefono, correo_electronico, representante_legal, fecha_creacion, estado) VALUES
('EMPRESA ENERGIA SA', '900123456-1', 'Carrera 10 # 20-30, Bogotá', '6011234567', 'contacto@empresaenergia.com', 'Juan Pérez', '2000-01-15', 'ACTIVO'),
('GENERADORA NACIONAL', '800234567-2', 'Calle 5 # 12-45, Medellín', '6047654321', 'info@generadoranacional.com', 'María Gómez', '1995-05-22', 'ACTIVO'),
('ENERGIAS RENOVABLES SAS', '901234568-3', 'Avenida 30 # 45-67, Cali', '6029876543', 'contacto@energiasrenovables.co', 'Carlos Rojas', '2010-11-30', 'ACTIVO'),
('TERMOELECTRICA DEL SUR', '890123459-4', 'Carrera 8 # 15-20, Barranquilla', '6054321789', 'info@termosur.com', 'Ana Martínez', '2005-07-10', 'ACTIVO'),
('HIDROELECTRICA ANDINA', '780234560-5', 'Calle 25 # 40-12, Bucaramanga', '6075678901', 'contacto@hidroandina.com', 'Pedro Sánchez', '1990-03-18', 'ACTIVO'),
('GEOTERMIA MAX', '912345670-6', 'Avenida 15 # 25-35, Pereira', '6067890123', 'info@geothermiamax.com', 'Laura Ramírez', '2015-09-25', 'ACTIVO'),
('BIOENERGIA FUTURO', '823456780-7', 'Carrera 20 # 35-40, Manizales', '6089012345', 'contacto@bioenergiafuturo.com', 'Andrés López', '2012-12-05', 'ACTIVO');

-- =====================================================================
-- PASO 1: Mapeo de Recursos (Planta)
-- Usa claves externas (IDs) para el Agente y el Tipo de Generación.
-- =====================================================================
DROP TABLE IF EXISTS mapeo_recursos CASCADE;
CREATE TABLE mapeo_recursos (
    planta_nombre VARCHAR(100) PRIMARY KEY,
    id_agente INTEGER NOT NULL REFERENCES agente_maestro(id_agente),
    id_tipo_generacion INTEGER NOT NULL REFERENCES tipo_generacion_maestro(id_tipo_generacion),
    capacidad_instalada_mw NUMERIC(10,2) NOT NULL,
    capacidad_firme_mw NUMERIC(10,2) NOT NULL,
    fecha_puesta_operacion DATE NOT NULL,
    departamento VARCHAR(50) NOT NULL,
    municipio VARCHAR(50) NOT NULL,
    latitud DECIMAL(10,8),
    longitud DECIMAL(11,8),
    estado_operativo VARCHAR(20) NOT NULL DEFAULT 'OPERATIVA' CHECK (estado_operativo IN ('OPERATIVA', 'EN MANTENIMIENTO', 'FUERA DE SERVICIO')),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_agente_maestro FOREIGN KEY (id_agente) REFERENCES agente_maestro(id_agente),
    CONSTRAINT fk_tipo_generacion FOREIGN KEY (id_tipo_generacion) REFERENCES tipo_generacion_maestro(id_tipo_generacion)
);

-- Índices para mejorar rendimiento en consultas frecuentes
CREATE INDEX idx_mapeo_recursos_agente ON mapeo_recursos(id_agente);
CREATE INDEX idx_mapeo_recursos_tipo ON mapeo_recursos(id_tipo_generacion);
CREATE INDEX idx_mapeo_recursos_estado ON mapeo_recursos(estado_operativo);

-- Inserciones de Mapeo de Recursos (40 registros)
INSERT INTO mapeo_recursos (planta_nombre, id_agente, id_tipo_generacion, capacidad_instalada_mw, capacidad_firme_mw, fecha_puesta_operacion, departamento, municipio, latitud, longitud) VALUES
('PLANTA_TERMICA_A', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'EMPRESA ENERGIA SA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 150.00, 135.00, '2020-01-01', 'CUNDINAMARCA', 'BOGOTÁ', 4.710989, -74.072092),
('PLANTA_HIDRO_B', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GENERADORA NACIONAL'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 200.00, 170.00, '2019-05-15', 'ANTIOQUIA', 'MEDELLÍN', 6.244203, -75.581211),
('PLANTA_SOLAR_C', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'SOLAR'), 50.00, 12.50, '2021-03-10', 'VALLE DEL CAUCA', 'CALI', 3.451647, -76.531985),
('PLANTA_TERMICA_D', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'EMPRESA ENERGIA SA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 180.00, 162.00, '2020-07-22', 'ATLÁNTICO', 'BARRANQUILLA', 10.963889, -74.796387),
('PLANTA_EOLICA_E', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'EÓLICA'), 75.00, 26.25, '2022-01-30', 'LA GUAJIRA', 'RIOHACHA', 11.544445, -72.906944),
('PLANTA_HIDRO_F', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GENERADORA NACIONAL'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 250.00, 212.50, '2018-11-05', 'SANTANDER', 'BUCARAMANGA', 7.119349, -73.122742),
('PLANTA_TERMICA_G', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'TERMOELECTRICA DEL SUR'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 120.00, 108.00, '2021-09-14', 'VALLE DEL CAUCA', 'CALI', 3.451647, -76.531985),
('PLANTA_HIDRO_H', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'HIDROELECTRICA ANDINA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 300.00, 255.00, '2017-06-18', 'TOLIMA', 'IBAGUÉ', 4.438889, -75.232222),
('PLANTA_GEO_I', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GEOTERMIA MAX'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'GEOTÉRMICA'), 40.00, 32.00, '2022-04-25', 'NARIÑO', 'PASTO', 1.213611, -77.281111),
('PLANTA_TERMICA_J', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'EMPRESA ENERGIA SA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 160.00, 144.00, '2020-03-12', 'SANTANDER', 'BARRANCABERMEJA', 7.065278, -73.854722),
('PLANTA_HIDRO_K', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GENERADORA NACIONAL'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 220.00, 187.00, '2019-08-20', 'HUILA', 'NEIVA', 2.934483, -75.2809),
('PLANTA_SOLAR_L', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'SOLAR'), 60.00, 15.00, '2021-11-15', 'CESAR', 'VALLEDUPAR', 10.46314, -73.25322),
('PLANTA_TERMICA_M', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'TERMOELECTRICA DEL SUR'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 110.00, 99.00, '2021-02-28', 'BOLÍVAR', 'CARTAGENA', 10.391049, -75.479426),
('PLANTA_EOLICA_N', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'EÓLICA'), 80.00, 28.00, '2022-07-10', 'LA GUAJIRA', 'MAICAO', 11.3778, -72.2397),
('PLANTA_HIDRO_O', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'HIDROELECTRICA ANDINA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 280.00, 238.00, '2018-04-22', 'RISARALDA', 'PEREIRA', 4.81333, -75.69611),
('PLANTA_BIO_P', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'BIOENERGIA FUTURO'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'BIOMASA'), 30.00, 22.50, '2022-05-18', 'VALLE DEL CAUCA', 'PALMIRA', 3.539444, -76.303611),
('PLANTA_TERMICA_Q', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'EMPRESA ENERGIA SA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 140.00, 126.00, '2020-10-05', 'MAGDALENA', 'SANTA MARTA', 11.240355, -74.211023),
('PLANTA_HIDRO_R', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GENERADORA NACIONAL'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 190.00, 161.50, '2019-12-15', 'CALDAS', 'MANIZALES', 5.070275, -75.513817),
('PLANTA_SOLAR_S', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'SOLAR'), 55.00, 13.75, '2022-02-28', 'CESAR', 'AGUACHICA', 8.308333, -73.616667),
('PLANTA_TERMICA_T', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'TERMOELECTRICA DEL SUR'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 130.00, 117.00, '2021-06-20', 'SANTANDER', 'BUCARAMANGA', 7.119349, -73.122742),
('PLANTA_EOLICA_U', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'EÓLICA'), 70.00, 24.50, '2022-09-12', 'LA GUAJIRA', 'URIBIA', 11.7139, -72.2658),
('PLANTA_HIDRO_V', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'HIDROELECTRICA ANDINA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 260.00, 221.00, '2018-08-25', 'TOLIMA', 'MELGAR', 4.204722, -74.640833),
('PLANTA_TERMICA_W', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'EMPRESA ENERGIA SA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 170.00, 153.00, '2020-12-10', 'BOLÍVAR', 'CARTAGENA', 10.391049, -75.479426),
('PLANTA_HIDRO_X', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GENERADORA NACIONAL'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 210.00, 178.50, '2019-03-18', 'ANTIOQUIA', 'RIONEGRO', 6.155151, -75.373711),
('PLANTA_SOLAR_Y', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'SOLAR'), 65.00, 16.25, '2022-01-20', 'CESAR', 'AGUACHICA', 8.308333, -73.616667),
('PLANTA_EOLICA_Z', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'EÓLICA'), 85.00, 29.75, '2022-10-05', 'LA GUAJIRA', 'MANAURE', 11.775, -72.4475),
('PLANTA_HIDRO_AA', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'HIDROELECTRICA ANDINA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 240.00, 204.00, '2018-11-30', 'RISARALDA', 'PEREIRA', 4.81333, -75.69611),
('PLANTA_TERMICA_BB', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'TERMOELECTRICA DEL SUR'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 100.00, 90.00, '2021-04-15', 'VALLE DEL CAUCA', 'BUENAVENTURA', 3.893611, -77.069167),
('PLANTA_HIDRO_CC', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GENERADORA NACIONAL'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 230.00, 195.50, '2019-07-22', 'CALDAS', 'MANIZALES', 5.070275, -75.513817),
('PLANTA_SOLAR_DD', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'SOLAR'), 70.00, 17.50, '2022-03-15', 'CESAR', 'AGUACHICA', 8.308333, -73.616667),
('PLANTA_TERMICA_EE', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'EMPRESA ENERGIA SA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 150.00, 135.00, '2020-08-18', 'MAGDALENA', 'CIÉNAGA', 11.004167, -74.25),
('PLANTA_EOLICA_FF', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'EÓLICA'), 90.00, 31.50, '2022-11-20', 'LA GUAJIRA', 'MANAURE', 11.775, -72.4475),
('PLANTA_HIDRO_GG', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'HIDROELECTRICA ANDINA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 270.00, 229.50, '2018-09-10', 'TOLIMA', 'MELGAR', 4.204722, -74.640833),
('PLANTA_TERMICA_HH', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'TERMOELECTRICA DEL SUR'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 120.00, 108.00, '2021-05-25', 'BOLÍVAR', 'CARTAGENA', 10.391049, -75.479426),
('PLANTA_HIDRO_II', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'GENERADORA NACIONAL'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 200.00, 170.00, '2019-10-12', 'ANTIOQUIA', 'RIONEGRO', 6.155151, -75.373711),
('PLANTA_SOLAR_JJ', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'SOLAR'), 75.00, 18.75, '2022-04-10', 'VALLE DEL CAUCA', 'PALMIRA', 3.539444, -76.303611),
('PLANTA_TERMICA_KK', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'EMPRESA ENERGIA SA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 160.00, 144.00, '2020-11-22', 'MAGDALENA', 'SANTA MARTA', 11.240355, -74.211023),
('PLANTA_EOLICA_LL', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'ENERGIAS RENOVABLES SAS'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'EÓLICA'), 95.00, 33.25, '2022-12-15', 'LA GUAJIRA', 'URIBIA', 11.7139, -72.2658),
('PLANTA_HIDRO_MM', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'HIDROELECTRICA ANDINA'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'HIDRÁULICA'), 290.00, 246.50, '2018-12-05', 'RISARALDA', 'PEREIRA', 4.81333, -75.69611),
('PLANTA_TERMICA_NN', (SELECT id_agente FROM agente_maestro WHERE nombre_agente = 'TERMOELECTRICA DEL SUR'), (SELECT id_tipo_generacion FROM tipo_generacion_maestro WHERE nombre_tipo = 'TÉRMICA'), 140.00, 126.00, '2021-07-30', 'VALLE DEL CAUCA', 'BUENAVENTURA', 3.893611, -77.069167);


-- =====================================================================
-- TABLA: INDISPONIBILIDAD HISTÓRICA FORZADA (IHF)
-- Almacena el cálculo del Índice de Indisponibilidad Histórica Forzada
-- Modificado según Resolución CREG 071 de 2006 y ajustes regulatorios
-- =====================================================================
DROP TABLE IF EXISTS indice_indisponibilidad CASCADE;
CREATE TABLE indice_indisponibilidad (
    id SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL REFERENCES mapeo_recursos(planta_nombre),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    horas_indisponibilidad NUMERIC(10,2) NOT NULL DEFAULT 0,
    horas_derrateo NUMERIC(10,2) NOT NULL DEFAULT 0,
    horas_operacion NUMERIC(10,2) NOT NULL DEFAULT 0,
    -- Campos para seguimiento de cobertura DDV
    horas_cubiertas_ddv NUMERIC(10,2) NOT NULL DEFAULT 0,
    horas_indisponibilidad_sin_ddv NUMERIC(10,2) NOT NULL DEFAULT 0,
    indice_ihf_teorico NUMERIC(5,4) NOT NULL DEFAULT 0,
    indice_ihf_real NUMERIC(5,4) NOT NULL DEFAULT 0,
    observaciones TEXT,
    usuario_registro VARCHAR(50) NOT NULL DEFAULT 'SISTEMA',
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (planta_nombre, fecha_inicio, fecha_fin)
);

-- Índices para consultas frecuentes
CREATE INDEX idx_indisponibilidad_planta ON indice_indisponibilidad(planta_nombre);
CREATE INDEX idx_indisponibilidad_fechas ON indice_indisponibilidad(fecha_inicio, fecha_fin);

-- =====================================================================
-- TABLA: DETALLE DE INDISPONIBILIDADES
-- Registra eventos específicos de indisponibilidad
-- Actualizado para incluir información de cobertura DDV
-- =====================================================================
DROP TABLE IF EXISTS detalle_indisponibilidades CASCADE;
CREATE TABLE detalle_indisponibilidades (
    id SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL REFERENCES mapeo_recursos(planta_nombre),
    fecha_hora_inicio TIMESTAMP NOT NULL,
    fecha_hora_fin TIMESTAMP,
    duracion_minutos INTEGER,
    tipo_indisponibilidad VARCHAR(50) NOT NULL CHECK (tipo_indisponibilidad IN ('FORZADA', 'PROGRAMADA', 'DERATEO', 'DDV')),
    causa_raiz VARCHAR(100),
    descripcion TEXT,
    mw_afectados NUMERIC(10,2) NOT NULL,
    porcentaje_capacidad_afectada NUMERIC(5,2) NOT NULL,
    -- Nuevos campos para seguimiento de cobertura DDV
    cubierto_por_ddv BOOLEAN NOT NULL DEFAULT FALSE,
    id_contrato_ddv VARCHAR(50),
    mw_cubiertos_ddv NUMERIC(10,2) DEFAULT 0,
    porcentaje_cobertura_ddv NUMERIC(5,2) DEFAULT 0,
    -- Auditoría
    usuario_registro VARCHAR(50) NOT NULL DEFAULT 'SISTEMA',
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_fechas CHECK (fecha_hora_fin IS NULL OR fecha_hora_fin >= fecha_hora_inicio),
    CONSTRAINT chk_cobertura_ddv CHECK (
        (cubierto_por_ddv = FALSE AND id_contrato_ddv IS NULL) OR 
        (cubierto_por_ddv = TRUE AND id_contrato_ddv IS NOT NULL)
    )
);

-- Índices para consultas frecuentes
CREATE INDEX idx_det_indis_planta ON detalle_indisponibilidades(planta_nombre);
CREATE INDEX idx_det_indis_fechas ON detalle_indisponibilidades(fecha_hora_inicio, fecha_hora_fin);

-- =====================================================================
-- TABLA: CAPACIDAD RRID HISTÓRICA
-- Mantenemos la tabla existente pero la mejoramos
-- =====================================================================
DROP TABLE IF EXISTS rrid_antes_066_24 CASCADE;
CREATE TABLE rrid_antes_066_24 (
    id SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    capacidad_mw NUMERIC(10,2) NOT NULL,
    capacidad_firme_mw NUMERIC(10,2),
    factor_planta NUMERIC(5,4),
    horas_operacion_mes NUMERIC(8,2),
    disponibilidad_operativa NUMERIC(5,4),
    usuario_registro VARCHAR(50) DEFAULT 'SISTEMA',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla ddv_reg_vs_ddv_ver
DROP TABLE IF EXISTS ddv_reg_vs_ddv_ver CASCADE;
CREATE TABLE ddv_reg_vs_ddv_ver (
    id SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    mwh_registrados NUMERIC(10,2) NOT NULL,
    mwh_verificados NUMERIC(10,2) NOT NULL,
    diferencia_mwh NUMERIC(10,2) NOT NULL,
    porcentaje_desviacion NUMERIC(5,2) NOT NULL,
    nivel_riesgo VARCHAR(20) NOT NULL
);

-- Crear tabla ofertas_msec
DROP TABLE IF EXISTS ofertas_msec CASCADE;
CREATE TABLE ofertas_msec (
    id_oferta SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL,
    fecha_hora_oferta TIMESTAMP NOT NULL,
    mw_ofertados NUMERIC(10,2) NOT NULL,
    precio_maximo NUMERIC(10,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla info_distribucion_ihf
DROP TABLE IF EXISTS info_distribucion_ihf CASCADE;
CREATE TABLE info_distribucion_ihf (
    id SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL,
    rango_ihf VARCHAR(50) NOT NULL,
    cantidad_eventos INTEGER NOT NULL,
    porcentaje NUMERIC(5,2) NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_planta_ihf FOREIGN KEY (planta_nombre) REFERENCES mapeo_recursos(planta_nombre)
);

-- Crear tabla info_discrepancias_ddv
DROP TABLE IF EXISTS info_discrepancias_ddv CASCADE;
CREATE TABLE info_discrepancias_ddv (
    id SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    mw_registrados NUMERIC(10,2) NOT NULL,
    mw_verificados NUMERIC(10,2) NOT NULL,
    diferencia_mw NUMERIC(10,2) NOT NULL,
    porcentaje_desviacion NUMERIC(5,2) NOT NULL,
    nivel_riesgo VARCHAR(20) NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_planta_ddv FOREIGN KEY (planta_nombre) REFERENCES mapeo_recursos(planta_nombre)
);

-- Crear tabla info_mercado_secundario
DROP TABLE IF EXISTS info_mercado_secundario CASCADE;
CREATE TABLE info_mercado_secundario (
    id SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    mw_ofertados NUMERIC(10,2) NOT NULL,
    mw_despachados NUMERIC(10,2) NOT NULL,
    porcentaje_despacho NUMERIC(5,2) NOT NULL,
    precio_promedio NUMERIC(10,2) NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_planta_msec FOREIGN KEY (planta_nombre) REFERENCES mapeo_recursos(planta_nombre)
);
-- Column additions moved to table creation above

INSERT INTO rrid_antes_066_24 (planta_nombre, fecha, capacidad_mw) VALUES
('PLANTA_TERMICA_A', '2024-01-01', 150.00),
('PLANTA_HIDRO_B', '2024-01-01', 200.00),
('PLANTA_SOLAR_C', '2024-01-01', 50.00),
('PLANTA_TERMICA_D', '2024-01-01', 180.00),
('PLANTA_EOLICA_E', '2024-01-01', 75.00),
('PLANTA_HIDRO_F', '2024-01-02', 250.00),
('PLANTA_TERMICA_G', '2024-01-02', 120.00),
('PLANTA_HIDRO_H', '2024-01-02', 300.00),
('PLANTA_GEO_I', '2024-01-03', 40.00),
('PLANTA_TERMICA_J', '2024-01-03', 160.00),
('PLANTA_HIDRO_K', '2024-01-03', 220.00),
('PLANTA_SOLAR_L', '2024-01-04', 60.00),
('PLANTA_TERMICA_M', '2024-01-04', 110.00),
('PLANTA_EOLICA_N', '2024-01-04', 80.00),
('PLANTA_HIDRO_O', '2024-01-05', 280.00),
('PLANTA_BIO_P', '2024-01-05', 30.00),
('PLANTA_TERMICA_Q', '2024-01-05', 140.00),
('PLANTA_HIDRO_R', '2024-01-06', 190.00),
('PLANTA_SOLAR_S', '2024-01-06', 55.00),
('PLANTA_TERMICA_T', '2024-01-06', 130.00),
('PLANTA_EOLICA_U', '2024-01-07', 70.00),
('PLANTA_HIDRO_V', '2024-01-07', 260.00),
('PLANTA_TERMICA_W', '2024-01-07', 170.00),
('PLANTA_HIDRO_X', '2024-01-08', 210.00),
('PLANTA_SOLAR_Y', '2024-01-08', 65.00);


-- =====================================================================
-- TABLA: CONTRATOS DE DEMANDA DESCONECTABLE VOLUNTARIA (DDV)
-- Registra los contratos de DDV establecidos con los usuarios
-- Actualizado según requisitos regulatorios y controles adicionales
-- =====================================================================
DROP TABLE IF EXISTS contratos_ddv CASCADE;
CREATE TABLE contratos_ddv (
    id_contrato VARCHAR(50) PRIMARY KEY,
    id_agente INTEGER NOT NULL,
    id_planta_asociada VARCHAR(100),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    capacidad_mw NUMERIC(10,2) NOT NULL,
    tipo_contrato VARCHAR(50) NOT NULL CHECK (tipo_contrato IN ('FIJO', 'VARIABLE', 'DIARIO')),
    -- Nuevos campos para control de pruebas y verificación
    requiere_prueba_aleatoria BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_ultima_prueba TIMESTAMP,
    resultado_ultima_prueba VARCHAR(20) CHECK (resultado_ultima_prueba IN ('EXITOSA', 'FALLIDA', 'PENDIENTE')),
    porcentaje_efectividad_pruebas NUMERIC(5,2) DEFAULT 0,
    -- Estado y auditoría
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO', 'INACTIVO', 'SUSPENDIDO', 'EN_VERIFICACION')),
    motivo_suspension TEXT,
    usuario_registro VARCHAR(50) NOT NULL DEFAULT 'SISTEMA',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_fechas_contrato CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_prueba_resultado CHECK (
        (resultado_ultima_prueba IS NULL AND fecha_ultima_prueba IS NULL) OR 
        (resultado_ultima_prueba IS NOT NULL AND fecha_ultima_prueba IS NOT NULL)
    )
);

-- =====================================================================
-- TABLA: PRUEBAS DE VERIFICACIÓN DDV
-- Registra las pruebas de verificación realizadas a los contratos DDV
-- =====================================================================
DROP TABLE IF EXISTS pruebas_verificacion_ddv CASCADE;
CREATE TABLE pruebas_verificacion_ddv (
    id_prueba SERIAL PRIMARY KEY,
    id_contrato VARCHAR(50) NOT NULL,
    fecha_hora_prueba TIMESTAMP NOT NULL,
    tipo_prueba VARCHAR(50) NOT NULL CHECK (tipo_prueba IN ('PROGRAMADA', 'ALEATORIA', 'ESPECIAL')),
    resultado VARCHAR(20) NOT NULL CHECK (resultado IN ('EXITOSA', 'FALLIDA', 'PARCIAL')),
    porcentaje_efectividad NUMERIC(5,2) NOT NULL,
    duracion_minutos INTEGER NOT NULL,
    mw_desconectados NUMERIC(10,2) NOT NULL,
    mw_esperados NUMERIC(10,2) NOT NULL,
    observaciones TEXT,
    -- Auditoría
    usuario_ejecutor VARCHAR(50) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_porcentaje_efectividad CHECK (porcentaje_efectividad BETWEEN 0 AND 100),
    CONSTRAINT chk_mw_desconectados CHECK (mw_desconectados >= 0 AND mw_desconectados <= mw_esperados)
);

-- Índices para búsquedas frecuentes
CREATE INDEX idx_pruebas_contrato ON pruebas_verificacion_ddv(id_contrato);
CREATE INDEX idx_pruebas_fecha ON pruebas_verificacion_ddv(fecha_hora_prueba);

-- Índices para consultas frecuentes
CREATE INDEX idx_contratos_ddv_planta ON contratos_ddv(planta_nombre);
CREATE INDEX idx_contratos_ddv_estado ON contratos_ddv(estado_contrato);
CREATE INDEX idx_contratos_ddv_fechas ON contratos_ddv(fecha_inicio, fecha_fin);

-- =====================================================================
-- TABLA: EVENTOS DE DESCONEXIÓN DDV
-- Registra eventos de desconexión de DDV
-- =====================================================================
DROP TABLE IF EXISTS eventos_desconexion_ddv CASCADE;
CREATE TABLE eventos_desconexion_ddv (
    id_evento SERIAL PRIMARY KEY,
    id_contrato VARCHAR(50) NOT NULL REFERENCES contratos_ddv(id_contrato),
    fecha_hora_solicitud TIMESTAMP NOT NULL,
    fecha_hora_ejecucion TIMESTAMP,
    mw_solicitados NUMERIC(10,2) NOT NULL,
    mw_desconectados NUMERIC(10,2),
    duracion_minutos INTEGER,
    estado_evento VARCHAR(20) NOT NULL CHECK (estado_evento IN ('SOLICITADO', 'EJECUTADO', 'CANCELADO', 'FALLIDO')),
    tipo_evento VARCHAR(20) NOT NULL CHECK (tipo_evento IN ('PRUEBA', 'REAL', 'SIMULACION')),
    observaciones TEXT,
    usuario_solicitud VARCHAR(50) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para consultas frecuentes
CREATE INDEX idx_eventos_ddv_contrato ON eventos_desconexion_ddv(id_contrato);
CREATE INDEX idx_eventos_ddv_fechas ON eventos_desconexion_ddv(fecha_hora_solicitud, fecha_hora_ejecucion);

-- =====================================================================
-- DATOS DE PRUEBA PARA CONTRATOS_DDV
-- =====================================================================
INSERT INTO contratos_ddv (
    id_contrato, id_agente, id_planta_asociada, fecha_inicio, fecha_fin, 
    capacidad_mw, tipo_contrato, requiere_prueba_aleatoria, 
    fecha_ultima_prueba, resultado_ultima_prueba, porcentaje_efectividad_pruebas, 
    estado, motivo_suspension, usuario_registro
) VALUES
-- Contratos para plantas térmicas
('CTO-TERM-001', 1, 'PLANTA_TERMICA_A', '2023-01-15', '2024-12-31', 50.00, 'FIJO', TRUE, '2023-12-15 10:00:00', 'EXITOSA', 95.50, 'ACTIVO', NULL, 'admin'),
('CTO-TERM-002', 4, 'PLANTA_TERMICA_D', '2023-02-20', '2024-12-31', 75.00, 'VARIABLE', TRUE, '2023-12-10 11:30:00', 'EXITOSA', 92.30, 'ACTIVO', NULL, 'admin'),
('CTO-TERM-003', 7, 'PLANTA_TERMICA_G', '2023-03-10', '2024-06-30', 60.00, 'FIJO', TRUE, '2023-12-05 09:15:00', 'FALLIDA', 85.75, 'ACTIVO', 'Prueba fallida el 5/12', 'admin'),

-- Contratos para plantas hidroeléctricas
('CTO-HIDRO-001', 2, 'PLANTA_HIDRO_B', '2023-01-05', '2024-12-31', 100.00, 'FIJO', FALSE, NULL, NULL, 100.00, 'ACTIVO', NULL, 'admin'),
('CTO-HIDRO-002', 5, 'PLANTA_HIDRO_F', '2023-02-15', '2024-12-31', 120.00, 'VARIABLE', TRUE, '2023-12-12 14:20:00', 'EXITOSA', 98.20, 'ACTIVO', NULL, 'admin'),

-- Contratos para energías renovables
('CTO-RENOV-001', 3, 'PLANTA_SOLAR_C', '2023-04-01', '2024-12-31', 25.00, 'FIJO', TRUE, '2023-12-08 13:45:00', 'EXITOSA', 94.80, 'ACTIVO', NULL, 'admin'),
('CTO-RENOV-002', 6, 'PLANTA_EOLICA_E', '2023-05-15', '2024-12-31', 40.00, 'VARIABLE', TRUE, '2023-12-14 10:30:00', 'EXITOSA', 96.40, 'ACTIVO', NULL, 'admin'),
('CTO-RENOV-003', 3, 'PLANTA_GEO_I', '2023-06-01', '2024-12-31', 20.00, 'FIJO', FALSE, NULL, NULL, 100.00, 'ACTIVO', NULL, 'admin');

-- Actualizar fechas de actualización
UPDATE contratos_ddv SET fecha_actualizacion = CURRENT_TIMESTAMP;

-- =====================================================================
-- DATOS DE PRUEBA PARA PRUEBAS_VERIFICACION_DDV
-- =====================================================================
INSERT INTO pruebas_verificacion_ddv (
    id_contrato, fecha_hora_prueba, tipo_prueba, resultado, 
    porcentaje_efectividad, duracion_minutos, mw_desconectados, 
    mw_esperados, observaciones, usuario_ejecutor
) VALUES
-- Pruebas para contrato CTO-TERM-001
('CTO-TERM-001', '2023-01-20 10:00:00', 'PROGRAMADA', 'EXITOSA', 100.00, 30, 50.00, 50.00, 'Prueba inicial exitosa', 'usuario1'),
('CTO-TERM-001', '2023-04-15 11:30:00', 'PROGRAMADA', 'EXITOSA', 98.50, 30, 49.25, 50.00, 'Segunda prueba exitosa', 'usuario2'),
('CTO-TERM-001', '2023-07-10 09:45:00', 'ALEATORIA', 'EXITOSA', 99.00, 30, 49.50, 50.00, 'Prueba aleatoria sin incidencias', 'usuario1'),
('CTO-TERM-001', '2023-10-05 14:20:00', 'PROGRAMADA', 'EXITOSA', 97.80, 30, 48.90, 50.00, 'Cuarta prueba exitosa', 'usuario3'),

-- Pruebas para contrato CTO-HIDRO-002
('CTO-HIDRO-002', '2023-03-01 13:15:00', 'PROGRAMADA', 'EXITOSA', 100.00, 45, 120.00, 120.00, 'Primera prueba exitosa', 'usuario2'),
('CTO-HIDRO-002', '2023-06-15 10:30:00', 'ALEATORIA', 'EXITOSA', 98.33, 45, 118.00, 120.00, 'Prueba aleatoria con resultado positivo', 'usuario1'),
('CTO-HIDRO-002', '2023-09-20 11:00:00', 'PROGRAMADA', 'EXITOSA', 99.17, 45, 119.00, 120.00, 'Tercera prueba exitosa', 'usuario3'),

-- Pruebas para contrato CTO-RENOV-002
('CTO-RENOV-002', '2023-06-01 12:00:00', 'PROGRAMADA', 'EXITOSA', 100.00, 20, 40.00, 40.00, 'Primera prueba exitosa', 'usuario3'),
('CTO-RENOV-002', '2023-09-10 14:30:00', 'ALEATORIA', 'EXITOSA', 97.50, 20, 39.00, 40.00, 'Prueba aleatoria con buen resultado', 'usuario2'),

-- Prueba fallida para contrato CTO-TERM-003
('CTO-TERM-003', '2023-04-05 10:15:00', 'PROGRAMADA', 'FALLIDA', 85.75, 30, 42.88, 50.00, 'Fallo en la desconexión de 7.12 MW', 'usuario1');

-- Actualizar fechas de última prueba en contratos
UPDATE contratos_ddv c
SET fecha_ultima_prueba = p.fecha_hora_prueba,
    resultado_ultima_prueba = p.resultado,
    porcentaje_efectividad_pruebas = p.porcentaje_efectividad
FROM (
    SELECT id_contrato, fecha_hora_prueba, resultado, porcentaje_efectividad,
           ROW_NUMBER() OVER (PARTITION BY id_contrato ORDER BY fecha_hora_prueba DESC) as rn
    FROM pruebas_verificacion_ddv
) p
WHERE c.id_contrato = p.id_contrato AND p.rn = 1;

-- =====================================================================
-- DATOS DE PRUEBA PARA EVENTOS_DESCONEXION_DDV
-- =====================================================================
INSERT INTO eventos_desconexion_ddv (
    id_contrato, fecha_hora_solicitud, fecha_hora_ejecucion, 
    mw_solicitados, mw_desconectados, duracion_minutos, 
    estado_evento, tipo_evento, observaciones, usuario_solicitud
) VALUES
-- Eventos reales para CTO-TERM-001
('CTO-TERM-001', '2023-02-15 18:30:00', '2023-02-15 18:35:00', 45.00, 44.50, 120, 'EJECUTADO', 'REAL', 'Desconexión por demanda pico', 'sistema_autom'),
('CTO-TERM-001', '2023-05-20 19:15:00', '2023-05-20 19:20:00', 48.00, 47.80, 90, 'EJECUTADO', 'REAL', 'Ajuste de carga nocturna', 'sistema_autom'),

-- Eventos reales para CTO-HIDRO-002
('CTO-HIDRO-002', '2023-03-10 17:45:00', '2023-03-10 17:50:00', 110.00, 108.50, 180, 'EJECUTADO', 'REAL', 'Reducción de generación hidroeléctrica', 'sistema_autom'),
('CTO-HIDRO-002', '2023-07-05 18:30:00', '2023-07-05 18:35:00', 115.00, 114.20, 150, 'EJECUTADO', 'REAL', 'Ajuste por pronóstico de lluvias', 'sistema_autom'),

-- Eventos de prueba
('CTO-TERM-001', '2023-03-10 10:00:00', '2023-03-10 10:05:00', 30.00, 29.80, 30, 'EJECUTADO', 'PRUEBA', 'Prueba de desconexión parcial', 'usuario1'),
('CTO-HIDRO-002', '2023-04-15 11:30:00', '2023-04-15 11:35:00', 60.00, 59.50, 45, 'EJECUTADO', 'PRUEBA', 'Prueba de respuesta rápida', 'usuario2'),

-- Evento fallido
('CTO-TERM-003', '2023-05-20 14:15:00', '2023-05-20 14:20:00', 50.00, 42.00, 15, 'FALLIDO', 'REAL', 'Fallo en la desconexión de 8 MW', 'sistema_autom');

-- =====================================================================
-- DATOS DE PRUEBA PARA OFERTAS_MSEC
-- =====================================================================
INSERT INTO ofertas_msec (
    planta_nombre, fecha_hora_oferta, fecha_despacho, 
    hora_inicio, hora_fin, mw_ofrecidos, 
    precio_oferta, estado_oferta, usuario_registro
) VALUES
-- Ofertas aceptadas
('PLANTA_TERMICA_A', '2024-01-02 08:15:00', '2024-01-03', 8, 20, 120.00, 180.50, 'ACEPTADA', 'usuario1'),
('PLANTA_HIDRO_B', '2024-01-02 08:20:00', '2024-01-03', 6, 22, 180.00, 150.00, 'ACEPTADA', 'usuario2'),
('PLANTA_SOLAR_C', '2024-01-02 08:25:00', '2024-01-03', 6, 18, 45.00, 200.00, 'ACEPTADA', 'usuario1'),

-- Ofertas rechazadas
('PLANTA_TERMICA_D', '2024-01-02 08:30:00', '2024-01-03', 10, 20, 150.00, 250.00, 'RECHAZADA', 'usuario3'),
('PLANTA_EOLICA_E', '2024-01-02 08:35:00', '2024-01-03', 8, 18, 65.00, 300.00, 'RECHAZADA', 'usuario2'),

-- Ofertas para el día siguiente
('PLANTA_TERMICA_A', '2024-01-03 08:15:00', '2024-01-04', 8, 20, 120.00, 175.50, 'REGISTRADA', 'usuario1'),
('PLANTA_HIDRO_B', '2024-01-03 08:20:00', '2024-01-04', 6, 22, 180.00, 145.00, 'REGISTRADA', 'usuario2'),
('PLANTA_SOLAR_C', '2024-01-03 08:25:00', '2024-01-04', 6, 18, 45.00, 195.00, 'REGISTRADA', 'usuario1');

-- =====================================================================
-- DATOS DE PRUEBA PARA TRANSACCIONES_MSEC
-- =====================================================================
INSERT INTO transacciones_msec (
    id_oferta, planta_nombre, fecha_transaccion, fecha_despacho, 
    hora_inicio, hora_fin, mw_transados, precio_transaccion, 
    contraparte, estado_transaccion, usuario_registro
) VALUES
-- Transacciones para ofertas aceptadas
(1, 'PLANTA_TERMICA_A', '2024-01-02 10:15:00', '2024-01-03', 8, 20, 115.00, 180.50, 'COMPRADOR_1', 'CONFIRMADA', 'sistema'),
(2, 'PLANTA_HIDRO_B', '2024-01-02 10:20:00', '2024-01-03', 6, 22, 175.00, 150.00, 'COMPRADOR_2', 'CONFIRMADA', 'sistema'),
(3, 'PLANTA_SOLAR_C', '2024-01-02 10:25:00', '2024-01-03', 6, 18, 42.00, 200.00, 'COMPRADOR_3', 'CONFIRMADA', 'sistema'),

-- Transacción cancelada
(4, 'PLANTA_TERMICA_D', '2024-01-02 10:30:00', '2024-01-03', 10, 20, 150.00, 250.00, 'COMPRADOR_4', 'CANCELADA', 'sistema');

-- Actualizar estado de ofertas basado en transacciones
UPDATE ofertas_msec 
SET estado_oferta = 'ACEPTADA', 
    fecha_actualizacion = CURRENT_TIMESTAMP
WHERE id_oferta IN (1, 2, 3);

UPDATE ofertas_msec 
SET estado_oferta = 'CANCELADA', 
    fecha_actualizacion = CURRENT_TIMESTAMP
WHERE id_oferta = 4;

-- =====================================================================
-- TABLA: REGISTRO VS VERIFICACIÓN DDV (MANTENIENDO LA ESTRUCTURA ORIGINAL)
-- =====================================================================
-- Primero eliminamos las columnas problemáticas si existen
ALTER TABLE IF EXISTS ddv_reg_vs_ddv_ver 
    DROP COLUMN IF EXISTS id_contrato,
    DROP COLUMN IF EXISTS diferencia_mwh,
    DROP COLUMN IF EXISTS porcentaje_desviacion;

-- Luego agregamos las columnas necesarias
ALTER TABLE ddv_reg_vs_ddv_ver 
    ADD COLUMN id_contrato VARCHAR(50) REFERENCES contratos_ddv(id_contrato),
    ADD COLUMN diferencia_mwh NUMERIC(12,2),
    ADD COLUMN porcentaje_desviacion NUMERIC(5,2);
    ADD COLUMN tipo_prueba VARCHAR(20) CHECK (tipo_prueba IN ('ALEATORIA', 'PROGRAMADA', 'ESPECIAL')),
    ADD COLUMN resultado_prueba VARCHAR(20) CHECK (resultado_prueba IN ('EXITOSA', 'FALLIDA', 'PENDIENTE')),
    ADD COLUMN observaciones TEXT,
    ADD COLUMN usuario_registro VARCHAR(50) DEFAULT 'SISTEMA',
    ADD COLUMN fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN usuario_verificacion VARCHAR(50),
    ADD COLUMN fecha_verificacion TIMESTAMP;

-- Insertar datos en ddv_reg_vs_ddv_ver con referencias a contratos existentes
INSERT INTO ddv_reg_vs_ddv_ver (
    planta_nombre, fecha, mwh_registrados, mwh_verificados, 
    diferencia_mwh, porcentaje_desviacion, nivel_riesgo, id_contrato
) VALUES
-- Datos para PLANTA_TERMICA_A (referencia a CTO-TERM-001)
('PLANTA_TERMICA_A', '2024-01-15', 3600.00, 3450.00, 150.00, 4.35, 'MEDIO', 'CTO-TERM-001'),
('PLANTA_HIDRO_B', '2024-01-15', 4800.00, 4800.00, 0.00, 0.00, 'BAJO', 'CTO-HIDRO-001'),
('PLANTA_HIDRO_F', '2024-01-15', 5200.00, 5100.00, 100.00, 1.96, 'BAJO', 'CTO-HIDRO-002'),
('PLANTA_TERMICA_G', '2024-01-15', 2800.00, 2500.00, 300.00, 12.00, 'ALTO', 'CTO-TERM-003'),
('PLANTA_TERMICA_D', '2024-01-16', 4000.00, 3950.00, 50.00, 1.27, 'BAJO', 'CTO-TERM-002'),
('PLANTA_EOLICA_E', '2024-01-16', 1800.00, 1800.00, 0.00, 0.00, 'BAJO', 'CTO-RENOV-002'),
('PLANTA_SOLAR_C', '2024-01-17', 960.00, 960.00, 0.00, 0.00, 'BAJO', 'CTO-RENOV-001'),
('PLANTA_GEO_I', '2024-01-17', 960.00, 960.00, 0.00, 0.00, 'BAJO', 'CTO-RENOV-003');

-- Actualizar columnas calculadas
UPDATE ddv_reg_vs_ddv_ver 
SET diferencia_mwh = mwh_registrados - mwh_verificados,
    porcentaje_desviacion = CASE 
        WHEN mwh_verificados > 0 THEN ((mwh_registrados - mwh_verificados) / mwh_verificados) * 100 
        ELSE 0 
    END,
    nivel_riesgo = CASE 
        WHEN ABS(COALESCE(((mwh_registrados - mwh_verificados) / NULLIF(mwh_verificados, 0)) * 100, 0)) > 10 THEN 'ALTO'
        WHEN ABS(COALESCE(((mwh_registrados - mwh_verificados) / NULLIF(mwh_verificados, 0)) * 100, 0)) > 5 THEN 'MEDIO'
        ELSE 'BAJO'
    END;

-- =====================================================================
-- TABLA: OFERTAS MERCADO SECUNDARIO (MSEC)
-- Registra las ofertas realizadas en el mercado secundario
-- =====================================================================
DROP TABLE IF EXISTS ofertas_msec CASCADE;

CREATE TABLE ofertas_msec (
    id_oferta SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL REFERENCES mapeo_recursos(planta_nombre),
    fecha_hora_oferta TIMESTAMP NOT NULL,
    fecha_despacho DATE NOT NULL,
    hora_inicio INTEGER NOT NULL CHECK (hora_inicio BETWEEN 0 AND 23),
    hora_fin INTEGER NOT NULL CHECK (hora_fin BETWEEN 1 AND 24),
    mw_ofrecidos NUMERIC(10,2) NOT NULL,
    precio_oferta NUMERIC(10,2) NOT NULL,
    estado_oferta VARCHAR(20) NOT NULL CHECK (estado_oferta IN ('REGISTRADA', 'ACEPTADA', 'RECHAZADA', 'CANCELADA')),
    usuario_registro VARCHAR(50) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de prueba para ofertas_msec
INSERT INTO ofertas_msec (
    planta_nombre, fecha_hora_oferta, fecha_despacho, 
    hora_inicio, hora_fin, mw_ofrecidos, 
    precio_oferta, estado_oferta, usuario_registro
) VALUES
-- Ofertas aceptadas
('PLANTA_TERMICA_A', '2024-01-02 08:15:00', '2024-01-03', 8, 20, 120.00, 180.50, 'ACEPTADA', 'usuario1'),
('PLANTA_HIDRO_B', '2024-01-02 08:20:00', '2024-01-03', 6, 22, 180.00, 150.00, 'ACEPTADA', 'usuario2'),
('PLANTA_SOLAR_C', '2024-01-02 08:25:00', '2024-01-03', 6, 18, 45.00, 200.00, 'ACEPTADA', 'usuario1'),

-- Ofertas rechazadas
('PLANTA_TERMICA_D', '2024-01-02 08:30:00', '2024-01-03', 10, 20, 150.00, 250.00, 'RECHAZADA', 'usuario3'),
('PLANTA_EOLICA_E', '2024-01-02 08:35:00', '2024-01-03', 8, 18, 65.00, 300.00, 'RECHAZADA', 'usuario2'),

-- Ofertas para el día siguiente
('PLANTA_TERMICA_A', '2024-01-03 08:15:00', '2024-01-04', 8, 20, 120.00, 175.50, 'REGISTRADA', 'usuario1'),
('PLANTA_HIDRO_B', '2024-01-03 08:20:00', '2024-01-04', 6, 22, 180.00, 145.00, 'REGISTRADA', 'usuario2'),
('PLANTA_SOLAR_C', '2024-01-03 08:25:00', '2024-01-04', 6, 18, 45.00, 195.00, 'REGISTRADA', 'usuario1');

-- Crear índice para búsquedas frecuentes
CREATE INDEX idx_ofertas_msec_planta ON ofertas_msec(planta_nombre);
CREATE INDEX idx_ofertas_msec_fecha ON ofertas_msec(fecha_despacho);
CREATE TABLE ofertas_msec (
    id_oferta SERIAL PRIMARY KEY,
    planta_nombre VARCHAR(100) NOT NULL REFERENCES mapeo_recursos(planta_nombre),
    fecha_hora_oferta TIMESTAMP NOT NULL,
    fecha_despacho DATE NOT NULL,
    hora_inicio INTEGER NOT NULL CHECK (hora_inicio BETWEEN 0 AND 23),
    hora_fin INTEGER NOT NULL CHECK (hora_fin BETWEEN 1 AND 24),
    mw_ofrecidos NUMERIC(10,2) NOT NULL,
    precio_oferta NUMERIC(10,2) NOT NULL,
    estado_oferta VARCHAR(20) NOT NULL CHECK (estado_oferta IN ('REGISTRADA', 'ACEPTADA', 'RECHAZADA', 'CANCELADA')),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_registro VARCHAR(50) NOT NULL DEFAULT 'SISTEMA',
    CONSTRAINT chk_horas_oferta CHECK (hora_fin > hora_inicio)
);

-- Índices para consultas frecuentes
CREATE INDEX idx_ofertas_msec_planta ON ofertas_msec(planta_nombre);
CREATE INDEX idx_ofertas_msec_fechas ON ofertas_msec(fecha_despacho, hora_inicio, hora_fin);

-- =====================================================================
-- TABLA: TRANSACCIONES MERCADO SECUNDARIO (MSEC)
-- Registra las transacciones realizadas en el mercado secundario
-- =====================================================================
DROP TABLE IF EXISTS transacciones_msec CASCADE;

CREATE TABLE transacciones_msec (
    id_transaccion SERIAL PRIMARY KEY,
    id_oferta INTEGER REFERENCES ofertas_msec(id_oferta),
    planta_nombre VARCHAR(100) NOT NULL REFERENCES mapeo_recursos(planta_nombre),
    fecha_transaccion TIMESTAMP NOT NULL,
    fecha_despacho DATE NOT NULL,
    hora_inicio INTEGER NOT NULL CHECK (hora_inicio BETWEEN 0 AND 23),
    hora_fin INTEGER NOT NULL CHECK (hora_fin BETWEEN 1 AND 24),
    mw_transados NUMERIC(10,2) NOT NULL,
    precio_transaccion NUMERIC(10,2) NOT NULL,
    contraparte VARCHAR(100) NOT NULL,
    estado_transaccion VARCHAR(20) NOT NULL CHECK (estado_transaccion IN ('PENDIENTE', 'CONFIRMADA', 'CANCELADA')),
    usuario_registro VARCHAR(50) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de prueba para transacciones_msec
INSERT INTO transacciones_msec (
    id_oferta, planta_nombre, fecha_transaccion, fecha_despacho, 
    hora_inicio, hora_fin, mw_transados, precio_transaccion, 
    contraparte, estado_transaccion, usuario_registro
) VALUES
-- Transacciones para ofertas aceptadas
(1, 'PLANTA_TERMICA_A', '2024-01-02 10:15:00', '2024-01-03', 8, 20, 115.00, 180.50, 'COMPRADOR_1', 'CONFIRMADA', 'sistema'),
(2, 'PLANTA_HIDRO_B', '2024-01-02 10:20:00', '2024-01-03', 6, 22, 175.00, 150.00, 'COMPRADOR_2', 'CONFIRMADA', 'sistema'),
(3, 'PLANTA_SOLAR_C', '2024-01-02 10:25:00', '2024-01-03', 6, 18, 42.00, 200.00, 'COMPRADOR_3', 'CONFIRMADA', 'sistema'),

-- Transacción cancelada
(4, 'PLANTA_TERMICA_D', '2024-01-02 10:30:00', '2024-01-03', 10, 20, 150.00, 250.00, 'COMPRADOR_4', 'CANCELADA', 'sistema');

-- Actualizar estado de ofertas basado en transacciones
UPDATE ofertas_msec 
SET estado_oferta = 'ACEPTADA', 
    fecha_actualizacion = CURRENT_TIMESTAMP
WHERE id_oferta IN (1, 2, 3);

UPDATE ofertas_msec 
SET estado_oferta = 'CANCELADA', 
    fecha_actualizacion = CURRENT_TIMESTAMP
WHERE id_oferta = 4;

-- Crear índices para búsquedas frecuentes
CREATE INDEX idx_transacciones_msec_planta ON transacciones_msec(planta_nombre);
CREATE INDEX idx_transacciones_msec_fecha ON transacciones_msec(fecha_despacho);
CREATE INDEX idx_transacciones_msec_estado ON transacciones_msec(estado_transaccion);
CREATE TABLE transacciones_msec (
    id_transaccion SERIAL PRIMARY KEY,
    id_oferta INTEGER REFERENCES ofertas_msec(id_oferta),
    planta_nombre VARCHAR(100) NOT NULL REFERENCES mapeo_recursos(planta_nombre),
    fecha_transaccion TIMESTAMP NOT NULL,
    fecha_despacho DATE NOT NULL,
    hora_inicio INTEGER NOT NULL CHECK (hora_inicio BETWEEN 0 AND 23),
    hora_fin INTEGER NOT NULL CHECK (hora_fin BETWEEN 1 AND 24),
    mw_transados NUMERIC(10,2) NOT NULL,
    precio_transaccion NUMERIC(10,2) NOT NULL,
    contraparte VARCHAR(100),
    estado_transaccion VARCHAR(20) NOT NULL CHECK (estado_transaccion IN ('PENDIENTE', 'CONFIRMADA', 'RECHAZADA', 'CANCELADA')),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_registro VARCHAR(50) NOT NULL DEFAULT 'SISTEMA',
    CONSTRAINT chk_horas_transaccion CHECK (hora_fin > hora_inicio)
);

-- Índices para consultas frecuentes
CREATE INDEX idx_transacciones_msec_planta ON transacciones_msec(planta_nombre);
CREATE INDEX idx_transacciones_msec_fechas ON transacciones_msec(fecha_despacho, hora_inicio, hora_fin);

-- =====================================================================
-- TABLA: REGISTRO VS DESPACHO MSEC (MANTENIENDO LA ESTRUCTURA ORIGINAL)
-- =====================================================================
ALTER TABLE msec_reg_vs_msec_desp 
    ADD COLUMN id_transaccion INTEGER REFERENCES transacciones_msec(id_transaccion),
    ADD COLUMN diferencia_mwh NUMERIC(12,2) GENERATED ALWAYS AS (mwh_registrado - mwh_despachado) STORED,
    ADD COLUMN porcentaje_cumplimiento NUMERIC(5,2) GENERATED ALWAYS AS 
        (CASE 
            WHEN mwh_registrado > 0 THEN (mwh_despachado / mwh_registrado) * 100 
            ELSE 0 
        END) STORED,
    ADD COLUMN precio_promedio NUMERIC(10,2),
    ADD COLUMN estado_despacho VARCHAR(20) CHECK (estado_despacho IN ('COMPLETO', 'PARCIAL', 'PENDIENTE', 'CANCELADO')),
    ADD COLUMN observaciones TEXT,
    ADD COLUMN usuario_registro VARCHAR(50) DEFAULT 'SISTEMA',
    ADD COLUMN fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

INSERT INTO msec_reg_vs_msec_desp (planta_nombre, fecha, mwh_registrado, mwh_despachado) VALUES
('PLANTA_SOLAR_C', '2024-02-01', 1200.00, 1150.00),
('PLANTA_EOLICA_E', '2024-02-01', 1800.00, 1750.00),
('PLANTA_HIDRO_H', '2024-02-01', 6500.00, 6200.00),
('PLANTA_TERMICA_A', '2024-02-01', 3500.00, 3500.00),
('PLANTA_TERMICA_D', '2024-02-02', 4200.00, 4150.00),
('PLANTA_HIDRO_F', '2024-02-02', 5500.00, 5000.00),
('PLANTA_TERMICA_G', '2024-02-02', 3000.00, 2980.00),
('PLANTA_HIDRO_B', '2024-02-03', 5000.00, 5000.00),
('PLANTA_GEO_I', '2024-02-03', 1000.00, 950.00),
('PLANTA_TERMICA_J', '2024-02-03', 4000.00, 3900.00),
('PLANTA_HIDRO_K', '2024-02-04', 5200.00, 4800.00),
('PLANTA_SOLAR_L', '2024-02-04', 1500.00, 1450.00),
('PLANTA_TERMICA_M', '2024-02-04', 2800.00, 2800.00),
('PLANTA_EOLICA_N', '2024-02-05', 2000.00, 1900.00),
('PLANTA_HIDRO_O', '2024-02-05', 7000.00, 6800.00),
('PLANTA_BIO_P', '2024-02-05', 800.00, 800.00),
('PLANTA_TERMICA_Q', '2024-02-06', 3500.00, 3400.00),
('PLANTA_HIDRO_R', '2024-02-06', 4700.00, 4650.00),
('PLANTA_SOLAR_S', '2024-02-06', 1400.00, 1200.00),
('PLANTA_TERMICA_T', '2024-02-07', 3200.00, 3200.00);

-- =====================================================================
-- PASOS 5, 6, 7: Tablas de Resumen/Reporte (Mantienen la estructura original
-- de datos 'quemados' para facilitar la adaptación de la consulta unificada,
-- pero ahora con claves foráneas para integridad).
-- Nota: En un diseño puramente normalizado, estas tablas se generarían con
-- vistas o consultas resumen de los datos transaccionales (Pasos 3 y 4).
-- =====================================================================

DROP TABLE IF EXISTS info_distribucion_ihf CASCADE;
CREATE TABLE info_distribucion_ihf (
    planta_nombre VARCHAR(100) PRIMARY KEY REFERENCES mapeo_recursos(planta_nombre),
    rrid_cop NUMERIC(15,2),
    rrid_sin_anillos_cop NUMERIC(15,2),
    perdida_anillos_millones_cop NUMERIC(10,2),
    pct_perdida_anillos NUMERIC(5,2),
    nivel_riesgo VARCHAR(20) -- CRÍTICO, ALTO, MEDIO, BAJO
);

INSERT INTO info_distribucion_ihf VALUES
('PLANTA_TERMICA_A', 45000000.00, 50000000.00, 5.00, 10.00, 'CRÍTICO'),
('PLANTA_HIDRO_B', 80000000.00, 82000000.00, 2.00, 2.44, 'BAJO'),
('PLANTA_SOLAR_C', 20000000.00, 28000000.00, 8.00, 28.57, 'ALTO'),
('PLANTA_TERMICA_D', 55000000.00, 60000000.00, 5.00, 8.33, 'MEDIO'),
('PLANTA_EOLICA_E', 30000000.00, 32000000.00, 2.00, 6.25, 'BAJO'),
('PLANTA_HIDRO_F', 95000000.00, 100000000.00, 5.00, 5.00, 'BAJO'),
('PLANTA_TERMICA_G', 48000000.00, 55000000.00, 7.00, 12.73, 'CRÍTICO'),
('PLANTA_HIDRO_H', 120000000.00, 125000000.00, 5.00, 4.00, 'BAJO'),
('PLANTA_GEO_I', 15000000.00, 16000000.00, 1.00, 6.25, 'BAJO'),
('PLANTA_TERMICA_J', 60000000.00, 75000000.00, 15.00, 20.00, 'CRÍTICO'),
('PLANTA_HIDRO_K', 88000000.00, 92000000.00, 4.00, 4.35, 'BAJO'),
('PLANTA_SOLAR_L', 25000000.00, 30000000.00, 5.00, 16.67, 'ALTO'),
('PLANTA_TERMICA_M', 40000000.00, 45000000.00, 5.00, 11.11, 'CRÍTICO'),
('PLANTA_EOLICA_N', 35000000.00, 38000000.00, 3.00, 7.89, 'MEDIO'),
('PLANTA_HIDRO_O', 110000000.00, 115000000.00, 5.00, 4.35, 'BAJO'),
('PLANTA_BIO_P', 12000000.00, 13000000.00, 1.00, 7.69, 'MEDIO'),
('PLANTA_TERMICA_Q', 52000000.00, 55000000.00, 3.00, 5.45, 'BAJO'),
('PLANTA_HIDRO_R', 78000000.00, 80000000.00, 2.00, 2.50, 'BAJO'),
('PLANTA_SOLAR_S', 18000000.00, 22000000.00, 4.00, 18.18, 'ALTO'),
('PLANTA_TERMICA_T', 38000000.00, 40000000.00, 2.00, 5.00, 'BAJO');


DROP TABLE IF EXISTS info_discrepancias_ddv CASCADE;
CREATE TABLE info_discrepancias_ddv (
    planta_nombre VARCHAR(100) PRIMARY KEY REFERENCES mapeo_recursos(planta_nombre),
    dias_con_discrepancia INTEGER,
    mwh_verificado NUMERIC(12,2),
    nivel_prioridad VARCHAR(30) -- VERIFICAR URGENTE, REVISIÓN RECOMENDADA, SIN DISCREPANCIAS
);

INSERT INTO info_discrepancias_ddv VALUES
('PLANTA_TERMICA_A', 12, 1850.50, 'VERIFICAR URGENTE'),
('PLANTA_HIDRO_B', 0, 0.00, 'SIN DISCREPANCIAS'),
('PLANTA_HIDRO_F', 3, 320.00, 'REVISIÓN RECOMENDADA'),
('PLANTA_TERMICA_G', 8, 1240.00, 'VERIFICAR URGENTE'),
('PLANTA_TERMICA_D', 1, 50.00, 'SIN DISCREPANCIAS'),
('PLANTA_EOLICA_E', 0, 0.00, 'SIN DISCREPANCIAS'),
('PLANTA_HIDRO_H', 4, 200.00, 'REVISIÓN RECOMENDADA'),
('PLANTA_GEO_I', 0, 0.00, 'SIN DISCREPANCIAS'),
('PLANTA_TERMICA_J', 15, 2500.00, 'VERIFICAR URGENTE'),
('PLANTA_HIDRO_K', 0, 0.00, 'SIN DISCREPANCIAS'),
('PLANTA_SOLAR_L', 2, 40.00, 'SIN DISCREPANCIAS'),
('PLANTA_TERMICA_M', 0, 0.00, 'SIN DISCREPANCIAS'),
('PLANTA_EOLICA_N', 5, 100.00, 'REVISIÓN RECOMENDADA'),
('PLANTA_HIDRO_O', 0, 0.00, 'SIN DISCREPANCIAS'),
('PLANTA_BIO_P', 6, 150.00, 'REVISIÓN RECOMENDADA'),
('PLANTA_TERMICA_Q', 0, 0.00, 'SIN DISCREPANCIAS'),
('PLANTA_HIDRO_R', 2, 60.00, 'SIN DISCREPANCIAS'),
('PLANTA_SOLAR_S', 7, 200.00, 'REVISIÓN RECOMENDADA'),
('PLANTA_TERMICA_T', 9, 350.00, 'VERIFICAR URGENTE'),
('PLANTA_EOLICA_U', 0, 0.00, 'SIN DISCREPANCIAS');


DROP TABLE IF EXISTS info_mercado_secundario CASCADE;
CREATE TABLE info_mercado_secundario (
    planta_nombre VARCHAR(100) PRIMARY KEY REFERENCES mapeo_recursos(planta_nombre),
    mwh_registrado NUMERIC(12,2),
    mwh_despachado NUMERIC(12,2),
    mwh_diferencia NUMERIC(12,2),
    pct_diferencia NUMERIC(5,2),
    nivel_discrepancia VARCHAR(30) -- ALTA DISCREPANCIA, MEDIA DISCREPANCIA, BAJA DISCREPANCIA, SIN DISCREPANCIA
);

INSERT INTO info_mercado_secundario VALUES
('PLANTA_SOLAR_C', 36000.00, 34500.00, -1500.00, -4.17, 'BAJA DISCREPANCIA'),
('PLANTA_EOLICA_E', 54000.00, 52500.00, -1500.00, -2.78, 'BAJA DISCREPANCIA'),
('PLANTA_HIDRO_H', 195000.00, 186000.00, -9000.00, -4.62, 'MEDIA DISCREPANCIA'),
('PLANTA_TERMICA_A', 105000.00, 105000.00, 0.00, 0.00, 'SIN DISCREPANCIA'),
('PLANTA_TERMICA_D', 120000.00, 118000.00, -2000.00, -1.67, 'SIN DISCREPANCIA'),
('PLANTA_HIDRO_F', 150000.00, 135000.00, -15000.00, -10.00, 'ALTA DISCREPANCIA'),
('PLANTA_TERMICA_G', 90000.00, 88000.00, -2000.00, -2.22, 'BAJA DISCREPANCIA'),
('PLANTA_HIDRO_B', 140000.00, 140000.00, 0.00, 0.00, 'SIN DISCREPANCIA'),
('PLANTA_GEO_I', 28000.00, 27500.00, -500.00, -1.79, 'SIN DISCREPANCIA'),
('PLANTA_TERMICA_J', 130000.00, 120000.00, -10000.00, -7.69, 'MEDIA DISCREPANCIA'),
('PLANTA_HIDRO_K', 160000.00, 155000.00, -5000.00, -3.13, 'BAJA DISCREPANCIA'),
('PLANTA_SOLAR_L', 45000.00, 42000.00, -3000.00, -6.67, 'MEDIA DISCREPANCIA'),
('PLANTA_TERMICA_M', 85000.00, 85000.00, 0.00, 0.00, 'SIN DISCREPANCIA'),
('PLANTA_EOLICA_N', 60000.00, 57000.00, -3000.00, -5.00, 'MEDIA DISCREPANCIA'),
('PLANTA_HIDRO_O', 200000.00, 198000.00, -2000.00, -1.00, 'SIN DISCREPANCIA'),
('PLANTA_BIO_P', 25000.00, 24000.00, -1000.00, -4.00, 'BAJA DISCREPANCIA'),
('PLANTA_TERMICA_Q', 110000.00, 105000.00, -5000.00, -4.55, 'BAJA DISCREPANCIA'),
('PLANTA_HIDRO_R', 135000.00, 130000.00, -5000.00, -3.70, 'BAJA DISCREPANCIA'),
('PLANTA_SOLAR_S', 30000.00, 25000.00, -5000.00, -16.67, 'ALTA DISCREPANCIA'),
('PLANTA_TERMICA_T', 80000.00, 80000.00, 0.00, 0.00, 'SIN DISCREPANCIA');


-- =====================================================================
-- VERIFICACIÓN: Mostrar resumen de datos creados
-- =====================================================================
SELECT 'Tablas optimizadas, normalizadas y con integridad referencial garantizada' AS resultado;

-- Verificación segura de tablas
DO $$
DECLARE
    query_text TEXT;
    rec RECORD;
    table_name TEXT;
    table_names TEXT[] := ARRAY[
        'agente_maestro',
        'tipo_generacion_maestro',
        'mapeo_recursos',
        'rrid_antes_066_24',
        'ddv_reg_vs_ddv_ver',
        'info_distribucion_ihf',
        'info_discrepancias_ddv',
        'info_mercado_secundario',
        'contratos_ddv',
        'ofertas_msec',
        'transacciones_msec',
        'msec_reg_vs_msec_desp'
    ];
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table_counts (
        tabla TEXT,
        registros BIGINT
    );
    
    TRUNCATE temp_table_counts;
    
    FOREACH table_name IN ARRAY table_names LOOP
        BEGIN
            query_text := format('INSERT INTO temp_table_counts SELECT %L, COUNT(*) FROM %I', 
                               table_name, table_name);
            EXECUTE query_text;
        EXCEPTION WHEN OTHERS THEN
            INSERT INTO temp_table_counts VALUES (table_name, -1); -- -1 indica error
        END;
    END LOOP;
    
    -- Mostrar resultados
    RAISE NOTICE 'Resumen de registros por tabla:';
    FOR rec IN SELECT * FROM temp_table_counts ORDER BY tabla LOOP
        IF rec.registros = -1 THEN
            RAISE NOTICE '%-30s: Error al contar registros', rec.tabla;
        ELSIF rec.registros = 0 THEN
            RAISE NOTICE '%-30s: %s registro(s) - (Tabla vacía)', rec.tabla, rec.registros;
        ELSE
            RAISE NOTICE '%-30s: %s registro(s)', rec.tabla, rec.registros;
        END IF;
    END LOOP;
    
    DROP TABLE temp_table_counts;
END $$;