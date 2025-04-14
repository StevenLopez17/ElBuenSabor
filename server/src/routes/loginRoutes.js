import express from 'express'
import { getUsuario, insertUsuario, profileView, updatePassword, cerrarSesion, subirImagenPerfil } from '../controllers/userController.js';
import identificarUsuario from '../../middleware/identificarUsuario.js';
import Rol from '../models/rol.js'
import multer from 'multer';

const router = express.Router()

const upload = multer({ storage: multer.memoryStorage() });

router.get('/login', (req, res) => {
    let success = [];
    let errores = [];
    res.render('login', { layout: false, errores, success })
});

router.post('/login', getUsuario);

router.get('/registro', async (req, res) => {
    let success = [];
    let errores = [];
    const roles = await Rol.findAll();
    res.render('auth/registro', { layout: false, errores, success, roles })
});

router.post('/registro', insertUsuario);

router.get('/profile', identificarUsuario, profileView)

router.get('/updateUsuario', (req, res) => {
    let success = [];
    let errores = [];
    res.render('auth/updateUsuario', { layout: false, errores, success })
});


router.post('/updateUsuario', updatePassword)

router.get('/logout', cerrarSesion)

router.post('/usuarios/:id/imagen', upload.single('imagenPerfil'), subirImagenPerfil);

export default router;

