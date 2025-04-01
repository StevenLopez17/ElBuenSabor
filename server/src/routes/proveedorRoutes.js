import express from 'express';
import {
  insertProveedor,
  getProveedores,
  updateProveedor,
  rendUpdateProveedor,
  cambiarProveedorEstado,
  rendInsertProveedor
} from '../controllers/proveedorController.js';

const router = express.Router();

// Cambiar las rutas para que sean relativas a '/proveedores'
router.get('/agregar', rendInsertProveedor);
router.post('/agregar', insertProveedor);
router.get('/', getProveedores);
router.get('/editar/:id', rendUpdateProveedor);
router.post('/editar/:id', updateProveedor);
router.post('/estado/:id', cambiarProveedorEstado);

export default router;
