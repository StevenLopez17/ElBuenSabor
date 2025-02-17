--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-02-16 22:08:52

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
-- TOC entry 217 (class 1259 OID 17343)
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
-- TOC entry 218 (class 1259 OID 17346)
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
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 218
-- Name: detalle_pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_pedidos_id_seq OWNED BY public.detalle_pedidos.id;


--
-- TOC entry 219 (class 1259 OID 17347)
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
-- TOC entry 220 (class 1259 OID 17353)
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
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.distribuidores_id_seq OWNED BY public.distribuidores.id;


--
-- TOC entry 221 (class 1259 OID 17354)
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
-- TOC entry 222 (class 1259 OID 17358)
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
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 222
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_id_seq OWNED BY public.facturas.id;


--
-- TOC entry 223 (class 1259 OID 17359)
-- Name: formulaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formulaciones (
    id integer NOT NULL,
    producto_terminado_id integer,
    materia_prima_id integer,
    cantidad_utilizada integer NOT NULL
);


ALTER TABLE public.formulaciones OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17362)
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
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formulaciones_id_seq OWNED BY public.formulaciones.id;


--
-- TOC entry 225 (class 1259 OID 17363)
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
-- TOC entry 226 (class 1259 OID 17366)
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
-- TOC entry 227 (class 1259 OID 17371)
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
-- TOC entry 250 (class 1259 OID 17653)
-- Name: horarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horarios (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.horarios OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17652)
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
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 249
-- Name: horarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.horarios_id_seq OWNED BY public.horarios.id;


--
-- TOC entry 228 (class 1259 OID 17372)
-- Name: inventario_materias_primas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario_materias_primas (
    id integer NOT NULL,
    producto_id integer,
    cantidad_disponible integer DEFAULT 0 NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.inventario_materias_primas OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17377)
-- Name: inventario_materias_primas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_materias_primas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_materias_primas_id_seq OWNER TO postgres;

--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 229
-- Name: inventario_materias_primas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_materias_primas_id_seq OWNED BY public.inventario_materias_primas.id;


--
-- TOC entry 230 (class 1259 OID 17378)
-- Name: inventario_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario_productos (
    id integer NOT NULL,
    producto_id integer,
    cantidad_disponible integer DEFAULT 0 NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.inventario_productos OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17383)
-- Name: inventario_productos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_productos_id_seq OWNER TO postgres;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 231
-- Name: inventario_productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_productos_id_seq OWNED BY public.inventario_productos.id;


--
-- TOC entry 232 (class 1259 OID 17384)
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
-- TOC entry 233 (class 1259 OID 17392)
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
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 233
-- Name: notificaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notificaciones_id_seq OWNED BY public.notificaciones.id;


--
-- TOC entry 234 (class 1259 OID 17393)
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
-- TOC entry 235 (class 1259 OID 17400)
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
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 235
-- Name: pagos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pagos_id_seq OWNED BY public.pagos.id;


--
-- TOC entry 236 (class 1259 OID 17401)
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
-- TOC entry 237 (class 1259 OID 17407)
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
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 237
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- TOC entry 238 (class 1259 OID 17408)
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
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 238
-- Name: planilla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planilla_id_seq OWNED BY public.gestion_colaboradores.id;


--
-- TOC entry 239 (class 1259 OID 17409)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    precio numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    tipo character varying(50),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT productos_tipo_check CHECK (((tipo)::text = ANY (ARRAY[('Materia Prima'::character varying)::text, ('Producto Terminado'::character varying)::text])))
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17417)
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
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 240
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- TOC entry 241 (class 1259 OID 17418)
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
-- TOC entry 242 (class 1259 OID 17424)
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
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 242
-- Name: reportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reportes_id_seq OWNED BY public.reportes.id;


--
-- TOC entry 246 (class 1259 OID 17432)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17431)
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
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 245
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 243 (class 1259 OID 17425)
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
-- TOC entry 244 (class 1259 OID 17430)
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
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 244
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.solicitudes_vacaciones_id_seq OWNED BY public.solicitudes_vacaciones.id;


