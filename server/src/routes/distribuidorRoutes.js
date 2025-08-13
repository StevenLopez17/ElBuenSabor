import express from 'express';
import {
  insertDistribuidor,
  rendInsertDistribuidor,
  getDistribuidor,
  updateDistribuidor,
  rendUpdateDistribuidor,
  cambiarDistribuidorEstado,
  filtroDireccionDistribuidores,
  exportarPDFDist,
  exportarExcelDist
} from '../controllers/distribuidorController.js';
import identificarUsuario from '../../middleware/identificarUsuario.js';

const router = express.Router();

router.get('/distribuidor', identificarUsuario, getDistribuidor);
router.get('/distAgregar', identificarUsuario, rendInsertDistribuidor);
router.post('/agregar', insertDistribuidor);
router.post('/distEditar', rendUpdateDistribuidor);
router.get('/distEditar/:id', rendUpdateDistribuidor);
router.post('/actualizar/:id', updateDistribuidor);
router.post('/eliminar/:id', cambiarDistribuidorEstado);
router.get('/filtrarDireccion', filtroDireccionDistribuidores);
router.get('/exportarPDF', exportarPDFDist);
router.get('/exportarExcel', exportarExcelDist);

export default router;