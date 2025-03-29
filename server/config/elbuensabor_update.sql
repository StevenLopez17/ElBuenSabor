--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-03-28 21:33:32

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

--
-- TOC entry 5 (class 2615 OID 26069)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 879 (class 1247 OID 26071)
-- Name: estado_entrega; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_entrega AS ENUM (
    'entregado',
    'no entregado'
);


ALTER TYPE public.estado_entrega OWNER TO postgres;

--
-- TOC entry 882 (class 1247 OID 26076)
-- Name: estado_pago; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pago AS ENUM (
    'pendiente',
    'en revision',
    'aprobado'
);


ALTER TYPE public.estado_pago OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 26083)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 218 (class 1259 OID 26089)
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 218
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- TOC entry 219 (class 1259 OID 26090)
-- Name: distribuidores; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 220 (class 1259 OID 26097)
-- Name: distribuidores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.distribuidores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distribuidores_id_seq OWNER TO postgres;

--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.distribuidores_id_seq OWNED BY public.distribuidores.id;


--
-- TOC entry 221 (class 1259 OID 26098)
-- Name: formulaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formulaciones (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    total_producir integer NOT NULL,
    precio_total numeric(10,2) NOT NULL
);


ALTER TABLE public.formulaciones OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 26101)
-- Name: gestion_formulaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gestion_formulaciones (
    id integer NOT NULL,
    formulacion_id integer NOT NULL,
    materia_prima_id integer NOT NULL,
    cantidad integer NOT NULL
);


ALTER TABLE public.gestion_formulaciones OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 26104)
-- Name: formulaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formulaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.formulaciones_id_seq OWNER TO postgres;

--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 223
-- Name: formulaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formulaciones_id_seq OWNED BY public.gestion_formulaciones.id;


--
-- TOC entry 224 (class 1259 OID 26105)
-- Name: formulaciones_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formulaciones_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.formulaciones_id_seq1 OWNER TO postgres;

--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formulaciones_id_seq1 OWNED BY public.formulaciones.id;


--
-- TOC entry 225 (class 1259 OID 26106)
-- Name: gestion_colaboradores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gestion_colaboradores (
    id integer NOT NULL,
    usuario_id integer,
    cargo character varying(100) NOT NULL,
    fecha_ingreso date NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    horario_id integer
);


ALTER TABLE public.gestion_colaboradores OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 26110)
-- Name: gestion_error; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gestion_error (
    id bigint NOT NULL,
    usuario_id bigint,
    "fechaHora" timestamp with time zone NOT NULL,
    mensaje text NOT NULL,
    origen character varying(100) NOT NULL
);


ALTER TABLE public.gestion_error OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 26115)
-- Name: gestion_error_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.gestion_error ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.gestion_error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 26116)
-- Name: horarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horarios (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.horarios OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 26121)
-- Name: horarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.horarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.horarios_id_seq OWNER TO postgres;

--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 229
-- Name: horarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.horarios_id_seq OWNED BY public.horarios.id;


--
-- TOC entry 230 (class 1259 OID 26122)
-- Name: materias_primas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materias_primas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    precio numeric(10,2) NOT NULL,
    stock integer NOT NULL
);


ALTER TABLE public.materias_primas OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 26125)
-- Name: materias_primas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.materias_primas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materias_primas_id_seq OWNER TO postgres;

--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 231
-- Name: materias_primas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materias_primas_id_seq OWNED BY public.materias_primas.id;


--
-- TOC entry 232 (class 1259 OID 26126)
-- Name: notificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notificaciones (
    id integer NOT NULL,
    usuario_id integer,
    mensaje text NOT NULL,
    tipo character varying(50),
    leido boolean DEFAULT false,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT notificaciones_tipo_check CHECK (((tipo)::text = ANY (ARRAY[('Pedido'::character varying)::text, ('Pago'::character varying)::text, ('Inventario'::character varying)::text, ('Planilla'::character varying)::text])))
);