--
-- TOC entry 248 (class 1259 OID 17441)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    correo character varying(100) NOT NULL,
    contrasena character varying(255) NOT NULL,
    rol_id integer NOT NULL,
    estado boolean DEFAULT true,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    token character varying(255)
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17440)
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
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 247
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4775 (class 2604 OID 17510)
-- Name: detalle_pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos ALTER COLUMN id SET DEFAULT nextval('public.detalle_pedidos_id_seq'::regclass);


--
-- TOC entry 4776 (class 2604 OID 17509)
-- Name: distribuidores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores ALTER COLUMN id SET DEFAULT nextval('public.distribuidores_id_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 17508)
-- Name: facturas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas ALTER COLUMN id SET DEFAULT nextval('public.facturas_id_seq'::regclass);


--
-- TOC entry 4781 (class 2604 OID 17511)
-- Name: formulaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones ALTER COLUMN id SET DEFAULT nextval('public.formulaciones_id_seq'::regclass);


--
-- TOC entry 4782 (class 2604 OID 17512)
-- Name: gestion_colaboradores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores ALTER COLUMN id SET DEFAULT nextval('public.planilla_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 17656)
-- Name: horarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios ALTER COLUMN id SET DEFAULT nextval('public.horarios_id_seq'::regclass);


--
-- TOC entry 4784 (class 2604 OID 17513)
-- Name: inventario_materias_primas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_materias_primas ALTER COLUMN id SET DEFAULT nextval('public.inventario_materias_primas_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 17514)
-- Name: inventario_productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_productos ALTER COLUMN id SET DEFAULT nextval('public.inventario_productos_id_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 17515)
-- Name: notificaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones ALTER COLUMN id SET DEFAULT nextval('public.notificaciones_id_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 17516)
-- Name: pagos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos ALTER COLUMN id SET DEFAULT nextval('public.pagos_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 17517)
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- TOC entry 4798 (class 2604 OID 17518)
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- TOC entry 4801 (class 2604 OID 17519)
-- Name: reportes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes ALTER COLUMN id SET DEFAULT nextval('public.reportes_id_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 17435)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4803 (class 2604 OID 17520)
-- Name: solicitudes_vacaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones ALTER COLUMN id SET DEFAULT nextval('public.solicitudes_vacaciones_id_seq'::regclass);


--
-- TOC entry 4806 (class 2604 OID 17444)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5019 (class 0 OID 17343)
-- Dependencies: 217
-- Data for Name: detalle_pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_pedidos (id, pedido_id, producto_id, cantidad, precio_unitario) FROM stdin;
\.


--
-- TOC entry 5021 (class 0 OID 17347)
-- Dependencies: 219
-- Data for Name: distribuidores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.distribuidores (id, usuario_id, empresa, telefono, direccion, zona_cobertura, fecha_registro, estado) FROM stdin;
\.


--
-- TOC entry 5023 (class 0 OID 17354)
-- Dependencies: 221
-- Data for Name: facturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facturas (id, pedido_id, numero_factura, fecha_emision, total, archivo_pdf) FROM stdin;
\.


--
-- TOC entry 5025 (class 0 OID 17359)
-- Dependencies: 223
-- Data for Name: formulaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formulaciones (id, producto_terminado_id, materia_prima_id, cantidad_utilizada) FROM stdin;
\.


--
-- TOC entry 5027 (class 0 OID 17363)
-- Dependencies: 225
-- Data for Name: gestion_colaboradores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gestion_colaboradores (id, usuario_id, cargo, fecha_ingreso, estado, horario_id) FROM stdin;
\.


--
-- TOC entry 5028 (class 0 OID 17366)
-- Dependencies: 226
-- Data for Name: gestion_error; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gestion_error (id, usuario_id, fecha, accion, mensaje, estado) FROM stdin;
\.


--
-- TOC entry 5052 (class 0 OID 17653)
-- Dependencies: 250
-- Data for Name: horarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.horarios (id, descripcion) FROM stdin;
1	Lunes-Viernes 9am-6pm
2	Lunes-Viernes 7am-4pm
\.


--
-- TOC entry 5030 (class 0 OID 17372)
-- Dependencies: 228
-- Data for Name: inventario_materias_primas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario_materias_primas (id, producto_id, cantidad_disponible, fecha_actualizacion) FROM stdin;
\.


--
-- TOC entry 5032 (class 0 OID 17378)
-- Dependencies: 230
-- Data for Name: inventario_productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario_productos (id, producto_id, cantidad_disponible, fecha_actualizacion) FROM stdin;
\.


--
-- TOC entry 5034 (class 0 OID 17384)
-- Dependencies: 232
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notificaciones (id, usuario_id, mensaje, tipo, leido, fecha) FROM stdin;
\.


--
-- TOC entry 5036 (class 0 OID 17393)
-- Dependencies: 234
-- Data for Name: pagos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pagos (id, proveedor, monto, fecha_pago, descripcion, estado, comprobante) FROM stdin;
\.


--
-- TOC entry 5038 (class 0 OID 17401)
-- Dependencies: 236
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id, distribuidor_id, fecha_pedido, estado, total, comprobante_pago, factura_generada) FROM stdin;
\.


--
-- TOC entry 5041 (class 0 OID 17409)
-- Dependencies: 239
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id, nombre, descripcion, precio, stock, tipo, fecha_creacion) FROM stdin;
\.


--
-- TOC entry 5043 (class 0 OID 17418)
-- Dependencies: 241
-- Data for Name: reportes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reportes (id, usuario_id, modulo, accion, fecha) FROM stdin;
\.


--
-- TOC entry 5048 (class 0 OID 17432)
-- Dependencies: 246
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nombre) FROM stdin;
1	Administrador
2	Gerente de planta
3	Distribuidor
4	Colaborador de planta
5	Usuario
\.


--
-- TOC entry 5045 (class 0 OID 17425)
-- Dependencies: 243
-- Data for Name: solicitudes_vacaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.solicitudes_vacaciones (id, usuario_id, fecha_inicio, fecha_fin, estado, fecha_solicitud) FROM stdin;
\.


--
-- TOC entry 5050 (class 0 OID 17441)
-- Dependencies: 248
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, correo, contrasena, rol_id, estado, fecha_creacion, token) FROM stdin;
2	Jose	jose@gmail.com	$2b$10$P5Gzj6x7qi5i8v68TxMwH.XScWGJQtkzShcOe651g99tOnn/Nb4x2	5	t	2025-02-17 04:06:52.862	dffepndqeb1ik91cplt
\.


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 218
-- Name: detalle_pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_pedidos_id_seq', 1, false);


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 220
-- Name: distribuidores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.distribuidores_id_seq', 1, false);


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 222
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_id_seq', 1, false);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 224
-- Name: formulaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formulaciones_id_seq', 1, false);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 227
-- Name: gestion_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gestion_error_id_seq', 1, false);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 249
-- Name: horarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.horarios_id_seq', 2, true);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 229
-- Name: inventario_materias_primas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_materias_primas_id_seq', 1, false);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 231
-- Name: inventario_productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_productos_id_seq', 1, false);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 233
-- Name: notificaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificaciones_id_seq', 1, false);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 235
-- Name: pagos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pagos_id_seq', 1, false);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 237
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 1, false);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 238
-- Name: planilla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planilla_id_seq', 1, false);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 240
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_seq', 1, false);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 242
-- Name: reportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reportes_id_seq', 1, false);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 245
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 5, true);


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 244
-- Name: solicitudes_vacaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitudes_vacaciones_id_seq', 1, false);


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 247
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 2, true);


