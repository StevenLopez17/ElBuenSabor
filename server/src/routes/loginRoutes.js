import express from 'express'
import { getUsuario, insertUsuario } from '../controllers/userController.js';

const router = express.Router()

router.post('/login', getUsuario);

router.get('/registro', (req, res) => {
    res.render('registro', {
        layout: false
    })
});

router.post('/registro', insertUsuario);



export default router

