import express from 'express';
import {
  insertDistribuidor,
  getDistribuidor,
  updateDistribuidor,
  rendUpdateDistribuidor,
  cambiarDistribuidorEstado,
  filtroDireccionDistribuidores,
  exportarPDFDist,
  exportarExcelDist
} from '../controllers/distribuidorController.js';

const router = express.Router();

router.get('/distribuidor', getDistribuidor);
router.post('/agregar', insertDistribuidor);
router.get('/distEditar/:id', rendUpdateDistribuidor);
router.post('/actualizar/:id', updateDistribuidor);
router.post('/eliminar/:id', cambiarDistribuidorEstado);
router.get('/filtrarDireccion', filtroDireccionDistribuidores);
router.get('/exportarPDF', exportarPDFDist);
router.get('/exportarExcel', exportarExcelDist);

export default router;