--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-06-19 22:08:15

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


--
-- TOC entry 5152 (class 1262 OID 51563)
-- Name: el_buen_sabor; Type: DATABASE; Schema: -; Owner: postgres
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

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--




ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 881 (class 1247 OID 51565)
-- Name: estado_entrega; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_entrega AS ENUM (
    'entregado',
    'no entregado'
);


ALTER TYPE public.estado_entrega OWNER TO postgres;

--
-- TOC entry 884 (class 1247 OID 51570)
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
-- TOC entry 217 (class 1259 OID 51577)
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
-- TOC entry 218 (class 1259 OID 51583)
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
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 218
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- TOC entry 219 (class 1259 OID 51584)
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
-- TOC entry 220 (class 1259 OID 51591)
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
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.distribuidores_id_seq OWNED BY public.distribuidores.id;


--
-- TOC entry 221 (class 1259 OID 51592)
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
-- TOC entry 222 (class 1259 OID 51595)
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
-- TOC entry 223 (class 1259 OID 51598)
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
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 223
-- Name: formulaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formulaciones_id_seq OWNED BY public.gestion_formulaciones.id;


--
-- TOC entry 224 (class 1259 OID 51599)
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
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formulaciones_id_seq1 OWNED BY public.formulaciones.id;


--
-- TOC entry 225 (class 1259 OID 51600)
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
-- TOC entry 226 (class 1259 OID 51604)
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
-- TOC entry 227 (class 1259 OID 51609)
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
-- TOC entry 228 (class 1259 OID 51610)
-- Name: horarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horarios (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.horarios OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 51615)
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
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 229
-- Name: horarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.horarios_id_seq OWNED BY public.horarios.id;


--
-- TOC entry 230 (class 1259 OID 51616)
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
-- TOC entry 231 (class 1259 OID 51619)
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
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 231
-- Name: materias_primas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materias_primas_id_seq OWNED BY public.materias_primas.id;


--
-- TOC entry 232 (class 1259 OID 51620)
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
-- TOC entry 233 (class 1259 OID 51628)
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
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 233
-- Name: notificaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notificaciones_id_seq OWNED BY public.notificaciones.id;


--
-- TOC entry 252 (class 1259 OID 51862)
-- Name: pagos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pagos (
    id integer NOT NULL,
    proveedor_id integer NOT NULL,
    fecha_pago date NOT NULL,
    precio numeric(10,2) NOT NULL,
    impuesto numeric(10,2) NOT NULL,
    precio_total numeric(10,2) NOT NULL,
    referencia character varying(255) DEFAULT NULL::character varying,
    notas text
);


ALTER TABLE public.pagos OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 51861)
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
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 251
-- Name: pagos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pagos_id_seq OWNED BY public.pagos.id;


--
-- TOC entry 234 (class 1259 OID 51637)
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
-- TOC entry 235 (class 1259 OID 51642)
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
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 235
-- Name: pedido_detalles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_detalles_id_seq OWNED BY public.pedido_detalles.id;


--
-- TOC entry 236 (class 1259 OID 51643)
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
-- TOC entry 237 (class 1259 OID 51651)
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
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 237
-- Name: pedidos_idpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_idpedido_seq OWNED BY public.pedidos.idpedido;


--
-- TOC entry 238 (class 1259 OID 51652)
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
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 238
-- Name: planilla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planilla_id_seq OWNED BY public.gestion_colaboradores.id;


--
-- TOC entry 239 (class 1259 OID 51653)
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
-- TOC entry 240 (class 1259 OID 51657)
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
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 240
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- TOC entry 250 (class 1259 OID 51849)
-- Name: proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedores (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    contacto character varying(100),
    telefono character varying(50),
    correo character varying(100),
    direccion text,
    estado boolean DEFAULT true NOT NULL
);


ALTER TABLE public.proveedores OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 51848)
-- Name: proveedores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedores_id_seq OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 249
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedores_id_seq OWNED BY public.proveedores.id;


--
-- TOC entry 241 (class 1259 OID 51658)
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
-- TOC entry 242 (class 1259 OID 51664)
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
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 242
-- Name: reportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reportes_id_seq OWNED BY public.reportes.id;


--
-- TOC entry 243 (class 1259 OID 51665)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 51668)
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
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 244
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 245 (class 1259 OID 51669)
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
-- TOC entry 246 (class 1259 OID 51674)
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
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 246
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.solicitudes_vacaciones_id_seq OWNED BY public.solicitudes_vacaciones.id;


