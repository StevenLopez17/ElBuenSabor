import express from 'express';
import dotenv from 'dotenv';
import path from 'path';
import ejsLayouts from 'express-ejs-layouts';
import { fileURLToPath } from 'url';
import loginRoutes from './src/routes/loginRoutes.js';

//IMPORT DE LA CONEXIÓN CON BASE DE DATOS
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

const PORT = process.env.PORT || 3000;

//CONEXIÓN A LA BASE DE DATOS (SIN ALTERAR LAS TABLAS)
db.sequelize.authenticate()
    .then(() => console.log('Conexión exitosa con PostgreSQL'))
    .catch(err => console.error('Error de conexión a la BD:', err));

//Home
app.get('/', (req, res) => {
    res.render('index', { title: 'Mi página El Buen Sabor' });
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
