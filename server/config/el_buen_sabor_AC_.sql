--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-02-28 21:47:25

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 248 (class 1259 OID 25368)
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
-- TOC entry 247 (class 1259 OID 25367)
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
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 247
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- TOC entry 217 (class 1259 OID 25123)
-- Name: detalle_pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_pedidos (
    id integer NOT NULL,
    pedido_id integer,
    producto_id integer,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL
);


ALTER TABLE public.detalle_pedidos OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25126)
-- Name: detalle_pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_pedidos_id_seq OWNER TO postgres;

--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 218
-- Name: detalle_pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_pedidos_id_seq OWNED BY public.detalle_pedidos.id;


--
-- TOC entry 219 (class 1259 OID 25127)
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
-- TOC entry 220 (class 1259 OID 25134)
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
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.distribuidores_id_seq OWNED BY public.distribuidores.id;


--
-- TOC entry 221 (class 1259 OID 25135)
-- Name: facturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facturas (
    id integer NOT NULL,
    pedido_id integer,
    numero_factura character varying(50) NOT NULL,
    fecha_emision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total numeric(10,2) NOT NULL,
    archivo_pdf character varying(255)
);


ALTER TABLE public.facturas OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25139)
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facturas_id_seq OWNER TO postgres;

--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 222
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_id_seq OWNED BY public.facturas.id;


--
-- TOC entry 223 (class 1259 OID 25140)
-- Name: formulaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formulaciones (
    id integer NOT NULL,
    materia_prima_id integer NOT NULL,
    precio_total numeric(10,2) NOT NULL,
    produccion_total integer NOT NULL
);


ALTER TABLE public.formulaciones OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25143)
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
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formulaciones_id_seq OWNED BY public.formulaciones.id;


--
-- TOC entry 225 (class 1259 OID 25144)
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
-- TOC entry 226 (class 1259 OID 25148)
-- Name: gestion_error; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gestion_error (
    id bigint NOT NULL,
    usuario_id bigint,
    fecha timestamp with time zone NOT NULL,
    accion character varying(255) NOT NULL,
    mensaje text NOT NULL,
    estado character varying(50) NOT NULL
);


ALTER TABLE public.gestion_error OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25153)
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
-- TOC entry 228 (class 1259 OID 25154)
-- Name: horarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horarios (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.horarios OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25159)
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
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 229
-- Name: horarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.horarios_id_seq OWNED BY public.horarios.id;


--
-- TOC entry 250 (class 1259 OID 25788)
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
-- TOC entry 249 (class 1259 OID 25787)
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
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 249
-- Name: materias_primas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materias_primas_id_seq OWNED BY public.materias_primas.id;


--
-- TOC entry 230 (class 1259 OID 25172)
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
-- TOC entry 231 (class 1259 OID 25180)
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
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 231
-- Name: notificaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notificaciones_id_seq OWNED BY public.notificaciones.id;


--
-- TOC entry 232 (class 1259 OID 25181)
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
-- TOC entry 233 (class 1259 OID 25188)
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
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 233
-- Name: pagos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pagos_id_seq OWNED BY public.pagos.id;


--
-- TOC entry 234 (class 1259 OID 25189)
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id integer NOT NULL,
    distribuidor_id integer,
    fecha_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(50) NOT NULL,
    total numeric(10,2) NOT NULL,
    comprobante_pago character varying(255),
    factura_generada boolean DEFAULT false,
    CONSTRAINT pedidos_estado_check CHECK (((estado)::text = ANY (ARRAY[('Pendiente'::character varying)::text, ('En preparación'::character varying)::text, ('Completado'::character varying)::text, ('Entregado'::character varying)::text, ('Pago en revisión'::character varying)::text])))
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25195)
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_id_seq OWNER TO postgres;

--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 235
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- TOC entry 236 (class 1259 OID 25196)
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
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 236
-- Name: planilla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planilla_id_seq OWNED BY public.gestion_colaboradores.id;


--
-- TOC entry 237 (class 1259 OID 25197)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text NOT NULL,
    precio numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    tipo character varying(50) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    formulacion_id integer NOT NULL,
    CONSTRAINT productos_tipo_check CHECK (((tipo)::text = ANY (ARRAY[('Materia Prima'::character varying)::text, ('Producto Terminado'::character varying)::text])))
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 25205)
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
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 238
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- TOC entry 239 (class 1259 OID 25206)
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
-- TOC entry 240 (class 1259 OID 25212)
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
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 240
-- Name: reportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reportes_id_seq OWNED BY public.reportes.id;


