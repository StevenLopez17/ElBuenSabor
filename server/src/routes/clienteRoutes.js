import express from 'express';
import { getCliente, insertCliente, updateCliente, cambiarClienteEstado, rendUpdateCliente, rendInsertCliente} from '../controllers/clienteController.js';

const router = express.Router();

router.get('/cliente', getCliente);

router.post('/agregar1', insertCliente);

router.get('/clienteAgregar',rendInsertCliente);

router.get('/clienteEditar/:id', rendUpdateCliente);

router.post('/actualizar1/:id', updateCliente);

router.post('/eliminar1/:id', cambiarClienteEstado);

export default router;
