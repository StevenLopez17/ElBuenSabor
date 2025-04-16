import express from 'express';
import {
  getReportePedidosPorProducto,
  exportarPDFPedidosPorProducto
} from '../controllers/reportesController.js';
import obtenerUsuarioJWT from '../../helpers/obtenerDatosJWT.js';

const router = express.Router();

// Ruta principal con selector de tipo de reporte (?tipo=producto | distribuidor)
router.get('/reportes', async (req, res) => {
  const tipo = req.query.tipo || 'producto';

  const { _token } = req.cookies;

  if (!_token) {
    return res.redirect('/login');
  }

  const datosUsuario = obtenerUsuarioJWT(_token);

  if (datosUsuario.rol != 1) res.redirect('/');

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