--
-- TOC entry 241 (class 1259 OID 25213)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 25216)
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
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 242
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 243 (class 1259 OID 25217)
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
-- TOC entry 244 (class 1259 OID 25222)
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
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 244
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.solicitudes_vacaciones_id_seq OWNED BY public.solicitudes_vacaciones.id;


--
-- TOC entry 245 (class 1259 OID 25223)
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
-- TOC entry 246 (class 1259 OID 25230)
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
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 246
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4786 (class 2604 OID 25371)
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- TOC entry 4758 (class 2604 OID 25231)
-- Name: detalle_pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos ALTER COLUMN id SET DEFAULT nextval('public.detalle_pedidos_id_seq'::regclass);


--
-- TOC entry 4759 (class 2604 OID 25232)
-- Name: distribuidores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores ALTER COLUMN id SET DEFAULT nextval('public.distribuidores_id_seq'::regclass);


--
-- TOC entry 4762 (class 2604 OID 25233)
-- Name: facturas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas ALTER COLUMN id SET DEFAULT nextval('public.facturas_id_seq'::regclass);


--
-- TOC entry 4764 (class 2604 OID 25234)
-- Name: formulaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq'::regclass);


--
-- TOC entry 4765 (class 2604 OID 25235)
-- Name: gestion_colaboradores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores ALTER COLUMN id SET DEFAULT nextval('public.planilla_id_seq'::regclass);


--
-- TOC entry 4767 (class 2604 OID 25236)
-- Name: horarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios ALTER COLUMN id SET DEFAULT nextval('public.horarios_id_seq'::regclass);


--
-- TOC entry 4788 (class 2604 OID 25791)
-- Name: materias_primas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materias_primas ALTER COLUMN id SET DEFAULT nextval('public.materias_primas_id_seq'::regclass);


--
-- TOC entry 4768 (class 2604 OID 25239)
-- Name: notificaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones ALTER COLUMN id SET DEFAULT nextval('public.notificaciones_id_seq'::regclass);


--
-- TOC entry 4771 (class 2604 OID 25240)
-- Name: pagos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos ALTER COLUMN id SET DEFAULT nextval('public.pagos_id_seq'::regclass);


--
-- TOC entry 4773 (class 2604 OID 25241)
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- TOC entry 4776 (class 2604 OID 25242)
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 25243)
-- Name: reportes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes ALTER COLUMN id SET DEFAULT nextval('public.reportes_id_seq'::regclass);


--
-- TOC entry 4781 (class 2604 OID 25244)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4782 (class 2604 OID 25245)
-- Name: solicitudes_vacaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones ALTER COLUMN id SET DEFAULT nextval('public.solicitudes_vacaciones_id_seq'::regclass);


--
-- TOC entry 4784 (class 2604 OID 25246)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5067 (class 0 OID 25368)
-- Dependencies: 248
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (7, 'Vladimir', 'Carlos Castro', '61062711', 'vconejo90786@gmail.com', 'San Rafael', true, 4);
INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (8, 'Felipe Chacon', 'Mariana Castro', '61062710', 'carlos@gmail.com', 'San Rafael', true, 4);
INSERT INTO public.clientes (id, nombre, representante, numero, correo, direccion, estado, distribuidor_id) VALUES (12, 'Felipe Chacon', 'Carlos', '61062777', 'mari.ulatec@gmail.com', 'Calle Blancos', true, 4);


--
-- TOC entry 5036 (class 0 OID 25123)
-- Dependencies: 217
-- Data for Name: detalle_pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5038 (class 0 OID 25127)
-- Dependencies: 219
-- Data for Name: distribuidores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.distribuidores (id, usuario_id, empresa, telefono, direccion, zona_cobertura, fecha_registro, estado) VALUES (4, 1, 'CarnesCastro', '81062720', 'San Rafael', 'Heredia', '2025-02-27 02:57:01.351', true);


--
-- TOC entry 5040 (class 0 OID 25135)
-- Dependencies: 221
-- Data for Name: facturas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5042 (class 0 OID 25140)
-- Dependencies: 223
-- Data for Name: formulaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5044 (class 0 OID 25144)
-- Dependencies: 225
-- Data for Name: gestion_colaboradores; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5045 (class 0 OID 25148)
-- Dependencies: 226
-- Data for Name: gestion_error; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5047 (class 0 OID 25154)
-- Dependencies: 228
-- Data for Name: horarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.horarios (id, descripcion) VALUES (1, 'Lunes-Viernes 9am-6pm');
INSERT INTO public.horarios (id, descripcion) VALUES (2, 'Lunes-Viernes 7am-4pm');


