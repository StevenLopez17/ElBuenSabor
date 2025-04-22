# Crear un archivo temporal modificado para Railway
cat > elbuensabor_railway.sql << 'EOL'
--
-- PostgreSQL database dump (modificado para Railway)
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Omitida creación de base de datos
-- Omitido cambio de propietario
-- Omitido comando connect

-- Schema

CREATE SCHEMA IF NOT EXISTS public;

ALTER SCHEMA public OWNER TO postgres;

COMMENT ON SCHEMA public IS 'standard public schema';

-- Types

CREATE TYPE public.estado_entrega AS ENUM (
    'entregado',
    'no entregado'
);

ALTER TYPE public.estado_entrega OWNER TO postgres;

CREATE TYPE public.estado_pago AS ENUM (
    'pendiente',
    'en revision',
    'aprobado'
);

ALTER TYPE public.estado_pago OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

-- Tablas

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    representante character varying(100),
    numero character varying(20) NOT NULL,
    correo character varying(100) NOT NULL,
    direccion text NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    distribuidor_id integer
);

ALTER TABLE public.clientes OWNER TO postgres;

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;

CREATE TABLE public.distribuidores (
    id integer NOT NULL,
    usuario_id integer,
    empresa character varying(100) NOT NULL,
    telefono character varying(20),
    direccion text,
    zona_cobertura character varying(100),
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado boolean DEFAULT true NOT NULL
);

ALTER TABLE public.distribuidores OWNER TO postgres;

CREATE SEQUENCE public.distribuidores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.distribuidores_id_seq OWNER TO postgres;

ALTER SEQUENCE public.distribuidores_id_seq OWNED BY public.distribuidores.id;

CREATE TABLE public.formulaciones (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    total_producir integer NOT NULL,
    precio_total numeric(10,2) NOT NULL
);

ALTER TABLE public.formulaciones OWNER TO postgres;

CREATE TABLE public.gestion_formulaciones (
    id integer NOT NULL,
    formulacion_id integer NOT NULL,
    materia_prima_id integer NOT NULL,
    cantidad integer NOT NULL
);

ALTER TABLE public.gestion_formulaciones OWNER TO postgres;

CREATE SEQUENCE public.formulaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.formulaciones_id_seq OWNER TO postgres;

ALTER SEQUENCE public.formulaciones_id_seq OWNED BY public.gestion_formulaciones.id;

CREATE SEQUENCE public.formulaciones_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.formulaciones_id_seq1 OWNER TO postgres;

ALTER SEQUENCE public.formulaciones_id_seq1 OWNED BY public.formulaciones.id;

-- El resto de las tablas y datos siguen igual que en el script original

-- ...resto del script sin cambios...
EOL

# Extrae todas las tablas excepto las líneas que crean la base de datos o cambian el propietario
cat "c:\Users\ronal\Documents\GitHub\ElBuenSabor\server\config\elbuensaborSCRIPT.sql" | sed '/CREATE DATABASE/d' | sed '/ALTER DATABASE/d' | sed '/\\connect/d' > elbuensabor_railway.sql

echo "Script modificado y guardado como elbuensabor_railway.sql"