-- Active: 1745298161564@@turntable.proxy.rlwy.net@54950@railway
--
-- PostgreSQL database dump (modificado para Railway)
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Schema
CREATE SCHEMA IF NOT EXISTS public;

-- Types
CREATE TYPE public.estado_entrega AS ENUM (
    'entregado',
    'no entregado'
);

CREATE TYPE public.estado_pago AS ENUM (
    'pendiente',
    'en revision',
    'aprobado'
);

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

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

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

CREATE SEQUENCE public.distribuidores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.distribuidores_id_seq OWNED BY public.distribuidores.id;

CREATE TABLE public.formulaciones (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    total_producir integer NOT NULL,
    precio_total numeric(10,2) NOT NULL
);

CREATE TABLE public.gestion_formulaciones (
    id integer NOT NULL,
    formulacion_id integer NOT NULL,
    materia_prima_id integer NOT NULL,
    cantidad integer NOT NULL
);

CREATE SEQUENCE public.formulaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.formulaciones_id_seq OWNED BY public.gestion_formulaciones.id;

CREATE SEQUENCE public.formulaciones_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.formulaciones_id_seq1 OWNED BY public.formulaciones.id;

-- Las tablas adicionales que faltan

-- Tabla roles
CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;

-- Tabla usuarios
CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    correo character varying(100) NOT NULL,
    contraseña character varying(255) NOT NULL,
    telefono character varying(20),
    direccion text,
    rol_id integer,
    token text,
    token_expiracion timestamp without time zone,
    estado boolean DEFAULT true NOT NULL
);



ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;

-- Tabla materia_prima
CREATE TABLE public.materia_prima (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    precio numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    unidad_medida character varying(20) NOT NULL,
    stock_minimo integer NOT NULL,
    proveedor_id integer,
    fecha_ingreso timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento timestamp without time zone,
    estado boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE public.materia_prima_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.materia_prima_id_seq OWNED BY public.materia_prima.id;

-- Secuencia para usuarios
CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Tabla pedidos
CREATE TABLE public.pedidos (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    distribuidor_id integer,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado_entrega public.estado_entrega DEFAULT 'no entregado'::public.estado_entrega NOT NULL,
    estado_pago public.estado_pago DEFAULT 'pendiente'::public.estado_pago NOT NULL,
    total numeric(10,2) NOT NULL,
    comentario text,
    fecha_entrega timestamp without time zone
);

CREATE SEQUENCE public.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;

-- Tabla detalle_pedido
CREATE TABLE public.detalle_pedido (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL
);

CREATE SEQUENCE public.detalle_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.detalle_pedido_id_seq OWNED BY public.detalle_pedido.id;

-- Tabla productos
CREATE TABLE public.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    precio numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    categoria character varying(50),
    imagen_url text,
    formulacion_id integer,
    estado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE public.productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;

-- Tabla proveedores
CREATE TABLE public.proveedores (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    contacto character varying(100),
    telefono character varying(20) NOT NULL,
    correo character varying(100) NOT NULL,
    direccion text,
    estado boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE public.proveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.proveedores_id_seq OWNED BY public.proveedores.id;

-- Tabla horarios
CREATE TABLE public.horarios (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    dia_semana character varying(20) NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fin time without time zone NOT NULL,
    estado boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE public.horarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.horarios_id_seq OWNED BY public.horarios.id;

-- Tabla colaboradores
CREATE TABLE public.colaboradores (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    puesto character varying(100) NOT NULL,
    fecha_ingreso date NOT NULL,
    estado boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE public.colaboradores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.colaboradores_id_seq OWNED BY public.colaboradores.id;

-- Tabla vacaciones
CREATE TABLE public.vacaciones (
    id integer NOT NULL,
    colaborador_id integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    estado character varying(20) DEFAULT 'pendiente'::character varying NOT NULL,
    comentario text,
    fecha_solicitud timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE public.vacaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.vacaciones_id_seq OWNED BY public.vacaciones.id;

-- Tabla pagos
CREATE TABLE public.pagos (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    monto numeric(10,2) NOT NULL,
    metodo_pago character varying(50) NOT NULL,
    fecha_pago timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    referencia character varying(100),
    estado character varying(20) DEFAULT 'pendiente'::character varying NOT NULL
);

CREATE SEQUENCE public.pagos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.pagos_id_seq OWNED BY public.pagos.id;

-- Configurar las llaves primarias
ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);
ALTER TABLE ONLY public.distribuidores ALTER COLUMN id SET DEFAULT nextval('public.distribuidores_id_seq'::regclass);
ALTER TABLE ONLY public.formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq1'::regclass);
ALTER TABLE ONLY public.gestion_formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq'::regclass);
ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);
ALTER TABLE ONLY public.materia_prima ALTER COLUMN id SET DEFAULT nextval('public.materia_prima_id_seq'::regclass);
ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);
ALTER TABLE ONLY public.detalle_pedido ALTER COLUMN id SET DEFAULT nextval('public.detalle_pedido_id_seq'::regclass);
ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);
ALTER TABLE ONLY public.proveedores ALTER COLUMN id SET DEFAULT nextval('public.proveedores_id_seq'::regclass);
ALTER TABLE ONLY public.horarios ALTER COLUMN id SET DEFAULT nextval('public.horarios_id_seq'::regclass);
ALTER TABLE ONLY public.colaboradores ALTER COLUMN id SET DEFAULT nextval('public.colaboradores_id_seq'::regclass);
ALTER TABLE ONLY public.vacaciones ALTER COLUMN id SET DEFAULT nextval('public.vacaciones_id_seq'::regclass);
ALTER TABLE ONLY public.pagos ALTER COLUMN id SET DEFAULT nextval('public.pagos_id_seq'::regclass);

-- Definir llaves primarias
ALTER TABLE ONLY public.clientes ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.distribuidores ADD CONSTRAINT distribuidores_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.formulaciones ADD CONSTRAINT formulaciones_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.gestion_formulaciones ADD CONSTRAINT gestion_formulaciones_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.roles ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.usuarios ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.materia_prima ADD CONSTRAINT materia_prima_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pedidos ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.detalle_pedido ADD CONSTRAINT detalle_pedido_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.productos ADD CONSTRAINT productos_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.proveedores ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.horarios ADD CONSTRAINT horarios_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.colaboradores ADD CONSTRAINT colaboradores_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.vacaciones ADD CONSTRAINT vacaciones_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pagos ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);

