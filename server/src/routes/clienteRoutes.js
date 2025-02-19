import express from 'express';
import { getCliente, insertCliente, updateCliente, cambiarClienteEstado, rendUpdateCliente } from '../controllers/clienteController.js';

const router = express.Router();

router.get('/cliente', getCliente);

router.post('/agregar1', insertCliente);

router.get('/clienteAgregar', (req, res) => {
    res.render('clientesAgregar', { layout: 'layouts/layout' });
});

router.get('/clienteEditar/:id', rendUpdateCliente);

router.post('/actualizar1/:id', updateCliente);

router.post('/eliminar1/:id', cambiarClienteEstado);

export default router;