ALTER TABLE public.notificaciones OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 26134)
-- Name: notificaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notificaciones_id_seq OWNER TO postgres;

--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 233
-- Name: notificaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notificaciones_id_seq OWNED BY public.notificaciones.id;


--
-- TOC entry 234 (class 1259 OID 26135)
-- Name: pagos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pagos (
    id integer NOT NULL,
    proveedor character varying(100) NOT NULL,
    monto numeric(10,2) NOT NULL,
    fecha_pago timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    descripcion text,
    estado character varying(50),
    comprobante character varying(255),
    CONSTRAINT pagos_estado_check CHECK (((estado)::text = ANY (ARRAY[('Pendiente'::character varying)::text, ('Completado'::character varying)::text, ('Cancelado'::character varying)::text])))
);


ALTER TABLE public.pagos OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 26142)
-- Name: pagos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pagos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pagos_id_seq OWNER TO postgres;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 235
-- Name: pagos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pagos_id_seq OWNED BY public.pagos.id;


--
-- TOC entry 236 (class 1259 OID 26143)
-- Name: pedido_detalles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_detalles (
    id integer NOT NULL,
    pedidoid integer NOT NULL,
    productoid integer NOT NULL,
    cantidad integer NOT NULL,
    preciounitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.pedido_detalles OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 26148)
-- Name: pedido_detalles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_detalles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_detalles_id_seq OWNER TO postgres;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 237
-- Name: pedido_detalles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_detalles_id_seq OWNED BY public.pedido_detalles.id;


--
-- TOC entry 238 (class 1259 OID 26149)
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    idpedido integer NOT NULL,
    fecha date NOT NULL,
    distribuidorid integer NOT NULL,
    preciototal numeric(10,2) DEFAULT 0 NOT NULL,
    estadodepago public.estado_pago DEFAULT 'pendiente'::public.estado_pago NOT NULL,
    estadodeentrega public.estado_entrega DEFAULT 'no entregado'::public.estado_entrega NOT NULL,
    comprobantedepago character varying(255),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 26157)
-- Name: pedidos_idpedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_idpedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_idpedido_seq OWNER TO postgres;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 239
-- Name: pedidos_idpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_idpedido_seq OWNED BY public.pedidos.idpedido;


--
-- TOC entry 240 (class 1259 OID 26158)
-- Name: planilla_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.planilla_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.planilla_id_seq OWNER TO postgres;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 240
-- Name: planilla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planilla_id_seq OWNED BY public.gestion_colaboradores.id;


--
-- TOC entry 241 (class 1259 OID 26159)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    precio numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    formulaciones_id integer NOT NULL
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 26163)
-- Name: productos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_id_seq OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 242
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- TOC entry 243 (class 1259 OID 26164)
-- Name: reportes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reportes (
    id integer NOT NULL,
    usuario_id integer,
    modulo character varying(100),
    accion text,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.reportes OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 26170)
-- Name: reportes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reportes_id_seq OWNER TO postgres;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 244
-- Name: reportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reportes_id_seq OWNED BY public.reportes.id;


--
-- TOC entry 245 (class 1259 OID 26171)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 26174)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 246
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 247 (class 1259 OID 26175)
-- Name: solicitudes_vacaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solicitudes_vacaciones (
    id integer NOT NULL,
    usuario_id integer,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    estado character varying(50),
    fecha_solicitud timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT solicitudes_vacaciones_estado_check CHECK (((estado)::text = ANY (ARRAY[('Aprobada'::character varying)::text, ('Rechazada'::character varying)::text, ('Pendiente'::character varying)::text])))
);


ALTER TABLE public.solicitudes_vacaciones OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 26180)
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.solicitudes_vacaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solicitudes_vacaciones_id_seq OWNER TO postgres;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 248
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.solicitudes_vacaciones_id_seq OWNED BY public.solicitudes_vacaciones.id;