-- Definir llaves foráneas
ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_distribuidor_id_fkey FOREIGN KEY (distribuidor_id) REFERENCES public.distribuidores(id);
    
ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);
    
ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT gestion_formulaciones_formulacion_id_fkey FOREIGN KEY (formulacion_id) REFERENCES public.formulaciones(id);
    
ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT gestion_formulaciones_materia_prima_id_fkey FOREIGN KEY (materia_prima_id) REFERENCES public.materia_prima(id);
    
ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id);
    
ALTER TABLE ONLY public.materia_prima
    ADD CONSTRAINT materia_prima_proveedor_id_fkey FOREIGN KEY (proveedor_id) REFERENCES public.proveedores(id);
    
ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);
    
ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_distribuidor_id_fkey FOREIGN KEY (distribuidor_id) REFERENCES public.distribuidores(id);
    
ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id);
    
ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id);
    
ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_formulacion_id_fkey FOREIGN KEY (formulacion_id) REFERENCES public.formulaciones(id);
    
ALTER TABLE ONLY public.horarios
    ADD CONSTRAINT horarios_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);
    
ALTER TABLE ONLY public.colaboradores
    ADD CONSTRAINT colaboradores_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);
    
ALTER TABLE ONLY public.vacaciones
    ADD CONSTRAINT vacaciones_colaborador_id_fkey FOREIGN KEY (colaborador_id) REFERENCES public.colaboradores(id);
    
ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id);

-- Insertando datos básicos
INSERT INTO public.roles (id, nombre) VALUES (1, 'Administrador');
INSERT INTO public.roles (id, nombre) VALUES (2, 'Gerente de planta');
INSERT INTO public.roles (id, nombre) VALUES (3, 'Distribuidor');
INSERT INTO public.roles (id, nombre) VALUES (4, 'Colaborador de Planta');
INSERT INTO public.roles (id, nombre) VALUES (5, 'Usuario');

-- Restablecer secuencias
SELECT pg_catalog.setval('public.roles_id_seq', 5, true);