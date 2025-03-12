import express from "express";
import { 
  insertPedido, 
  getPedido, 
  updatePedido, 
  deletePedido, 
  rendUpdatePedido, 
  rendAgregarPedido 
} from "../controllers/pedidoController.js";

const router = express.Router();

// Ruta para agregar un pedido
router.post("/pedido/agregar", insertPedido);

// Ruta para obtener todos los pedidos
router.get("/pedido", getPedido);

// Ruta para actualizar un pedido
router.put("/pedido/:id", updatePedido);

// Ruta para eliminar un pedido
router.delete("/pedido/:id", deletePedido);

// Ruta para renderizar la vista de edición de un pedido
router.get("/pedido/editar/:id", rendUpdatePedido);

// Ruta para renderizar la vista de agregar un pedido
router.get("/pedido/agregar", rendAgregarPedido);

export default router;