--
-- TOC entry 249 (class 1259 OID 26181)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    correo character varying(100) NOT NULL,
    contrasena character varying(255) NOT NULL,
    rol_id integer NOT NULL,
    estado boolean DEFAULT true,
    fecha_creacion timestamp with time zone,
    token character varying(255)
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 26187)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 250
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4781 (class 2604 OID 26188)
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- TOC entry 4783 (class 2604 OID 26189)
-- Name: distribuidores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores ALTER COLUMN id SET DEFAULT nextval('public.distribuidores_id_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 26190)
-- Name: formulaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq1'::regclass);


--
-- TOC entry 4788 (class 2604 OID 26191)
-- Name: gestion_colaboradores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores ALTER COLUMN id SET DEFAULT nextval('public.planilla_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 26192)
-- Name: gestion_formulaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 26193)
-- Name: horarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios ALTER COLUMN id SET DEFAULT nextval('public.horarios_id_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 26194)
-- Name: materias_primas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materias_primas ALTER COLUMN id SET DEFAULT nextval('public.materias_primas_id_seq'::regclass);


--
-- TOC entry 4792 (class 2604 OID 26195)
-- Name: notificaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones ALTER COLUMN id SET DEFAULT nextval('public.notificaciones_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 26196)
-- Name: pagos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos ALTER COLUMN id SET DEFAULT nextval('public.pagos_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 26197)
-- Name: pedido_detalles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles ALTER COLUMN id SET DEFAULT nextval('public.pedido_detalles_id_seq'::regclass);


--
-- TOC entry 4800 (class 2604 OID 26198)
-- Name: pedidos idpedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN idpedido SET DEFAULT nextval('public.pedidos_idpedido_seq'::regclass);


--
-- TOC entry 4806 (class 2604 OID 26199)
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- TOC entry 4808 (class 2604 OID 26200)
-- Name: reportes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes ALTER COLUMN id SET DEFAULT nextval('public.reportes_id_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 26201)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4811 (class 2604 OID 26202)
-- Name: solicitudes_vacaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones ALTER COLUMN id SET DEFAULT nextval('public.solicitudes_vacaciones_id_seq'::regclass);


--
-- TOC entry 4813 (class 2604 OID 26203)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5056 (class 0 OID 26083)
-- Dependencies: 217
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (8, 'Felipe Chacon', 'Mariana Castro', '61062710', 'carlos@gmail.com', 'San Rafael', true, 4);
INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (12, 'Felipe Chacon', 'Carlos', '61062777', 'mari.ulatec@gmail.com', 'Calle Blancos', true, 4);
INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (7, 'Vladimir', 'Carlos Castro', '61062711', 'vconejo90786@gmail.com', 'San Rafael', true, 4);


--
-- TOC entry 5058 (class 0 OID 26090)
-- Dependencies: 219
-- Data for Name: distribuidores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.distribuidores (id, usuario_id, empresa, telefono, direccion, zona_cobertura, fecha_registro, estado) VALUES (4, 1, 'CarnesCastro', '81062720', 'San Rafael', 'Heredia', '2025-02-27 02:57:01.351', true);
INSERT INTO public.distribuidores (id, usuario_id, empresa, telefono, direccion, zona_cobertura, fecha_registro, estado) VALUES (5, 1, 'ArregladosHerrera', '41064532', 'Santo Domingo', 'Heredia', '2025-03-29 03:17:10.208', true);


--
-- TOC entry 5060 (class 0 OID 26098)
-- Dependencies: 221
-- Data for Name: formulaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.formulaciones (id, nombre, total_producir, precio_total) VALUES (1, 'Aarreglado de Pollo', 4, 4000.00);
INSERT INTO public.formulaciones (id, nombre, total_producir, precio_total) VALUES (2, 'Formula de Arreglado de Carne', 50, 0.00);
INSERT INTO public.formulaciones (id, nombre, total_producir, precio_total) VALUES (3, 'Formula de Arreglado de Pollo', 45, 4000.00);


--
-- TOC entry 5064 (class 0 OID 26106)
-- Dependencies: 225
-- Data for Name: gestion_colaboradores; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5065 (class 0 OID 26110)
-- Dependencies: 226
-- Data for Name: gestion_error; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5061 (class 0 OID 26101)
-- Dependencies: 222
-- Data for Name: gestion_formulaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (1, 1, 1, 2);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (2, 1, 2, 2);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (3, 2, 1, 3);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (4, 2, 2, 1);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (5, 3, 1, 3);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (6, 3, 2, 1);


--
-- TOC entry 5067 (class 0 OID 26116)
-- Dependencies: 228
-- Data for Name: horarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.horarios (id, descripcion) VALUES (1, 'Lunes-Viernes 9am-6pm');
INSERT INTO public.horarios (id, descripcion) VALUES (2, 'Lunes-Viernes 7am-4pm');


--
-- TOC entry 5069 (class 0 OID 26122)
-- Dependencies: 230
-- Data for Name: materias_primas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (3, 'Sal', 2000.00, 10);
INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (4, 'Bolsa', 2000.00, 10);
INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (1, 'Salsa de Tomate', 1000.00, 2);
INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (2, 'Salsa de Soya', 1000.00, 2);


--
-- TOC entry 5071 (class 0 OID 26126)
-- Dependencies: 232
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5073 (class 0 OID 26135)
-- Dependencies: 234
-- Data for Name: pagos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5075 (class 0 OID 26143)
-- Dependencies: 236
-- Data for Name: pedido_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (1, 1, 9, 2, 4000.00, 8000.00, '2025-03-21 20:38:44.717-06', '2025-03-21 20:38:44.717-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (2, 1, 10, 1, 4000.00, 4000.00, '2025-03-21 20:38:44.723-06', '2025-03-21 20:38:44.723-06');


--
-- TOC entry 5077 (class 0 OID 26149)
-- Dependencies: 238
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pedidos (idpedido, fecha, distribuidorid, preciototal, estadodepago, estadodeentrega, comprobantedepago, created_at, updated_at) VALUES (1, '2025-03-22', 4, 12000.00, 'pendiente', 'no entregado', NULL, '2025-03-21 20:38:44.668-06', '2025-03-21 20:38:44.668-06');


--
-- TOC entry 5080 (class 0 OID 26159)
-- Dependencies: 241
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (10, 'Arreglado de Pollo Picante', 4000.00, 5, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (11, 'Arreglado de Pollo Casero', 5000.00, 4, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (12, 'Arreglado de Pollo comun', 3000.00, 1, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (13, 'Arreglado de Pollo comun', 3000.00, 1, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (14, 'Arreglado de Pollo normal', 3000.00, 1, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (9, 'Arreglado de Pollo', 4000.00, 10, 1);


--
-- TOC entry 5082 (class 0 OID 26164)
-- Dependencies: 243
-- Data for Name: reportes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5084 (class 0 OID 26171)
-- Dependencies: 245
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (id, nombre) VALUES (1, 'Administrador');
INSERT INTO public.roles (id, nombre) VALUES (2, 'Gerente de planta');
INSERT INTO public.roles (id, nombre) VALUES (3, 'Distribuidor');
INSERT INTO public.roles (id, nombre) VALUES (4, 'Colaborador de Planta');
INSERT INTO public.roles (id, nombre) VALUES (5, 'Usuario');


--
-- TOC entry 5086 (class 0 OID 26175)
-- Dependencies: 247
-- Data for Name: solicitudes_vacaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5088 (class 0 OID 26181)
-- Dependencies: 249
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token) VALUES (1, 'Vladimir Conejo Oviedo', 'vconejo90786@gmail.com', '$2b$10$r9epmmGtCal9HeraBCXXOep4TImVsOu8mrYxMOTMykuHjfzJPuBka', 1, true, '2025-03-11 18:40:41.413-06', 'iunulblgk11im3snp65');


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 218
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 12, true);


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.distribuidores_id_seq', 5, true);


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 223
-- Name: formulaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formulaciones_id_seq', 6, true);


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formulaciones_id_seq1', 3, true);


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 227
-- Name: gestion_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gestion_error_id_seq', 22, true);


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 229
-- Name: horarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.horarios_id_seq', 2, true);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 231
-- Name: materias_primas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materias_primas_id_seq', 4, true);


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 233
-- Name: notificaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificaciones_id_seq', 1, false);


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 235
-- Name: pagos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pagos_id_seq', 1, false);


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 237
-- Name: pedido_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_detalles_id_seq', 2, true);


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 239
-- Name: pedidos_idpedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_idpedido_seq', 1, true);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 240
-- Name: planilla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planilla_id_seq', 1, false);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 242
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_seq', 14, true);


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 244
-- Name: reportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reportes_id_seq', 1, false);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 246
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 5, true);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 248
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitudes_vacaciones_id_seq', 1, false);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 250
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 2, true);


--
-- TOC entry 4819 (class 2606 OID 26205)
-- Name: clientes clientes_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_correo_key UNIQUE (correo);


--
-- TOC entry 4821 (class 2606 OID 26207)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 26209)
-- Name: distribuidores distribuidores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_pkey PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 26211)
-- Name: gestion_formulaciones formulaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT formulaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 26213)
-- Name: formulaciones formulaciones_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones
    ADD CONSTRAINT formulaciones_pkey1 PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 26215)
-- Name: gestion_error gestion_error_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_error
    ADD CONSTRAINT gestion_error_pkey PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 26217)
-- Name: horarios horarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios
    ADD CONSTRAINT horarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 26219)
-- Name: materias_primas materias_primas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materias_primas
    ADD CONSTRAINT materias_primas_pkey PRIMARY KEY (id);


--
-- TOC entry 4839 (class 2606 OID 26221)
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 26223)
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 26225)
-- Name: pedido_detalles pedido_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles
    ADD CONSTRAINT pedido_detalles_pkey PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 26227)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (idpedido);


