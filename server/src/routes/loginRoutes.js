import express from 'express'
import { getUsuario, insertUsuario, profileView } from '../controllers/userController.js';
import identificarUsuario from '../../middleware/identificarUsuario.js';

const router = express.Router()

router.post('/login', getUsuario);

router.get('/registro', (req, res) => {
    res.render('registro', {
        layout: false
    })
});

router.post('/registro', insertUsuario);


router.get('/profile',
    identificarUsuario,
    profileView)

export default router

