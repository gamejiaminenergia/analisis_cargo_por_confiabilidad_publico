-- =====================================================================
-- CONSULTA UNIFICADA DE ANÁLISIS DE CARGO POR CONFIABILIDAD
-- (ADAPTADA A LA ESTRUCTURA DE BASE DE DATOS OPTIMIZADA/NORMALIZADA)
-- =====================================================================
-- Este script crea una tabla consolidada que integra información de tres fuentes principales:
-- 1. Índice de Horas Firmes (IHF)
-- 2. Despachos por Desconexión Voluntaria (DDV)
-- 3. Mercado Secundario
--
-- La tabla resultante utiliza las nuevas tablas maestras normalizadas
-- (agente_maestro y tipo_generacion_maestro).
-- =====================================================================

-- Configuración de búsqueda de ruta para asegurar que usamos el esquema correcto
SET search_path TO public;

-- =====================================================================
-- PASO 1: Eliminar la tabla si ya existe para evitar errores
-- =====================================================================
DROP TABLE IF EXISTS info_cargo_confiabilidad_unica;

-- =====================================================================
-- PASO 2: Crear la tabla consolidada con toda la información
-- =====================================================================
CREATE TABLE info_cargo_confiabilidad_unica AS
WITH 
-- 1. BASE DE GENERADORES (OPTIMIZADA)
-- Esta CTE obtiene la lista única de plantas de generación, y realiza
-- JOINS a las nuevas tablas maestras (agente_maestro y tipo_generacion_maestro)
-- para obtener los nombres completos a partir de los IDs en mapeo_recursos.
base_generadores AS (
    SELECT 
        COALESCE(pl.planta_nombre, 'SIN DATOS') AS planta_nombre,
        -- Obtenemos el nombre del Agente de la tabla maestra
        COALESCE(am.nombre_agente, 'NO ESPECIFICADO') AS agente_nombre,
        -- Obtenemos el Tipo de Generación de la tabla maestra
        COALESCE(tg.nombre_tipo, 'NO ESPECIFICADO') AS tipo_generacion
    FROM (
        -- Lista de plantas únicas de las tablas transaccionales
        SELECT planta_nombre FROM rrid_antes_066_24
        UNION
        SELECT planta_nombre FROM ddv_reg_vs_ddv_ver
        UNION
        SELECT planta_nombre FROM msec_reg_vs_msec_desp
    ) pl
    -- 1. Unimos a la tabla de mapeo (puente que tiene los IDs)
    LEFT JOIN mapeo_recursos mr 
        ON pl.planta_nombre = mr.planta_nombre
    -- 2. Unimos a la tabla maestra de Agentes
    LEFT JOIN agente_maestro am 
        ON mr.id_agente = am.id_agente
    -- 3. Unimos a la tabla maestra de Tipos de Generación
    LEFT JOIN tipo_generacion_maestro tg 
        ON mr.id_tipo_generacion = tg.id_tipo_generacion
),

-- 2. DATOS DE IHF (Índice de Horas Firmes) - Sin cambios, usa planta_nombre
datos_ihf AS (
    SELECT 
        planta_nombre,
        rrid_cop,
        rrid_sin_anillos_cop,
        perdida_anillos_millones_cop,
        pct_perdida_anillos,
        nivel_riesgo AS nivel_riesgo_ihf
    FROM info_distribucion_ihf
),

-- 3. DATOS DE DDV (Despachos por Desconexión Voluntaria) - Sin cambios, usa planta_nombre
datos_ddv AS (
    SELECT 
        planta_nombre,
        dias_con_discrepancia,
        mwh_verificado,
        nivel_prioridad AS nivel_riesgo_ddv
    FROM info_discrepancias_ddv
),

-- 4. DATOS DE MERCADO SECUNDARIO - Sin cambios, usa planta_nombre
datos_msec AS (
    SELECT 
        planta_nombre,
        mwh_registrado,
        mwh_despachado,
        mwh_diferencia,
        pct_diferencia,
        nivel_discrepancia AS nivel_riesgo_msec
    FROM info_mercado_secundario
)

