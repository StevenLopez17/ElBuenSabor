import express from 'express';
import dotenv from 'dotenv';
import path from 'path';
import ejsLayouts from 'express-ejs-layouts';
import { fileURLToPath } from 'url';
import loginRoutes from './src/routes/loginRoutes.js';
import distribuidorRoutes from './src/routes/distribuidorRoutes.js';
import colaboradorRoutes from './src/routes/colaboradorRoutes.js'
import db from './src/models/main.js';

const app = express();
dotenv.config();

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

//Home
app.get('/', (req, res) => {
    res.render('index');
});

app.get('/login', (req, res) => {
    res.render('login', { layout: false })
});

app.use('/', loginRoutes);


//Rutas Distribuidores

app.use('/', distribuidorRoutes);

app.get('/distAgregar', (req, res) => {
    res.render('distribuidoresAgregar', { layout: 'layouts/layout' });
});

app.get('/distEditar/:id', (req, res) => {
    res.render('distribuidoresEditar', { layout: 'layouts/layout' });
});



//Rutas Colaboradores
app.use('/', colaboradorRoutes);

app.get('/colabEditar/:id', (req, res) => {
    res.render('colaboradoresEditar');
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
