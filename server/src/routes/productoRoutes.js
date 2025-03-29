import express from "express";
import { 
  insertProducto, 
  getProducto, 
  updateProducto, 
  deleteProducto, 
  rendUpdateProducto, 
  rendAgregarProducto 
} from "../controllers/productoController.js";

const router = express.Router();

// Ruta para agregar un producto
router.post("/producto/agregar", insertProducto);

// Ruta para obtener todos los productos
router.get("/producto", getProducto);

// Ruta para actualizar un producto
router.post("/producto/:id", updateProducto);

// Ruta para eliminar un producto
router.delete("/producto/:id", deleteProducto);

// Ruta para renderizar la vista de edición de un producto
router.get("/producto/editar/:id", rendUpdateProducto);

// Ruta para renderizar la vista de agregar un producto
router.get("/producto/agregar", rendAgregarProducto);

export default router;
