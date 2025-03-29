import express from 'express';
import {
  getReportePedidosPorProducto,
  exportarPDFPedidosPorProducto
} from '../controllers/reportesController.js';

const router = express.Router();

// Ruta principal que muestra el reporte y maneja descarga si se pasa ?pdf=true
router.get('/reportes', async (req, res, next) => {
  if (req.query.pdf === 'true') {
    return exportarPDFPedidosPorProducto(req, res);
  }
  return getReportePedidosPorProducto(req, res);
});

// Exportar PDF: pedidos por producto
router.get('/reportes/pedidos-producto/pdf', exportarPDFPedidosPorProducto);

export default router;
