import express from 'express';
import {
  getReportePedidosPorProducto,
  exportarPDFPedidosPorProducto
} from '../controllers/reportesController.js';

const router = express.Router();

// Ruta principal con selector de tipo de reporte (?tipo=producto | distribuidor)
router.get('/reportes', async (req, res) => {
  const tipo = req.query.tipo || 'producto';

  if (tipo === 'producto') {
    return getReportePedidosPorProducto(req, res);
  } else if (tipo === 'distribuidor') {
    return getReportePedidosPorDistribuidor(req, res);
  } else {
    return res.status(400).send('Tipo de reporte inválido');
  }
});

// Exportaciones PDF (podrían ir por separado si deseas)
router.get('/reportes/pedidos-producto/pdf', exportarPDFPedidosPorProducto);
// (Más adelante puedes agregar: exportarPDFPedidosPorDistribuidor)
export default router;