--
-- TOC entry 4816 (class 2606 OID 17552)
-- Name: detalle_pedidos detalle_pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4818 (class 2606 OID 17554)
-- Name: distribuidores distribuidores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 2606 OID 17556)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 4822 (class 2606 OID 17558)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 17560)
-- Name: formulaciones formulaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones
    ADD CONSTRAINT formulaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 17562)
-- Name: gestion_error gestion_error_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_error
    ADD CONSTRAINT gestion_error_pkey PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2606 OID 17660)
-- Name: horarios horarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios
    ADD CONSTRAINT horarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4832 (class 2606 OID 17564)
-- Name: inventario_materias_primas inventario_materias_primas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_materias_primas
    ADD CONSTRAINT inventario_materias_primas_pkey PRIMARY KEY (id);


--
-- TOC entry 4834 (class 2606 OID 17566)
-- Name: inventario_productos inventario_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_productos
    ADD CONSTRAINT inventario_productos_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 17568)
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4839 (class 2606 OID 17570)
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 17572)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 17574)
-- Name: gestion_colaboradores planilla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 17576)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 17578)
-- Name: reportes reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);


--
-- TOC entry 4850 (class 2606 OID 17439)
-- Name: roles roles_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key UNIQUE (nombre);


--
-- TOC entry 4852 (class 2606 OID 17437)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 17580)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4854 (class 2606 OID 17450)
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- TOC entry 4856 (class 2606 OID 17448)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4823 (class 1259 OID 17581)
-- Name: idx_facturas_pedido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_pedido ON public.facturas USING btree (pedido_id);