--
-- TOC entry 247 (class 1259 OID 51675)
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
    token character varying(255),
    imagen_url text
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 51681)
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
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 248
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4833 (class 2604 OID 51682)
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- TOC entry 4835 (class 2604 OID 51683)
-- Name: distribuidores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores ALTER COLUMN id SET DEFAULT nextval('public.distribuidores_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 51684)
-- Name: formulaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq1'::regclass);


--
-- TOC entry 4840 (class 2604 OID 51685)
-- Name: gestion_colaboradores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores ALTER COLUMN id SET DEFAULT nextval('public.planilla_id_seq'::regclass);


--
-- TOC entry 4839 (class 2604 OID 51686)
-- Name: gestion_formulaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq'::regclass);


--
-- TOC entry 4842 (class 2604 OID 51687)
-- Name: horarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios ALTER COLUMN id SET DEFAULT nextval('public.horarios_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 51688)
-- Name: materias_primas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materias_primas ALTER COLUMN id SET DEFAULT nextval('public.materias_primas_id_seq'::regclass);


--
-- TOC entry 4844 (class 2604 OID 51689)
-- Name: notificaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones ALTER COLUMN id SET DEFAULT nextval('public.notificaciones_id_seq'::regclass);


--
-- TOC entry 4867 (class 2604 OID 51865)
-- Name: pagos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos ALTER COLUMN id SET DEFAULT nextval('public.pagos_id_seq'::regclass);


--
-- TOC entry 4847 (class 2604 OID 51691)
-- Name: pedido_detalles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles ALTER COLUMN id SET DEFAULT nextval('public.pedido_detalles_id_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 51692)
-- Name: pedidos idpedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN idpedido SET DEFAULT nextval('public.pedidos_idpedido_seq'::regclass);


--
-- TOC entry 4856 (class 2604 OID 51693)
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- TOC entry 4865 (class 2604 OID 51852)
-- Name: proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN id SET DEFAULT nextval('public.proveedores_id_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 51694)
-- Name: reportes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes ALTER COLUMN id SET DEFAULT nextval('public.reportes_id_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 51695)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4861 (class 2604 OID 51696)
-- Name: solicitudes_vacaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones ALTER COLUMN id SET DEFAULT nextval('public.solicitudes_vacaciones_id_seq'::regclass);


--
-- TOC entry 4863 (class 2604 OID 51697)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5111 (class 0 OID 51577)
-- Dependencies: 217
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (8, 'Felipe Chacon', 'Mariana Castro', '61062710', 'carlos@gmail.com', 'San Rafael', true, 4);
INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (12, 'Felipe Chacon', 'Carlos', '61062777', 'mari.ulatec@gmail.com', 'Calle Blancos', true, 4);
INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (7, 'Vladimir', 'Carlos Castro', '61062711', 'vconejo90786@gmail.com', 'San Rafael', true, 4);


--
-- TOC entry 5113 (class 0 OID 51584)
-- Dependencies: 219
-- Data for Name: distribuidores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.distribuidores (id, usuario_id, empresa, telefono, direccion, zona_cobertura, fecha_registro, estado) VALUES (4, 1, 'CarnesCastro', '81062720', 'San Rafael', 'Heredia', '2025-02-27 02:57:01.351', true);
INSERT INTO public.distribuidores (id, usuario_id, empresa, telefono, direccion, zona_cobertura, fecha_registro, estado) VALUES (6, 3, 'Edgardo Ruiz', '56879223', 'Los Sitios', 'Zapote', '2025-04-23 00:32:30.663', true);
INSERT INTO public.distribuidores (id, usuario_id, empresa, telefono, direccion, zona_cobertura, fecha_registro, estado) VALUES (5, 1, 'ArregladosHerrera', '41064532', 'Santo Domingo', 'Heredia', '2025-03-29 03:17:10.208', false);


--
-- TOC entry 5115 (class 0 OID 51592)
-- Dependencies: 221
-- Data for Name: formulaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.formulaciones (id, nombre, total_producir, precio_total) VALUES (1, 'Aarreglado de Pollo', 4, 4000.00);
INSERT INTO public.formulaciones (id, nombre, total_producir, precio_total) VALUES (2, 'Formula de Arreglado de Carne', 50, 0.00);
INSERT INTO public.formulaciones (id, nombre, total_producir, precio_total) VALUES (3, 'Formula de Arreglado de Pollo', 45, 4000.00);
INSERT INTO public.formulaciones (id, nombre, total_producir, precio_total) VALUES (4, 'Relleno de Carne ', 50, 180000.00);


--
-- TOC entry 5119 (class 0 OID 51600)
-- Dependencies: 225
-- Data for Name: gestion_colaboradores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.gestion_colaboradores (id, usuario_id, cargo, fecha_ingreso, estado, horario_id) VALUES (1, 6, 'Cocinera', '2025-04-08', true, 2);
INSERT INTO public.gestion_colaboradores (id, usuario_id, cargo, fecha_ingreso, estado, horario_id) VALUES (2, 7, 'Bodega', '2025-04-08', true, 1);


--
-- TOC entry 5120 (class 0 OID 51604)
-- Dependencies: 226
-- Data for Name: gestion_error; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (23, NULL, '2025-04-05 14:47:36.339-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:6
    4|   <h1 class="text-center">Agregar Pago</h1>
    5| 
 >> 6|   <% if (mensaje) { %>
    7|     <div class="alert alert-danger text-center">
    8|       <%= mensaje %>
    9|     </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (24, NULL, '2025-04-05 14:49:01.204-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:5
    3|   <h1 class="text-center">Agregar Pago</h1>
    4| 
 >> 5|   <% if (mensaje) { %>
    6|     <div class="alert alert-danger text-center">
    7|       <%= mensaje %>
    8|     </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (25, NULL, '2025-04-05 14:49:03.535-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:5
    3|   <h1 class="text-center">Agregar Pago</h1>
    4| 
 >> 5|   <% if (mensaje) { %>
    6|     <div class="alert alert-danger text-center">
    7|       <%= mensaje %>
    8|     </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (26, NULL, '2025-04-05 14:49:55.94-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:5
    3|   <h1 class="text-center">Agregar Pago</h1>
    4| 
 >> 5|   <% if (mensaje) { %>
    6|     <div class="alert alert-danger text-center">
    7|       <%= mensaje %>
    8|     </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (27, NULL, '2025-04-05 14:53:04.392-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:5
    3|   <h1 class="text-center">Agregar Pago</h1>
    4| 
 >> 5|   <% if (mensaje) { %>
    6|     <div class="alert alert-danger text-center">
    7|       <%= mensaje %>
    8|     </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (28, NULL, '2025-04-05 14:55:49.707-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:11
    9|             <div class="col-lg-12 col-12">
    10|                 <div class="custom-block bg-white p-4">
 >> 11|                     <% if (mensaje) { %>
    12|                         <div class="alert alert-danger text-center">
    13|                             <%= mensaje %>
    14|                         </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (29, NULL, '2025-04-05 14:56:43.415-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:11
    9|             <div class="col-lg-12 col-12">
    10|                 <div class="custom-block bg-white p-4">
 >> 11|                     <% if (mensaje) { %>
    12|                         <div class="alert alert-danger text-center">
    13|                             <%= mensaje %>
    14|                         </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (30, NULL, '2025-04-05 15:03:04.063-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosAgregar.ejs:11
    9|             <div class="col-lg-12 col-12">
    10|                 <div class="custom-block bg-white p-4">
 >> 11|                     <% if (mensaje) { %>
    12|                         <div class="alert alert-danger text-center">
    13|                             <%= mensaje %>
    14|                         </div>

mensaje is not defined', '/pagos/agregar');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (31, NULL, '2025-04-05 15:08:17.771-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagos.ejs:37
    35|             <td><%= pago.proveedor.nombre %></td>
    36|             <td><%= pago.fecha_pago %></td>
 >> 37|             <td>$<%= pago.precio.toFixed(2) %></td>
    38|             <td>$<%= pago.impuesto.toFixed(2) %></td>
    39|             <td>$<%= pago.precio_total.toFixed(2) %></td>
    40|             <td><%= pago.referencia || ''N/A'' %></td>

pago.precio.toFixed is not a function', '/pagos');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (32, NULL, '2025-04-05 15:24:27.076-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pagos\pagosEditar.ejs:11
    9|             <div class="col-lg-12 col-12">
    10|                 <div class="custom-block bg-white p-4">
 >> 11|                     <% if (mensaje) { %>
    12|                         <div class="alert alert-danger text-center">
    13|                             <%= mensaje %>
    14|                         </div>

mensaje is not defined', '/pagos/editar/1');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (33, 3, '2025-04-14 14:25:47.585-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pedidos\pedidoEditar.ejs:60
    58|                                         <td><%= detalle.producto?.nombre || ''Producto no disponible'' %></td>
    59|                                         <td><%= detalle.cantidad %> kg</td>
 >> 60|                                         <td>₡<%= detalle.precioUnitario?.toFixed(2) %></td>
    61|                                         <td>₡<%= detalle.subtotal?.toFixed(2) %></td>
    62|                                     </tr>
    63|                                 <% }); %>

detalle.precioUnitario?.toFixed is not a function', '/pedido/editar/1');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (34, 3, '2025-04-14 15:43:17.52-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/pedido');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (35, 3, '2025-04-14 15:43:22.077-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/pedido');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (36, 3, '2025-04-14 15:43:24.775-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/cliente');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (37, 3, '2025-04-14 15:43:27.32-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/producto');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (38, 3, '2025-04-14 15:43:30.972-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/distribuidor');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (39, 3, '2025-04-14 15:43:49.309-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/materiaPrima');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (40, 3, '2025-04-14 15:43:50.883-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/reportes');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (41, 3, '2025-04-14 15:43:52.668-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\layouts\layout.ejs:33
    31|   
    32|         <!-- Sidebar (navbar lateral) -->
 >> 33|         <%- include(''../partials/navbar'') %>
    34|   
    35|         <!-- Contenido principal -->
    36|         <main class="main-wrapper col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4 ">

C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\partials\navbar.ejs:113
    111|         <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
    112|           aria-expanded="false">
 >> 113|           <img src="<%= usuario && usuario.imagen_url ? usuario.imagen_url : ''/images/medium-shot-happy-man-smiling.jpg'' %>" class="profile-image img-fluid" alt="">
    114|         </a>
    115|         <ul class="dropdown-menu bg-white shadow">
    116|           <li>

usuario is not defined', '/pedido');
INSERT INTO public.gestion_error (id, usuario_id, "fechaHora", mensaje, origen) VALUES (42, 3, '2025-04-15 17:50:49.639-06', 'C:\Users\ronal\Documents\GitHub\ElBuenSabor\views\pedidos\pedidostodos.ejs:4
    2|     <div class="container">
    3|         <div class="d-flex justify-content-between align-items-center mb-3">
 >> 4|             <h3 class="mb-0">Pedidos del mes de <%= mes %></h3>
    5|             <div class="d-flex justify-content-end mb-3">
    6|                 <a href="/pedidos/historial" class="btn btn-info me-2">Ver historial completo</a>
    7|                 <a href="/pedido/agregar" class="btn btn-primary me-2">Agregar Pedido</a>

mes is not defined', '/pedidos/todos');


--
-- TOC entry 5116 (class 0 OID 51595)
-- Dependencies: 222
-- Data for Name: gestion_formulaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (1, 1, 1, 2);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (2, 1, 2, 2);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (3, 2, 1, 3);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (4, 2, 2, 1);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (5, 3, 1, 3);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (6, 3, 2, 1);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (7, 4, 3, 10);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (8, 4, 4, 50);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (9, 4, 1, 5);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (10, 4, 2, 5);
INSERT INTO public.gestion_formulaciones (id, formulacion_id, materia_prima_id, cantidad) VALUES (11, 4, 5, 5);


--
-- TOC entry 5122 (class 0 OID 51610)
-- Dependencies: 228
-- Data for Name: horarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.horarios (id, descripcion) VALUES (1, 'Lunes-Viernes 9am-6pm');
INSERT INTO public.horarios (id, descripcion) VALUES (2, 'Lunes-Viernes 7am-4pm');


--
-- TOC entry 5124 (class 0 OID 51616)
-- Dependencies: 230
-- Data for Name: materias_primas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (3, 'Sal', 2000.00, 10);
INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (4, 'Bolsa', 2000.00, 10);
INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (1, 'Salsa de Tomate', 1000.00, 2);
INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (2, 'Salsa de Soya', 1000.00, 2);
INSERT INTO public.materias_primas (id, nombre, precio, stock) VALUES (5, 'Carne', 10000.00, 4);


--
-- TOC entry 5126 (class 0 OID 51620)
-- Dependencies: 232
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5146 (class 0 OID 51862)
-- Dependencies: 252
-- Data for Name: pagos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pagos (id, proveedor_id, fecha_pago, precio, impuesto, precio_total, referencia, notas) VALUES (1, 1, '2025-04-15', 1000.00, 100.00, 1100.00, 'dasddsa', 'adatttt');
INSERT INTO public.pagos (id, proveedor_id, fecha_pago, precio, impuesto, precio_total, referencia, notas) VALUES (2, 1, '2025-04-06', 1000.00, 1000.00, 2000.00, 'aaahhh', 'aaa');
INSERT INTO public.pagos (id, proveedor_id, fecha_pago, precio, impuesto, precio_total, referencia, notas) VALUES (3, 1, '2025-04-15', 644.00, 989080.00, 989724.00, '808-0', '');
INSERT INTO public.pagos (id, proveedor_id, fecha_pago, precio, impuesto, precio_total, referencia, notas) VALUES (4, 1, '2025-04-22', 1000.00, 5000.00, 6000.00, 'N18238393334', 'a');


--
-- TOC entry 5128 (class 0 OID 51637)
-- Dependencies: 234
-- Data for Name: pedido_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (3, 2, 10, 4, 4000.00, 16000.00, '2025-04-14 14:14:16.999-06', '2025-04-14 14:14:16.999-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (4, 2, 13, 7, 3000.00, 21000.00, '2025-04-14 14:14:17.003-06', '2025-04-14 14:14:17.003-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (1, 1, 9, 5, 4000.00, 20000.00, '2025-03-21 20:38:44.717-06', '2025-03-21 20:38:44.717-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (2, 1, 10, 8, 4000.00, 32000.00, '2025-03-21 20:38:44.723-06', '2025-03-21 20:38:44.723-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (7, 4, 9, 8, 4000.00, 32000.00, '2025-04-14 16:10:58.388-06', '2025-04-14 16:10:58.388-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (8, 4, 13, 9, 3000.00, 27000.00, '2025-04-14 16:10:58.391-06', '2025-04-14 16:10:58.391-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (5, 3, 10, 7, 4000.00, 28000.00, '2025-04-14 16:10:33.316-06', '2025-04-14 16:10:33.316-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (6, 3, 11, 8, 5000.00, 40000.00, '2025-04-14 16:10:33.318-06', '2025-04-14 16:10:33.318-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (9, 5, 10, 2, 4000.00, 8000.00, '2025-04-14 16:48:16.795-06', '2025-04-14 16:48:16.795-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (10, 5, 11, 3, 5000.00, 15000.00, '2025-04-14 16:48:16.798-06', '2025-04-14 16:48:16.798-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (11, 5, 12, 4, 3000.00, 12000.00, '2025-04-14 16:48:16.799-06', '2025-04-14 16:48:16.799-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (12, 6, 10, 5, 4000.00, 20000.00, '2025-04-22 20:05:41.998-06', '2025-04-22 20:05:41.998-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (13, 6, 11, 6, 5000.00, 30000.00, '2025-04-22 20:05:42.001-06', '2025-04-22 20:05:42.001-06');
INSERT INTO public.pedido_detalles (id, pedidoid, productoid, cantidad, preciounitario, subtotal, created_at, updated_at) VALUES (14, 6, 12, 7, 3000.00, 21000.00, '2025-04-22 20:05:42.002-06', '2025-04-22 20:05:42.002-06');


--
-- TOC entry 5130 (class 0 OID 51643)
-- Dependencies: 236
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pedidos (idpedido, fecha, distribuidorid, preciototal, estadodepago, estadodeentrega, comprobantedepago, created_at, updated_at) VALUES (2, '2025-04-18', 4, 37000.00, 'pendiente', 'entregado', NULL, '2025-04-14 14:14:16.963-06', '2025-04-14 14:14:16.963-06');
INSERT INTO public.pedidos (idpedido, fecha, distribuidorid, preciototal, estadodepago, estadodeentrega, comprobantedepago, created_at, updated_at) VALUES (1, '2025-03-22', 4, 52000.00, 'aprobado', 'entregado', NULL, '2025-03-21 20:38:44.668-06', '2025-03-21 20:38:44.668-06');
INSERT INTO public.pedidos (idpedido, fecha, distribuidorid, preciototal, estadodepago, estadodeentrega, comprobantedepago, created_at, updated_at) VALUES (3, '2025-04-14', 4, 68000.00, 'aprobado', 'entregado', NULL, '2025-04-14 16:10:33.287-06', '2025-04-14 16:10:33.287-06');
INSERT INTO public.pedidos (idpedido, fecha, distribuidorid, preciototal, estadodepago, estadodeentrega, comprobantedepago, created_at, updated_at) VALUES (5, '2025-04-16', 4, 35000.00, 'pendiente', 'no entregado', NULL, '2025-04-14 16:48:16.757-06', '2025-04-14 16:48:16.757-06');
INSERT INTO public.pedidos (idpedido, fecha, distribuidorid, preciototal, estadodepago, estadodeentrega, comprobantedepago, created_at, updated_at) VALUES (4, '2025-04-14', 5, 59000.00, 'pendiente', 'no entregado', 'https://uerxbwntfwyvkspdtlaq.supabase.co/storage/v1/object/public/Comprobantes%20Pedidos/pedidos/4/1744675919524-descarga.jpg', '2025-04-14 16:10:58.36-06', '2025-04-14 16:10:58.36-06');
INSERT INTO public.pedidos (idpedido, fecha, distribuidorid, preciototal, estadodepago, estadodeentrega, comprobantedepago, created_at, updated_at) VALUES (6, '2025-04-22', 4, 71000.00, 'pendiente', 'no entregado', NULL, '2025-04-22 20:05:41.962-06', '2025-04-22 20:05:41.962-06');


--
-- TOC entry 5133 (class 0 OID 51653)
-- Dependencies: 239
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (10, 'Arreglado de Pollo Picante', 4000.00, 5, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (11, 'Arreglado de Pollo Casero', 5000.00, 4, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (12, 'Arreglado de Pollo comun', 3000.00, 1, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (13, 'Arreglado de Pollo comun', 3000.00, 1, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (14, 'Arreglado de Pollo normal', 3000.00, 1, 1);
INSERT INTO public.productos (id, nombre, precio, stock, formulaciones_id) VALUES (9, 'Arreglado de Pollo', 4000.00, 10, 1);


--
-- TOC entry 5144 (class 0 OID 51849)
-- Dependencies: 250
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.proveedores (id, nombre, contacto, telefono, correo, direccion, estado) VALUES (1, 'proveedor1', 'contacto1', '1237r554543', 'proveedor1@gmail.com', 'San Jose ', true);


--
-- TOC entry 5135 (class 0 OID 51658)
-- Dependencies: 241
-- Data for Name: reportes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5137 (class 0 OID 51665)
-- Dependencies: 243
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (id, nombre) VALUES (1, 'Administrador');
INSERT INTO public.roles (id, nombre) VALUES (2, 'Gerente de planta');
INSERT INTO public.roles (id, nombre) VALUES (3, 'Distribuidor');
INSERT INTO public.roles (id, nombre) VALUES (4, 'Colaborador de Planta');
INSERT INTO public.roles (id, nombre) VALUES (5, 'Usuario');


--
-- TOC entry 5139 (class 0 OID 51669)
-- Dependencies: 245
-- Data for Name: solicitudes_vacaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5141 (class 0 OID 51675)
-- Dependencies: 247
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token, imagen_url) VALUES (1, 'Vladimir Conejo Oviedo', 'vconejo90786@gmail.com', '$2b$10$r9epmmGtCal9HeraBCXXOep4TImVsOu8mrYxMOTMykuHjfzJPuBka', 1, true, '2025-03-11 18:40:41.413-06', 'iunulblgk11im3snp65', NULL);
INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token, imagen_url) VALUES (3, 'Josue Calderon', 'ronaldjosuecb10@hotmail.com', '$2b$10$gY4F8wtmUqVhwSonJk63He8SYg8Yr6ROPtVvqwJ.OwWMmNJlvOeSm', 1, true, '2025-04-14 13:23:54.305-06', '18lbsl8aqjg1ioqs45i1', 'https://uerxbwntfwyvkspdtlaq.supabase.co/storage/v1/object/public/perfiles/avatars/3/1744667386568-descarga.jpg');
INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token, imagen_url) VALUES (4, 'Cristiano Ronaldo', 'cr7@gmail.com', '$2b$10$XNi5jw6ogs8MEarMwiZyOOwzj5DlyH.N14iu94p8QlsjiSUpJYMo6', 3, true, '2025-04-14 16:04:09.565-06', '9ck953453j81ior59jet', NULL);
INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token, imagen_url) VALUES (5, 'Edgardo Ruiz', 'edgardor@gmail.com', '$2b$10$To/XgPm34.elh/6uI6mzyugQXib7nvC2c5ydUbt35eXQwRF39IyMK', 3, true, '2025-04-22 18:29:30.559-06', 'sdh2s0n1r81ipg0pg1v', NULL);
INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token, imagen_url) VALUES (6, 'Lorena', 'lorena@gmail.com', '$2b$10$A8A4AbBfmwmrR.3RWVpydOPp6uVoMyzF.bAZ7LndyIsqW0lhqV4DK', 4, true, '2025-04-22 18:33:34.536-06', 'ovsba6vu9n81ipg10ua8', NULL);
INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token, imagen_url) VALUES (7, 'Francisco', 'fransico@gmail.com', '$2b$10$H8pn5fuuNiXKN7s3C/A4P.CBn7ecEWQbKTrHn4XNeSMLHrYstGXa.', 4, true, '2025-04-22 19:54:16.578-06', 'gl3kqgtrh11ipg5kms2', NULL);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 218
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 12, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.distribuidores_id_seq', 6, true);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 223
-- Name: formulaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formulaciones_id_seq', 11, true);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formulaciones_id_seq1', 4, true);


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 227
-- Name: gestion_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gestion_error_id_seq', 42, true);


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 229
-- Name: horarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.horarios_id_seq', 2, true);


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 231
-- Name: materias_primas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materias_primas_id_seq', 5, true);


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 233
-- Name: notificaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificaciones_id_seq', 1, false);


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 251
-- Name: pagos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pagos_id_seq', 4, true);


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 235
-- Name: pedido_detalles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_detalles_id_seq', 14, true);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 237
-- Name: pedidos_idpedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_idpedido_seq', 6, true);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 238
-- Name: planilla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planilla_id_seq', 2, true);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 240
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_seq', 14, true);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 249
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_id_seq', 1, true);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 242
-- Name: reportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reportes_id_seq', 1, false);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 244
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 5, true);


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 246
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitudes_vacaciones_id_seq', 1, false);


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 248
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 7, true);


--
-- TOC entry 4872 (class 2606 OID 51699)
-- Name: clientes clientes_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_correo_key UNIQUE (correo);


--
-- TOC entry 4874 (class 2606 OID 51701)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4878 (class 2606 OID 51703)
-- Name: distribuidores distribuidores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_pkey PRIMARY KEY (id);


--
-- TOC entry 4882 (class 2606 OID 51705)
-- Name: gestion_formulaciones formulaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT formulaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4880 (class 2606 OID 51707)
-- Name: formulaciones formulaciones_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones
    ADD CONSTRAINT formulaciones_pkey1 PRIMARY KEY (id);


--
-- TOC entry 4886 (class 2606 OID 51709)
-- Name: gestion_error gestion_error_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_error
    ADD CONSTRAINT gestion_error_pkey PRIMARY KEY (id);


--
-- TOC entry 4888 (class 2606 OID 51711)
-- Name: horarios horarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios
    ADD CONSTRAINT horarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4890 (class 2606 OID 51713)
-- Name: materias_primas materias_primas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materias_primas
    ADD CONSTRAINT materias_primas_pkey PRIMARY KEY (id);


--
-- TOC entry 4892 (class 2606 OID 51715)
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 51870)
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 51719)
-- Name: pedido_detalles pedido_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles
    ADD CONSTRAINT pedido_detalles_pkey PRIMARY KEY (id);


--
-- TOC entry 4896 (class 2606 OID 51721)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (idpedido);


--
-- TOC entry 4884 (class 2606 OID 51723)
-- Name: gestion_colaboradores planilla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_pkey PRIMARY KEY (id);


--
-- TOC entry 4898 (class 2606 OID 51725)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- TOC entry 4948 (class 2606 OID 51857)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 4900 (class 2606 OID 51727)
-- Name: reportes reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);


--
-- TOC entry 4902 (class 2606 OID 51729)
-- Name: roles roles_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key UNIQUE (nombre);


--
-- TOC entry 4904 (class 2606 OID 51731)
-- Name: roles roles_nombre_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key1 UNIQUE (nombre);


--
-- TOC entry 4906 (class 2606 OID 51733)
-- Name: roles roles_nombre_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key2 UNIQUE (nombre);


--
-- TOC entry 4908 (class 2606 OID 51735)
-- Name: roles roles_nombre_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key3 UNIQUE (nombre);


--
-- TOC entry 4910 (class 2606 OID 51737)
-- Name: roles roles_nombre_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key4 UNIQUE (nombre);


--
-- TOC entry 4912 (class 2606 OID 51739)
-- Name: roles roles_nombre_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key5 UNIQUE (nombre);


--
-- TOC entry 4914 (class 2606 OID 51741)
-- Name: roles roles_nombre_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key6 UNIQUE (nombre);


--
-- TOC entry 4916 (class 2606 OID 51743)
-- Name: roles roles_nombre_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key7 UNIQUE (nombre);


--
-- TOC entry 4918 (class 2606 OID 51745)
-- Name: roles roles_nombre_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key8 UNIQUE (nombre);


--
-- TOC entry 4920 (class 2606 OID 51747)
-- Name: roles roles_nombre_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key9 UNIQUE (nombre);


--
-- TOC entry 4922 (class 2606 OID 51749)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4924 (class 2606 OID 51751)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4876 (class 2606 OID 51753)
-- Name: clientes unique_numero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT unique_numero UNIQUE (numero);


--
-- TOC entry 4926 (class 2606 OID 51755)
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- TOC entry 4928 (class 2606 OID 51757)
-- Name: usuarios usuarios_correo_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key1 UNIQUE (correo);


--
-- TOC entry 4930 (class 2606 OID 51759)
-- Name: usuarios usuarios_correo_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key2 UNIQUE (correo);


--
-- TOC entry 4932 (class 2606 OID 51761)
-- Name: usuarios usuarios_correo_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key3 UNIQUE (correo);


--
-- TOC entry 4934 (class 2606 OID 51763)
-- Name: usuarios usuarios_correo_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key4 UNIQUE (correo);


--
-- TOC entry 4936 (class 2606 OID 51765)
-- Name: usuarios usuarios_correo_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key5 UNIQUE (correo);


--
-- TOC entry 4938 (class 2606 OID 51767)
-- Name: usuarios usuarios_correo_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key6 UNIQUE (correo);


--
-- TOC entry 4940 (class 2606 OID 51769)
-- Name: usuarios usuarios_correo_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key7 UNIQUE (correo);


--
-- TOC entry 4942 (class 2606 OID 51771)
-- Name: usuarios usuarios_correo_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key8 UNIQUE (correo);


--
-- TOC entry 4944 (class 2606 OID 51773)
-- Name: usuarios usuarios_correo_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key9 UNIQUE (correo);


--
-- TOC entry 4946 (class 2606 OID 51775)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4951 (class 2606 OID 51777)
-- Name: clientes clientes_distribuidor_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_distribuidor_id_FK" FOREIGN KEY (distribuidor_id) REFERENCES public.distribuidores(id) NOT VALID;


--
-- TOC entry 4952 (class 2606 OID 51782)
-- Name: distribuidores distribuidores_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4960 (class 2606 OID 51787)
-- Name: pedidos fk_distribuidor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_distribuidor FOREIGN KEY (distribuidorid) REFERENCES public.distribuidores(id) ON DELETE CASCADE;


--
-- TOC entry 4955 (class 2606 OID 51792)
-- Name: gestion_colaboradores fk_horario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT fk_horario FOREIGN KEY (horario_id) REFERENCES public.horarios(id);


--
-- TOC entry 4958 (class 2606 OID 51797)
-- Name: pedido_detalles fk_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles
    ADD CONSTRAINT fk_pedido FOREIGN KEY (pedidoid) REFERENCES public.pedidos(idpedido) ON DELETE CASCADE;


--
-- TOC entry 4959 (class 2606 OID 51802)
-- Name: pedido_detalles fk_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalles
    ADD CONSTRAINT fk_producto FOREIGN KEY (productoid) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4965 (class 2606 OID 51871)
-- Name: pagos fk_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT fk_proveedor FOREIGN KEY (proveedor_id) REFERENCES public.proveedores(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4953 (class 2606 OID 51807)
-- Name: gestion_formulaciones gestion_formulacion_formulaciones_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT "gestion_formulacion_formulaciones_id_FK" FOREIGN KEY (formulacion_id) REFERENCES public.formulaciones(id) NOT VALID;


--
-- TOC entry 4954 (class 2606 OID 51812)
-- Name: gestion_formulaciones gestion_formulacion_materias_primas_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_formulaciones
    ADD CONSTRAINT "gestion_formulacion_materias_primas_id_FK" FOREIGN KEY (materia_prima_id) REFERENCES public.materias_primas(id) NOT VALID;


--
-- TOC entry 4957 (class 2606 OID 51817)
-- Name: notificaciones notificaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4956 (class 2606 OID 51822)
-- Name: gestion_colaboradores planilla_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4961 (class 2606 OID 51827)
-- Name: productos productos_formulacion_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "productos_formulacion_id_FK" FOREIGN KEY (formulaciones_id) REFERENCES public.formulaciones(id) NOT VALID;


--
-- TOC entry 4962 (class 2606 OID 51832)
-- Name: reportes reportes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4963 (class 2606 OID 51837)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4964 (class 2606 OID 51842)
-- Name: usuarios usuarios_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-06-19 22:08:15

--
-- PostgreSQL database dump complete
--

