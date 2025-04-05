import express from 'express';


import {
  insertPago,
  getPagos,
  updatePago,
  rendUpdatePago,
  rendInsertPago
} from '../controllers/pagoController.js';

const router = express.Router();

// Ruta para renderizar la vista de agregar un pago
router.get('/agregar', rendInsertPago);

// Ruta para registrar un nuevo pago
router.post('/agregar', insertPago);

// Ruta para obtener y renderizar la lista de pagos
router.get('/', getPagos);

// Ruta para renderizar la vista de edición de un pago
router.get('/editar/:id', rendUpdatePago);

// Ruta para actualizar un pago existente
router.post('/editar/:id', updatePago);

export default router;