-- =====================================================================
-- CONSULTA PRINCIPAL: Une toda la información en una sola tabla (sin cambios)
-- =====================================================================
SELECT 
    -- INFORMACIÓN BÁSICA
    -- Identificación de la planta y su agente propietario
    bg.planta_nombre,        -- Nombre de la planta generadora
    bg.agente_nombre,        -- Empresa propietaria de la planta (Ahora de agente_maestro)
    bg.tipo_generacion,      -- Tipo de generación (Ahora de tipo_generacion_maestro)
    
    -- INFORMACIÓN DE IHF (Índice de Horas Firmes)
    -- Mide la capacidad de generación confiable de la planta
    COALESCE(di.rrid_cop / 1000000, 0) AS rrid_millones_cop,  -- Ingresos por confiabilidad en millones de COP
    COALESCE(di.rrid_sin_anillos_cop / 1000000, 0) AS rrid_sin_anillos_millones_cop,  -- Ingresos potenciales sin restricciones
    COALESCE(di.perdida_anillos_millones_cop, 0) AS perdida_anillos_millones_cop,  -- Pérdida por restricciones
    COALESCE(di.pct_perdida_anillos, 0) AS pct_perdida_anillos,  -- Porcentaje de pérdida por restricciones
    COALESCE(di.nivel_riesgo_ihf, 'SIN RIESGO') AS nivel_riesgo_ihf,  -- Nivel de riesgo asociado (CRÍTICO, ALTO, MEDIO, BAJO)
    
    -- INFORMACIÓN DE DDV (Despachos por Desconexión Voluntaria)
    -- Controla las desconexiones no programadas
    COALESCE(dd.dias_con_discrepancia, 0) AS dias_con_discrepancia_ddv,  -- Días con desconexiones no justificadas
    COALESCE(dd.mwh_verificado, 0) AS mwh_verificado_ddv,  -- Energía no suministrada (MWh)
    COALESCE(dd.nivel_riesgo_ddv, 'SIN RIESGO') AS nivel_riesgo_ddv,  -- Nivel de riesgo por desconexiones
    
    -- INFORMACIÓN DE MERCADO SECUNDARIO
    -- Evalúa el cumplimiento de compromisos de generación
    COALESCE(dm.mwh_registrado, 0) AS mwh_registrado_msec,  -- Energía comprometida (MWh)
    COALESCE(dm.mwh_despachado, 0) AS mwh_despachado_msec,  -- Energía realmente entregada (MWh)
    COALESCE(dm.mwh_diferencia, 0) AS mwh_diferencia_msec,  -- Diferencia entre lo comprometido y entregado
    COALESCE(dm.pct_diferencia, 0) AS pct_diferencia_msec,  -- Porcentaje de diferencia
    COALESCE(dm.nivel_riesgo_msec, 'SIN RIESGO') AS nivel_riesgo_msec,  -- Nivel de riesgo por incumplimiento
    
    -- INDICADOR DE RIESGO GLOBAL
    -- Combina los riesgos de IHF, DDV y Mercado Secundario en un solo indicador
    CASE 
        -- RIESGO CRÍTICO: Al menos un indicador en nivel crítico
        WHEN di.nivel_riesgo_ihf = 'CRÍTICO' OR dd.nivel_riesgo_ddv = 'VERIFICAR URGENTE' OR dm.nivel_riesgo_msec = 'ALTA DISCREPANCIA' 
        THEN 'RIESGO CRÍTICO'
        -- RIESGO ALTO: Al menos un indicador en nivel alto
        WHEN di.nivel_riesgo_ihf = 'ALTO' OR dd.nivel_riesgo_ddv = 'REVISIÓN RECOMENDADA' OR dm.nivel_riesgo_msec = 'MEDIA DISCREPANCIA'
        THEN 'RIESGO ALTO'
        -- RIESGO MEDIO: Indicadores en nivel medio o bajo
        WHEN di.nivel_riesgo_ihf = 'MEDIO' OR dm.nivel_riesgo_msec = 'BAJA DISCREPANCIA'
        THEN 'RIESGO MEDIO'
        -- SIN DATOS: No hay información disponible
        WHEN di.nivel_riesgo_ihf IS NULL AND dd.nivel_riesgo_ddv IS NULL AND dm.nivel_riesgo_msec IS NULL
        THEN 'SIN DATOS'
        -- RIESGO BAJO: Todos los indicadores en nivel bajo o sin problemas
        ELSE 'RIESGO BAJO'
    END AS nivel_riesgo_global,
    
    -- METADATOS
    NOW() AS fecha_generacion  -- Fecha y hora de generación del reporte
    
FROM base_generadores bg
LEFT JOIN datos_ihf di ON bg.planta_nombre = di.planta_nombre
LEFT JOIN datos_ddv dd ON bg.planta_nombre = dd.planta_nombre
LEFT JOIN datos_msec dm ON bg.planta_nombre = dm.planta_nombre
ORDER BY 
    CASE 
        WHEN di.nivel_riesgo_ihf = 'CRÍTICO' OR dd.nivel_riesgo_ddv = 'VERIFICAR URGENTE' OR dm.nivel_riesgo_msec = 'ALTA DISCREPANCIA' THEN 1
        WHEN di.nivel_riesgo_ihf = 'ALTO' OR dd.nivel_riesgo_ddv = 'REVISIÓN RECOMENDADA' OR dm.nivel_riesgo_msec = 'MEDIA DISCREPANCIA' THEN 2
        WHEN di.nivel_riesgo_ihf = 'MEDIO' OR dm.nivel_riesgo_msec = 'BAJA DISCREPANCIA' THEN 3
        WHEN di.nivel_riesgo_ihf = 'BAJO' THEN 4
        ELSE 5
    END,
    bg.agente_nombre,
    bg.planta_nombre;