--
-- TOC entry 4831 (class 2606 OID 26229)
-- Name: gestion_colaboradores planilla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_pkey PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 26231)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- TOC entry 4850 (class 2606 OID 26233)
-- Name: reportes reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);


--
-- TOC entry 4852 (class 2606 OID 26235)
-- Name: roles roles_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key UNIQUE (nombre);


--
-- TOC entry 4854 (class 2606 OID 26237)
-- Name: roles roles_nombre_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key1 UNIQUE (nombre);


--
-- TOC entry 4856 (class 2606 OID 26239)
-- Name: roles roles_nombre_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key2 UNIQUE (nombre);


--
-- TOC entry 4858 (class 2606 OID 26241)
-- Name: roles roles_nombre_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key3 UNIQUE (nombre);


--
-- TOC entry 4860 (class 2606 OID 26243)
-- Name: roles roles_nombre_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key4 UNIQUE (nombre);


--
-- TOC entry 4862 (class 2606 OID 26245)
-- Name: roles roles_nombre_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key5 UNIQUE (nombre);


--
-- TOC entry 4864 (class 2606 OID 26247)
-- Name: roles roles_nombre_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key6 UNIQUE (nombre);


--
-- TOC entry 4866 (class 2606 OID 26249)
-- Name: roles roles_nombre_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key7 UNIQUE (nombre);