--
-- TOC entry 5069 (class 0 OID 25788)
-- Dependencies: 250
-- Data for Name: materias_primas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5049 (class 0 OID 25172)
-- Dependencies: 230
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5051 (class 0 OID 25181)
-- Dependencies: 232
-- Data for Name: pagos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5053 (class 0 OID 25189)
-- Dependencies: 234
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5056 (class 0 OID 25197)
-- Dependencies: 237
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5058 (class 0 OID 25206)
-- Dependencies: 239
-- Data for Name: reportes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5060 (class 0 OID 25213)
-- Dependencies: 241
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (id, nombre) VALUES (1, 'Administrador');
INSERT INTO public.roles (id, nombre) VALUES (2, 'Gerente de planta');
INSERT INTO public.roles (id, nombre) VALUES (3, 'Distribuidor');
INSERT INTO public.roles (id, nombre) VALUES (4, 'Colaborador de Planta');
INSERT INTO public.roles (id, nombre) VALUES (5, 'Usuario');


--
-- TOC entry 5062 (class 0 OID 25217)
-- Dependencies: 243
-- Data for Name: solicitudes_vacaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5064 (class 0 OID 25223)
-- Dependencies: 245
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token) VALUES (1, 'Vladimir', 'vconejo90786@gmail.com', '12345', 5, true, '2025-02-16 22:06:52.862-06', 'dffepndqeb1ik91cplt');


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 247
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 12, true);


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 218
-- Name: detalle_pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_pedidos_id_seq', 1, false);


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.distribuidores_id_seq', 4, true);


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 222
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_id_seq', 1, false);


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formulaciones_id_seq', 1, false);


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 227
-- Name: gestion_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gestion_error_id_seq', 1, false);


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 229
-- Name: horarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.horarios_id_seq', 2, true);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 249
-- Name: materias_primas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materias_primas_id_seq', 1, false);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 231
-- Name: notificaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificaciones_id_seq', 1, false);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 233
-- Name: pagos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pagos_id_seq', 1, false);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 235
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 1, false);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 236
-- Name: planilla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planilla_id_seq', 1, false);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 238
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_seq', 1, false);


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 240
-- Name: reportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reportes_id_seq', 1, false);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 242
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 5, true);


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 244
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitudes_vacaciones_id_seq', 1, false);


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 246
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 2, true);


--
-- TOC entry 4870 (class 2606 OID 25763)
-- Name: clientes clientes_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_correo_key UNIQUE (correo);


--
-- TOC entry 4872 (class 2606 OID 25378)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 25248)
-- Name: detalle_pedidos detalle_pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4797 (class 2606 OID 25250)
-- Name: distribuidores distribuidores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_pkey PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 25252)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 4801 (class 2606 OID 25254)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 4804 (class 2606 OID 25256)
-- Name: formulaciones formulaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones
    ADD CONSTRAINT formulaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4808 (class 2606 OID 25258)
-- Name: gestion_error gestion_error_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_error
    ADD CONSTRAINT gestion_error_pkey PRIMARY KEY (id);


--
-- TOC entry 4810 (class 2606 OID 25260)
-- Name: horarios horarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios
    ADD CONSTRAINT horarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4876 (class 2606 OID 25793)
-- Name: materias_primas materias_primas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materias_primas
    ADD CONSTRAINT materias_primas_pkey PRIMARY KEY (id);


--
-- TOC entry 4812 (class 2606 OID 25266)
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4815 (class 2606 OID 25268)
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);


--
-- TOC entry 4818 (class 2606 OID 25270)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4806 (class 2606 OID 25272)
-- Name: gestion_colaboradores planilla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 2606 OID 25274)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 25276)
-- Name: reportes reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 25712)
-- Name: roles roles_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key UNIQUE (nombre);


--
-- TOC entry 4826 (class 2606 OID 25714)
-- Name: roles roles_nombre_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key1 UNIQUE (nombre);


--
-- TOC entry 4828 (class 2606 OID 25716)
-- Name: roles roles_nombre_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key2 UNIQUE (nombre);


--
-- TOC entry 4830 (class 2606 OID 25718)
-- Name: roles roles_nombre_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key3 UNIQUE (nombre);


--
-- TOC entry 4832 (class 2606 OID 25720)
-- Name: roles roles_nombre_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key4 UNIQUE (nombre);


--
-- TOC entry 4834 (class 2606 OID 25722)
-- Name: roles roles_nombre_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key5 UNIQUE (nombre);


--
-- TOC entry 4836 (class 2606 OID 25724)
-- Name: roles roles_nombre_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key6 UNIQUE (nombre);