-- =====================================================================
-- PASO 3: Crear índices para optimizar las consultas posteriores (sin cambios)
-- =====================================================================
-- Índice para búsquedas por agente (empresa propietaria)
CREATE INDEX IF NOT EXISTS idx_info_cargo_agente ON info_cargo_confiabilidad_unica(agente_nombre);

-- Índice para filtrar por nivel de riesgo global
CREATE INDEX IF NOT EXISTS idx_info_cargo_riesgo ON info_cargo_confiabilidad_unica(nivel_riesgo_global);

-- Índice para búsquedas por nombre de planta
CREATE INDEX IF NOT EXISTS idx_info_cargo_planta ON info_cargo_confiabilidad_unica(planta_nombre);

-- =====================================================================
-- CONSULTAS DE EJEMPLO (sin cambios)
-- =====================================================================
-- 1. PLANTAS CON RIESGO CRÍTICO O ALTO
SELECT * FROM info_cargo_confiabilidad_unica 
WHERE nivel_riesgo_global IN ('RIESGO CRÍTICO', 'RIESGO ALTO')
ORDER BY 
    CASE nivel_riesgo_global 
        WHEN 'RIESGO CRÍTICO' THEN 1 
        WHEN 'RIESGO ALTO' THEN 2 
        ELSE 3 
    END,
    agente_nombre, 
    planta_nombre;

-- 2. RESUMEN POR NIVEL DE RIESGO GLOBAL
SELECT 
    nivel_riesgo_global AS "Nivel de Riesgo",
    COUNT(*) AS "Cantidad de Plantas",
    ROUND(SUM(perdida_anillos_millones_cop)::numeric, 2) AS "Pérdidas por Restricciones (MM COP)",
    ROUND(SUM(mwh_verificado_ddv)::numeric, 2) AS "Energía No Suministrada (MWh)",
    ROUND(SUM(mwh_diferencia_msec)::numeric, 2) AS "Incumplimiento de Compromisos (MWh)"
FROM info_cargo_confiabilidad_unica
GROUP BY nivel_riesgo_global
ORDER BY 
    CASE nivel_riesgo_global
        WHEN 'RIESGO CRÍTICO' THEN 1
        WHEN 'RIESGO ALTO' THEN 2
        WHEN 'RIESGO MEDIO' THEN 3
        WHEN 'RIESGO BAJO' THEN 4
        ELSE 5
    END;

-- 3. RESUMEN POR AGENTE (EMPRESA PROPIETARIA)
SELECT 
    agente_nombre AS "Empresa Generadora",
    COUNT(*) AS "Total Plantas",
    SUM(CASE WHEN nivel_riesgo_global = 'RIESGO CRÍTICO' THEN 1 ELSE 0 END) AS "Plantas Críticas",
    SUM(CASE WHEN nivel_riesgo_global = 'RIESGO ALTO' THEN 1 ELSE 0 END) AS "Plantas Alto Riesgo",
    SUM(CASE WHEN nivel_riesgo_global = 'RIESGO MEDIO' THEN 1 ELSE 0 END) AS "Plantas Riesgo Medio",
    SUM(CASE WHEN nivel_riesgo_global = 'RIESGO BAJO' THEN 1 ELSE 0 END) AS "Plantas Bajo Riesgo",
    ROUND(SUM(perdida_anillos_millones_cop)::numeric, 2) AS "Pérdidas Totales (MM COP)",
    ROUND(SUM(mwh_verificado_ddv)::numeric, 2) AS "Energía No Suministrada (MWh)",
    ROUND(SUM(mwh_diferencia_msec)::numeric, 2) AS "Incumplimiento Total (MWh)"
FROM info_cargo_confiabilidad_unica
GROUP BY agente_nombre
ORDER BY 
    SUM(CASE WHEN nivel_riesgo_global = 'RIESGO CRÍTICO' THEN 1 ELSE 0 END) DESC, 
    SUM(CASE WHEN nivel_riesgo_global = 'RIESGO ALTO' THEN 1 ELSE 0 END) DESC, 
    agente_nombre;