--
-- TOC entry 4868 (class 2606 OID 26251)
-- Name: roles roles_nombre_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key8 UNIQUE (nombre);


--
-- TOC entry 4870 (class 2606 OID 26253)
-- Name: roles roles_nombre_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key9 UNIQUE (nombre);


--
-- TOC entry 4872 (class 2606 OID 26255)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4874 (class 2606 OID 26257)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 26259)
-- Name: clientes unique_numero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT unique_numero UNIQUE (numero);


--
-- TOC entry 4876 (class 2606 OID 26261)
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- TOC entry 4878 (class 2606 OID 26263)
-- Name: usuarios usuarios_correo_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key1 UNIQUE (correo);


--
-- TOC entry 4880 (class 2606 OID 26265)
-- Name: usuarios usuarios_correo_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key2 UNIQUE (correo);


--
-- TOC entry 4882 (class 2606 OID 26267)
-- Name: usuarios usuarios_correo_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key3 UNIQUE (correo);


--
-- TOC entry 4884 (class 2606 OID 26269)
-- Name: usuarios usuarios_correo_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key4 UNIQUE (correo);


--
-- TOC entry 4886 (class 2606 OID 26271)
-- Name: usuarios usuarios_correo_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key5 UNIQUE (correo);


--
-- TOC entry 4888 (class 2606 OID 26273)
-- Name: usuarios usuarios_correo_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key6 UNIQUE (correo);