--
-- TOC entry 4838 (class 2606 OID 25726)
-- Name: roles roles_nombre_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key7 UNIQUE (nombre);


--
-- TOC entry 4840 (class 2606 OID 25728)
-- Name: roles roles_nombre_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key8 UNIQUE (nombre);


--
-- TOC entry 4842 (class 2606 OID 25730)
-- Name: roles roles_nombre_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key9 UNIQUE (nombre);


--
-- TOC entry 4844 (class 2606 OID 25280)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 25282)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4874 (class 2606 OID 25761)
-- Name: clientes unique_numero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT unique_numero UNIQUE (numero);


--
-- TOC entry 4848 (class 2606 OID 25734)
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- TOC entry 4850 (class 2606 OID 25736)
-- Name: usuarios usuarios_correo_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key1 UNIQUE (correo);


--
-- TOC entry 4852 (class 2606 OID 25738)
-- Name: usuarios usuarios_correo_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key2 UNIQUE (correo);


--
-- TOC entry 4854 (class 2606 OID 25740)
-- Name: usuarios usuarios_correo_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key3 UNIQUE (correo);


--
-- TOC entry 4856 (class 2606 OID 25742)
-- Name: usuarios usuarios_correo_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key4 UNIQUE (correo);


--
-- TOC entry 4858 (class 2606 OID 25744)
-- Name: usuarios usuarios_correo_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key5 UNIQUE (correo);


--
-- TOC entry 4860 (class 2606 OID 25746)
-- Name: usuarios usuarios_correo_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key6 UNIQUE (correo);


--
-- TOC entry 4862 (class 2606 OID 25748)
-- Name: usuarios usuarios_correo_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key7 UNIQUE (correo);


--
-- TOC entry 4864 (class 2606 OID 25750)
-- Name: usuarios usuarios_correo_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key8 UNIQUE (correo);


--
-- TOC entry 4866 (class 2606 OID 25752)
-- Name: usuarios usuarios_correo_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key9 UNIQUE (correo);


--
-- TOC entry 4868 (class 2606 OID 25286)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4802 (class 1259 OID 25287)
-- Name: idx_facturas_pedido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_pedido ON public.facturas USING btree (pedido_id);


--
-- TOC entry 4813 (class 1259 OID 25289)
-- Name: idx_pagos_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pagos_proveedor ON public.pagos USING btree (proveedor);


--
-- TOC entry 4816 (class 1259 OID 25290)
-- Name: idx_pedidos_distribuidor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_distribuidor ON public.pedidos USING btree (distribuidor_id);


--
-- TOC entry 4890 (class 2606 OID 25782)
-- Name: clientes clientes_distribuidor_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_distribuidor_id_FK" FOREIGN KEY (distribuidor_id) REFERENCES public.distribuidores(id) NOT VALID;


--
-- TOC entry 4877 (class 2606 OID 25291)
-- Name: detalle_pedidos detalle_pedidos_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4878 (class 2606 OID 25296)
-- Name: detalle_pedidos detalle_pedidos_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4879 (class 2606 OID 25301)
-- Name: distribuidores distribuidores_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4880 (class 2606 OID 25306)
-- Name: facturas facturas_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4882 (class 2606 OID 25311)
-- Name: gestion_colaboradores fk_horario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT fk_horario FOREIGN KEY (horario_id) REFERENCES public.horarios(id);


--
-- TOC entry 4881 (class 2606 OID 25798)
-- Name: formulaciones formulaciones_materiaprima_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones
    ADD CONSTRAINT "formulaciones_materiaprima_id_FK" FOREIGN KEY (materia_prima_id) REFERENCES public.materias_primas(id) NOT VALID;


--
-- TOC entry 4884 (class 2606 OID 25341)
-- Name: notificaciones notificaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4885 (class 2606 OID 25346)
-- Name: pedidos pedidos_distribuidor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_distribuidor_id_fkey FOREIGN KEY (distribuidor_id) REFERENCES public.distribuidores(id) ON DELETE SET NULL;


--
-- TOC entry 4883 (class 2606 OID 25351)
-- Name: gestion_colaboradores planilla_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4886 (class 2606 OID 25803)
-- Name: productos productos_formulacion_id_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT "productos_formulacion_id_FK" FOREIGN KEY (formulacion_id) REFERENCES public.formulaciones(id) NOT VALID;


--
-- TOC entry 4887 (class 2606 OID 25356)
-- Name: reportes reportes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4888 (class 2606 OID 25361)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4889 (class 2606 OID 25753)
-- Name: usuarios usuarios_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2025-02-28 21:47:25

--
-- PostgreSQL database dump complete
--

