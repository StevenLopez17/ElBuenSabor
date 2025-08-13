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
  subirComprobantePago,
  getHistorialPedidos,
  aprobarPedido
} from "../controllers/pedidoController.js";
import identificarUsuario from '../../middleware/identificarUsuario.js';
import multer from 'multer';
import Distribuidores from '../models/distribuidorModel.js';

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

// Ruta para agregar un pedido
router.post("/pedido/agregar", identificarUsuario, insertPedido);

// Ruta para obtener todos los pedidos
router.get("/pedido", identificarUsuario, getPedido);

// Ruta para actualizar un pedido - CAMBIADO DE PUT A POST para compatibilidad con formularios HTML
router.post("/pedido/:id", identificarUsuario, upload.none(), updatePedido);

// Ruta para eliminar un pedido
router.delete("/pedido/:id", identificarUsuario, deletePedido);

// Ruta para renderizar la vista de edición de un pedido
router.get("/pedido/editar/:id", identificarUsuario, rendUpdatePedido);

// Ruta para renderizar la vista de agregar un pedido
router.get("/pedido/agregar", identificarUsuario, rendAgregarPedido);

// Ruta para obtener todos los pedidos sin filtro
router.get("/pedidos/todos", identificarUsuario, getTodosPedidos);

// Ruta para obtener historial completo de pedidos
router.get("/pedidos/historial", identificarUsuario, getHistorialPedidos);

// Ruta para subir comprobante de pago
router.post("/pedido/:id/comprobante", identificarUsuario, upload.single('imagenComprobante'), subirComprobantePago);

//Ruta para obtener factura
router.get('/exportarPDFP/:id', identificarUsuario, exportarPDFPedido);

// Ruta notificacion pago pendiente
router.get('/pedido/notificar/:idpedido', identificarUsuario, notificarPagoPendiente);

// Ruta para aprobar pedido
router.post('/pedido/:id/aprobar', identificarUsuario, aprobarPedido);

// Ruta temporal para debug de distribuidores
router.get('/debug/distribuidores', identificarUsuario, async (req, res) => {
  try {
    const { id, rol } = req.usuario;
    
    if (rol !== 3) {
      return res.json({ error: "Solo distribuidores pueden acceder a esta ruta" });
    }
    
    const distribuidor = await Distribuidores.findOne({
      where: { usuario_id: id }
    });
    
    res.json({
      usuario: {
        id: req.usuario.id,
        correo: req.usuario.correo,
        nombre: req.usuario.nombre,
        rol: req.usuario.rol
      },
      distribuidor: distribuidor ? {
        id: distribuidor.id,
        usuario_id: distribuidor.usuario_id,
        empresa: distribuidor.empresa,
        telefono: distribuidor.telefono
      } : null,
      existe: !!distribuidor
    });
  } catch (error) {
    console.error("Error en debug:", error);
    res.status(500).json({ error: error.message });
  }
});

// Ruta temporal para debug de distribuidores (mantener por compatibilidad)
router.get('/debug/verificar-distribuidores', identificarUsuario, async (req, res) => {
  try {
    const { rol } = req.usuario;
    
    if (rol !== 1) {
      return res.json({ error: "Solo administradores pueden acceder a esta ruta" });
    }
    
    // Redirigir al nuevo controlador
    const DistribuidorVerificacionController = (await import('../controllers/distribuidorVerificacionController.js')).default;
    return DistribuidorVerificacionController.crearDistribuidoresFaltantes(req, res);
    
  } catch (error) {
    console.error("Error en verificación:", error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
