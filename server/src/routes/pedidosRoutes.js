import express from "express";
import {
  insertPedido,
  getPedido,
  updatePedido,
  deletePedido,
  rendUpdatePedido,
  rendAgregarPedido,
  getTodosPedidos,
  exportarPDFPedido,
  notificarPagoPendiente,
  subirComprobantePago
} from "../controllers/pedidoController.js";
import identificarUsuario from '../../middleware/identificarUsuario.js';
import multer from 'multer';

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

// Ruta para agregar un pedido
router.post("/pedido/agregar", insertPedido);

// Ruta para obtener todos los pedidos
router.get("/pedido", identificarUsuario, getPedido);

// Ruta para actualizar un pedido - CAMBIADO DE PUT A POST para compatibilidad con formularios HTML
router.post("/pedido/:id", updatePedido);

// Ruta para eliminar un pedido
router.delete("/pedido/:id", deletePedido);

// Ruta para renderizar la vista de edición de un pedido
router.get("/pedido/editar/:id", rendUpdatePedido);

// Ruta para renderizar la vista de agregar un pedido
router.get("/pedido/agregar", identificarUsuario, rendAgregarPedido);

// Ruta para obtener todos los pedidos sin filtro
router.get("/pedidos/todos", identificarUsuario, getTodosPedidos);

// Ruta para subir comprobante de pago
router.post("/pedido/:id/comprobante", upload.single('imagenComprobante'), subirComprobantePago);

//Ruta para obtener factura
router.get('/exportarPDFP/:id', exportarPDFPedido);

// Ruta notificacion pago pendiente
router.get('/pedido/notificar/:idpedido', notificarPagoPendiente);

export default router;
