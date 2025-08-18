# El Buen Sabor - Sistema Administrativo y de Ventas

## Desarrolladores

Este proyecto fue desarrollado por los estudiantes:

- **Ronald Josue Calderon Barrantes**
- **Vladimir Conejo Oviedo**
- **Andres Jimenez Solis**

---

## 📋 Descripción del Proyecto

El Buen Sabor es un sistema administrativo y de ventas completo diseñado para gestionar una empresa de alimentos. El sistema permite administrar todos los aspectos del negocio, desde la gestión de clientes y productos hasta el control de pedidos y reportes financieros.

## 🚀 Características Principales

### Gestión de Usuarios y Autenticación
- Sistema de login con JWT
- Control de roles y permisos
- Gestión de perfiles de usuario

### Gestión de Clientes
- Registro y edición de clientes
- Historial de pedidos por cliente
- Información de contacto y ubicación

### Gestión de Productos
- Catálogo de productos
- Control de inventario
- Gestión de formulaciones y recetas

### Gestión de Pedidos
- Creación y seguimiento de pedidos
- Estados de entrega y pago
- Historial completo de transacciones

### Gestión de Distribuidores
- Registro y verificación de distribuidores
- Control de entregas
- Gestión de comisiones

### Gestión de Colaboradores
- Registro de empleados
- Control de horarios
- Solicitudes de vacaciones

### Gestión de Proveedores y Materia Prima
- Control de proveedores
- Gestión de materia prima
- Seguimiento de costos

### Sistema de Pagos
- Gestión de pagos pendientes
- Estados de aprobación
- Reportes financieros

### Reportes y Analytics
- Reportes de ventas
- Análisis de rendimiento
- Exportación a Excel y PDF

## 🛠️ Tecnologías Utilizadas

### Backend
- **Node.js** - Runtime de JavaScript
- **Express.js** - Framework web
- **Sequelize** - ORM para PostgreSQL
- **PostgreSQL** - Base de datos principal
- **Supabase** - Base de datos en la nube
- **JWT** - Autenticación y autorización
- **bcrypt** - Encriptación de contraseñas
- **multer** - Manejo de archivos
- **nodemailer** - Envío de correos electrónicos

### Frontend
- **EJS** - Motor de plantillas
- **Bootstrap** - Framework CSS
- **jQuery** - Biblioteca JavaScript
- **ApexCharts** - Gráficos y visualizaciones
- **Bootstrap Icons** - Iconografía

### Herramientas de Desarrollo
- **nodemon** - Reinicio automático del servidor
- **dotenv** - Variables de entorno
- **express-validator** - Validación de datos
- **pdfmake** - Generación de PDFs
- **exceljs** - Generación de reportes Excel

## 📦 Instalación

### Prerrequisitos
- Node.js (versión 16 o superior)
- PostgreSQL (versión 12 o superior)
- npm o yarn

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/rjwrld/ElBuenSabor.git
   cd ElBuenSabor
   ```

2. **Instalar dependencias**
   ```bash
   npm install
   ```

3. **Configurar variables de entorno**
   ```bash
   cp .env.example .env
   ```
   
   Editar el archivo `.env` con tus configuraciones:
   ```env
   PORT=3000
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=el_buen_sabor
   DB_USER=tu_usuario
   DB_PASSWORD=tu_contraseña
   JWT_SECRET=tu_secreto_jwt
   SUPABASE_URL=tu_url_supabase
   SUPABASE_KEY=tu_clave_supabase
   ```

4. **Configurar la base de datos**
   ```bash
   # Crear la base de datos
   createdb el_buen_sabor
   
   # Ejecutar el script de configuración
   psql -d el_buen_sabor -f database_setup.sql
   ```

5. **Iniciar el servidor**
   ```bash
   # Modo desarrollo
   npm run server
   
   # Modo producción
   npm start
   ```

## 🚀 Uso

### Acceso al Sistema
1. Abrir el navegador y dirigirse a `http://localhost:3000`
2. Iniciar sesión con las credenciales proporcionadas
3. Navegar por los diferentes módulos según los permisos del usuario

### Roles de Usuario
- **Administrador**: Acceso completo a todos los módulos
- **Distribuidor**: Gestión de pedidos y clientes asignados
- **Colaborador**: Acceso limitado según permisos específicos

## 📁 Estructura del Proyecto

```
ElBuenSabor/
├── server/                 # Código del servidor
│   ├── config/            # Configuraciones
│   ├── controllers/       # Controladores
│   ├── models/           # Modelos de datos
│   ├── routes/           # Rutas de la aplicación
│   ├── middleware/       # Middlewares personalizados
│   └── helpers/          # Funciones auxiliares
├── views/                # Plantillas EJS
│   ├── layouts/          # Layouts principales
│   ├── partials/         # Componentes reutilizables
│   └── [módulos]/        # Vistas por módulo
├── public/               # Archivos estáticos
│   ├── css/             # Hojas de estilo
│   ├── js/              # Scripts del cliente
│   └── images/          # Imágenes
└── database_setup.sql   # Script de configuración de BD
```

## 🔧 Configuración de Desarrollo

### Scripts Disponibles
- `npm start` - Inicia el servidor en modo producción
- `npm run server` - Inicia el servidor en modo desarrollo con nodemon

### Variables de Entorno
- `PORT` - Puerto del servidor (default: 3000)
- `DB_HOST` - Host de la base de datos
- `DB_PORT` - Puerto de la base de datos
- `DB_NAME` - Nombre de la base de datos
- `DB_USER` - Usuario de la base de datos
- `DB_PASSWORD` - Contraseña de la base de datos
- `JWT_SECRET` - Secreto para JWT
- `SUPABASE_URL` - URL de Supabase
- `SUPABASE_KEY` - Clave de Supabase

## 📊 Base de Datos

El sistema utiliza PostgreSQL como base de datos principal con las siguientes tablas principales:

- **usuarios** - Gestión de usuarios y autenticación
- **clientes** - Información de clientes
- **productos** - Catálogo de productos
- **pedidos** - Gestión de pedidos
- **distribuidores** - Información de distribuidores
- **colaboradores** - Gestión de empleados
- **proveedores** - Información de proveedores
- **materia_prima** - Control de inventario
- **pagos** - Gestión de pagos
- **formulaciones** - Recetas y formulaciones

## 🔒 Seguridad

- Autenticación mediante JWT
- Encriptación de contraseñas con bcrypt
- Validación de datos en el servidor
- Control de acceso basado en roles
- Middleware de verificación de permisos

## 📈 Reportes

El sistema incluye funcionalidades de reportes:
- Exportación a Excel
- Generación de PDFs
- Gráficos y estadísticas
- Reportes de ventas y rendimiento

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia ISC. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Para soporte técnico o preguntas sobre el proyecto, contactar a los desarrolladores:

- Ronald Josue Calderon Barrantes
- Vladimir Conejo Oviedo
- Andres Jimenez Solis

---

**El Buen Sabor** - Sistema Administrativo y de Ventas © 2024





