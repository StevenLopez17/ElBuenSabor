import express from "express";
import { insertMateriaPrima, getMateriaPrima, updateMateriaPrima, deleteMateriaPrima, rendUpdateMateriaPrima, rendAgregarMateriaPrima } from "../controllers/materiaPrimaController.js";

const router = express.Router();

router.post("/materiaPrima", insertMateriaPrima);
router.get("/materiaPrima", getMateriaPrima);
router.put("/materiaPrima/:id", updateMateriaPrima);
router.delete("/materiaPrima/:id", deleteMateriaPrima);
router.get("/materiaPrima/editar/:id", rendUpdateMateriaPrima);
router.get("/materiaPrima/agregar", rendAgregarMateriaPrima);

export default router;
