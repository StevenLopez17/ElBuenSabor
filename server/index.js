import express from 'express'
import dotenv from 'dotenv';
import path from 'path';
import ejsLayouts from 'express-ejs-layouts';
import { fileURLToPath } from 'url';
import loginRoutes from './src/routes/loginRoutes.js'

const app = express();

dotenv.config();

// EJS engine
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.set('view engine', 'ejs');

app.set('views', path.join(__dirname, '..', 'views'));

app.use(ejsLayouts);
app.set('layout', 'layouts/layout');

app.use(express.static(path.join(__dirname, '..', 'public')));

const PORT = process.env.PORT || 3000;


// Home
app.get('/', (req, res) => {
    res.render('index', { title: 'Mi página El Buen Sabor' });
});


app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});