--
-- TOC entry 4830 (class 1259 OID 17582)
-- Name: idx_inventario_producto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventario_producto ON public.inventario_materias_primas USING btree (producto_id);


--
-- TOC entry 4837 (class 1259 OID 17583)
-- Name: idx_pagos_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pagos_proveedor ON public.pagos USING btree (proveedor);


--
-- TOC entry 4840 (class 1259 OID 17584)
-- Name: idx_pedidos_distribuidor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_distribuidor ON public.pedidos USING btree (distribuidor_id);


--
-- TOC entry 4859 (class 2606 OID 17585)
-- Name: detalle_pedidos detalle_pedidos_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4860 (class 2606 OID 17590)
-- Name: detalle_pedidos detalle_pedidos_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4861 (class 2606 OID 17595)
-- Name: distribuidores distribuidores_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distribuidores
    ADD CONSTRAINT distribuidores_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4862 (class 2606 OID 17600)
-- Name: facturas facturas_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 17666)
-- Name: gestion_colaboradores fk_horario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT fk_horario FOREIGN KEY (horario_id) REFERENCES public.horarios(id);


--
-- TOC entry 4873 (class 2606 OID 17451)
-- Name: usuarios fk_usuarios_roles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuarios_roles FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON DELETE SET NULL;


--
-- TOC entry 4863 (class 2606 OID 17605)
-- Name: formulaciones formulaciones_materia_prima_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones
    ADD CONSTRAINT formulaciones_materia_prima_id_fkey FOREIGN KEY (materia_prima_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4864 (class 2606 OID 17610)
-- Name: formulaciones formulaciones_producto_terminado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formulaciones
    ADD CONSTRAINT formulaciones_producto_terminado_id_fkey FOREIGN KEY (producto_terminado_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4867 (class 2606 OID 17615)
-- Name: inventario_materias_primas inventario_materias_primas_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_materias_primas
    ADD CONSTRAINT inventario_materias_primas_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4868 (class 2606 OID 17620)
-- Name: inventario_productos inventario_productos_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_productos
    ADD CONSTRAINT inventario_productos_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- TOC entry 4869 (class 2606 OID 17625)
-- Name: notificaciones notificaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4870 (class 2606 OID 17630)
-- Name: pedidos pedidos_distribuidor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_distribuidor_id_fkey FOREIGN KEY (distribuidor_id) REFERENCES public.distribuidores(id) ON DELETE SET NULL;


--
-- TOC entry 4866 (class 2606 OID 17635)
-- Name: gestion_colaboradores planilla_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gestion_colaboradores
    ADD CONSTRAINT planilla_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4871 (class 2606 OID 17640)
-- Name: reportes reportes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reportes
    ADD CONSTRAINT reportes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4872 (class 2606 OID 17645)
-- Name: solicitudes_vacaciones solicitudes_vacaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes_vacaciones
    ADD CONSTRAINT solicitudes_vacaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


-- Completed on 2025-02-16 22:08:52

--
-- PostgreSQL database dump complete
--

