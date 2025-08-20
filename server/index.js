import express from 'express';
import dotenv from 'dotenv';
import path from 'path';
import ejsLayouts from 'express-ejs-layouts';
import { fileURLToPath } from 'url';
import loginRoutes from './src/routes/loginRoutes.js';
import distribuidorRoutes from './src/routes/distribuidorRoutes.js';
import Distribuidores from './src/models/distribuidorModel.js';
import colaboradorRoutes from './src/routes/colaboradorRoutes.js';
import clienteRoutes from './src/routes/clienteRoutes.js'; // Import clienteRoutes
import materiaPrimaRoutes from './src/routes/materiaPrimaRoutes.js'; // Import materiaPrimaRoutes
import Clientes from './src/models/clienteModel.js'; // Import Clientes model
import db from './src/models/main.js';
import cookieParser from 'cookie-parser';
import sequelize from './config/database.js';
import productoRoutes from './src/routes/productoRoutes.js'; // Import productoRoutes
import horarioRoutes from './src/routes/horarioRoutes.js';
import formulacionRoutes from './src/routes/formulacionesRoutes.js';
import supabase from './config/supabaseClient.js';
import multer from 'multer';
import pedidosRoutes from './src/routes/pedidosRoutes.js'; // Import pedidosRoutes
import vacacionesRoutes from './src/routes/vacacionesRoutes.js';
import reportesRoutes from './src/routes/reportesRoutes.js';
import proveedorRoutes from './src/routes/proveedorRoutes.js';
import pagoRoutes from './src/routes/pagoRoutes.js'; // Importa las rutas de pagos
import indexRoutes from './src/routes/indexRoutes.js';
import distribuidorVerificacionRoutes from './src/routes/distribuidorVerificacionRoutes.js';
import formulasRoutes from './src/routes/formulasRoutes.js'; // Import formulas routes
import homeRoutes from './src/routes/homeRoutes.js'; // Import home routes
import Rol from './src/models/rol.js';

import identificarUsuario from './middleware/identificarUsuario.js';
import identificarUsuarioOptional from './middleware/identificarUsuarioOptional.js';
import { verificarAdmin, verificarAccesoModulo } from './middleware/verificarPermisos.js';
import errorLogger from './middleware/errorLogger.js';

const app = express();


app.use(cookieParser());

//EJS ENGINE
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.set('view engine', 'ejs');

app.set('views', path.join(__dirname, '..', 'views'));

app.use(ejsLayouts);

app.set('layout', 'layouts/layout');

app.use(express.static(path.join(__dirname, '..', 'public')));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const PORT = process.env.PORT || 3000;

//CONEXIÓN A LA BASE DE DATOS (SIN ALTERAR LAS TABLAS)
db.sequelize.authenticate()
    .then(() => console.log('Conexión exitosa con PostgreSQL'))
    .catch(err => console.error('Error de conexión a la BD:', err));

// CONFIGURACIÓN DE RUTAS

// Middleware de identificación opcional (para rutas públicas y privadas)
app.use(identificarUsuarioOptional);

// Rutas públicas (sin autenticación) - DEBEN IR PRIMERO
app.use('/', homeRoutes);

// Rutas de login/registro (sin autenticación)
app.use('/', loginRoutes);

// Middleware global que pasa el objeto usuario a todas las vistas
app.use(async (req, res, next) => {
    if (req.usuario) {
        // Si el usuario está identificado, obtener el nombre del rol
        try {
            const rol = await Rol.findOne({
                where: {
                    id: req.usuario.rol
                }
            });
            
            // Configurar las variables locales para todas las vistas
            res.locals.usuario = req.usuario;
            res.locals.rol_name = rol ? rol.nombre : 'Usuario';
        } catch (error) {
            console.error('Error al obtener el rol:', error);
            res.locals.usuario = req.usuario;
            res.locals.rol_name = 'Usuario';
        }
    }
    next();
});

// Rutas principales (requieren autenticación)
app.use('/', identificarUsuario, indexRoutes);

// Ruta de dashboard para usuarios autenticados
app.get('/dashboard', identificarUsuario, (req, res) => {
    res.redirect('/');
});

//Rutas Pedidos (accesible para todos los usuarios autenticados)
app.use('/', identificarUsuario, pedidosRoutes);

//Rutas Distribuidores (solo administradores)
app.use('/', verificarAdmin, distribuidorRoutes);

// Esta ruta está manejada por distribuidorRoutes.js
// app.get('/distEditar/:id', (req, res) => {
//     res.render('distribuidores/distribuidoresEditar', { layout: 'layouts/layout' });
// });



//Rutas Materia Prima (solo administradores)
app.use('/', verificarAdmin, materiaPrimaRoutes);

app.get('/materiaPrimaAgregar', verificarAdmin, (req, res) => {
    res.render('materiaPrimaAgregar', { layout: 'layouts/layout' });
});

app.get('/materiaPrima/editar/:id', verificarAdmin, (req, res) => {
    res.render('materiaPrimaEditar', { layout: 'layouts/layout' });
});

app.get('/insertar_materia_prima/:id', verificarAdmin, async (req, res) => {
    res.render('insertar_materia_prima', { layout: 'layouts/layout' });
});


//Rutas Colaboradores (solo administradores)
app.use('/', verificarAdmin, colaboradorRoutes);

app.get('/colabEditar/:id', verificarAdmin, (req, res) => {
    res.render('colaboradoresEditar');
});

//Rutas Clientes (solo administradores)
app.use('/', verificarAdmin, clienteRoutes);

app.get('/clienteAgregar', verificarAdmin, (req, res) => {
    res.render('clientes/clientesAgregar', { layout: 'layouts/layout' });
});

app.get('/clienteEditar/:id', verificarAdmin, async (req, res) => {
    try {
        const cliente = await Clientes.findByPk(req.params.id);
        if (cliente) {
            res.render('clientes/clientesEditar', { cliente, layout: 'layouts/layout' });
        } else {
            res.redirect('/');
        }
    } catch (error) {
        console.error('Error fetching client:', error);
        res.redirect('/');
    }
});

//Rutas Producto (solo administradores)
app.use('/', verificarAdmin, productoRoutes);

app.get('/producto/agregar', verificarAdmin, (req, res) => {
    res.render('productoAgregar', { layout: 'layouts/layout' });
});

app.get('/producto/editar/:id', verificarAdmin, (req, res) => {
    res.render('productoEditar', { layout: 'layouts/layout' });
});

// Rutas Horarios (solo administradores)
app.use('/', verificarAdmin, horarioRoutes);

//Rutas Formulaciones (solo administradores)
app.use('/', verificarAdmin, formulacionRoutes);

//Rutas Fórmulas nuevas (solo administradores)
app.use('/', verificarAdmin, formulasRoutes);

// Rutas Solicitudes Vacaciones (solo administradores)
app.use('/', verificarAdmin, vacacionesRoutes);

//Rutas Proveedores (solo administradores)
app.use('/proveedores', verificarAdmin, proveedorRoutes); // Add routes for proveedores
app.use('/pagos', verificarAdmin, pagoRoutes);
app.use('/admin/distribuidores', distribuidorVerificacionRoutes);
//Rutas de Reportes (solo administradores)
app.use('/', verificarAdmin, reportesRoutes);

//Middleware global para el manejo de errores
app.use(errorLogger);
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});



