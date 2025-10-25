-- Esto borra todas las tablas, vistas, funciones, secuencias, índices, etc.
-- dentro del esquema "public"
DO
$$
DECLARE
    r RECORD;
BEGIN
    -- Desactiva restricciones temporales
    EXECUTE 'SET session_replication_role = replica';

    -- Elimina todo dentro del esquema public
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS public.' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;

    FOR r IN (SELECT viewname FROM pg_views WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP VIEW IF EXISTS public.' || quote_ident(r.viewname) || ' CASCADE';
    END LOOP;

    FOR r IN (SELECT routine_name FROM information_schema.routines WHERE specific_schema = 'public') LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS public.' || quote_ident(r.routine_name) || ' CASCADE';
    END LOOP;

    -- Reactiva restricciones
    EXECUTE 'SET session_replication_role = DEFAULT';
END
$$;

-- También puedes simplemente reiniciar el esquema "public":
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