--
-- TOC entry 4890 (class 2606 OID 26275)
-- Name: usuarios usuarios_correo_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key7 UNIQUE (correo);


--
-- TOC entry 4892 (class 2606 OID 26277)
-- Name: usuarios usuarios_correo_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key8 UNIQUE (correo);


--
-- TOC entry 4894 (class 2606 OID 26279)
-- Name: usuarios usuarios_correo_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key9 UNIQUE (correo);


--
-- TOC entry 4896 (class 2606 OID 26281)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4840 (class 1259 OID 26282)
-- Name: idx_pagos_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pagos_proveedor ON public.pagos USING btree (proveedor);


--
-- TOC entry 4897 (class 2606 OID 26283)
-- Name: clientes clientes_distribuidor_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_distribuidor_id_FK" FOREIGN KEY (distribuidor_id) REFERENCES public.distribuidores(id) NOT VALID;


--
-- TOC entry 4898 (class 2606 OID 26288)
-- Name: distribuidores distribuidores_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4906 (class 2606 OID 26293)
-- Name: pedidos fk_distribuidor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_distribuidor FOREIGN KEY (distribuidorid) REFERENCES public.distribuidores(id) ON DELETE CASCADE;


--
-- TOC entry 4901 (class 2606 OID 26298)
-- Name: gestion_colaboradores fk_horario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT fk_horario FOREIGN KEY (horario_id) REFERENCES public.horarios(id);


--
-- TOC entry 4904 (class 2606 OID 26303)
-- Name: pedido_detalles fk_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles
    ADD CONSTRAINT fk_pedido FOREIGN KEY (pedidoid) REFERENCES public.pedidos(idpedido) ON DELETE CASCADE;


--
-- TOC entry 4905 (class 2606 OID 26308)
-- Name: pedido_detalles fk_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles
    ADD CONSTRAINT fk_producto FOREIGN KEY (productoid) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4899 (class 2606 OID 26313)
-- Name: gestion_formulaciones gestion_formulacion_formulaciones_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT "gestion_formulacion_formulaciones_id_FK" FOREIGN KEY (formulacion_id) REFERENCES public.formulaciones(id) NOT VALID;


--
-- TOC entry 4900 (class 2606 OID 26318)
-- Name: gestion_formulaciones gestion_formulacion_materias_primas_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT "gestion_formulacion_materias_primas_id_FK" FOREIGN KEY (materia_prima_id) REFERENCES public.materias_primas(id) NOT VALID;


--
-- TOC entry 4903 (class 2606 OID 26323)
-- Name: notificaciones notificaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4902 (class 2606 OID 26328)
-- Name: gestion_colaboradores planilla_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4907 (class 2606 OID 26333)
-- Name: productos productos_formulacion_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "productos_formulacion_id_FK" FOREIGN KEY (formulaciones_id) REFERENCES public.formulaciones(id) NOT VALID;


--
-- TOC entry 4908 (class 2606 OID 26338)
-- Name: reportes reportes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4909 (class 2606 OID 26343)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4910 (class 2606 OID 26348)
-- Name: usuarios usuarios_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-03-28 21:33:32

--
-- PostgreSQL database dump complete
--

