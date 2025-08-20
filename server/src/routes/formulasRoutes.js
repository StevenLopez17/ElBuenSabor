import express from 'express';
import { index, create, store, show, edit, update, destroy } from '../controllers/formulasController.js';

const router = express.Router();

// GET /formulas - Listar fórmulas
router.get('/formulas', index);

// GET /formulas/create - Formulario de creación
router.get('/formulas/create', create);

// POST /formulas - Crear fórmula
router.post('/formulas', store);

// GET /formulas/:id - Detalles de fórmula
router.get('/formulas/:id', show);

// GET /formulas/:id/edit - Formulario de edición
router.get('/formulas/:id/edit', edit);

// POST /formulas/:id - Actualizar fórmula (usando POST en lugar de PUT para compatibilidad con formularios HTML)
router.post('/formulas/:id', update);

// POST /formulas/:id/delete - Eliminar fórmula
router.post('/formulas/:id/delete', destroy);

export default router;
