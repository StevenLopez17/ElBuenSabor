import express from 'express';
import {
    insertMateriaPrima,
    getMateriaPrima,
    updateMateriaPrima,
    deleteMateriaPrima,
    rendUpdateMateriaPrima,
    rendAgregarMateriaPrima
} from '../controllers/materiaPrimaController.js';

const router = express.Router();

// Increase max listeners limit
import { EventEmitter } from 'events';
EventEmitter.defaultMaxListeners = 15;

router.post("/materiaPrima/agregar", insertMateriaPrima); // Correct POST route for adding
router.get("/materiaPrima", getMateriaPrima);
router.post("/materiaPrima/:id", updateMateriaPrima); // Correct POST route for updating
router.delete("/materiaPrima/:id", deleteMateriaPrima);
router.get("/materiaPrima/editar/:id", rendUpdateMateriaPrima);
router.get("/materiaPrima/agregar", rendAgregarMateriaPrima);

export default router;
