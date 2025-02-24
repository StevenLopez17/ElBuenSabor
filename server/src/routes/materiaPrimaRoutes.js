import express from 'express'
import { getMateriaPrima, insertarMateriaPrimaView } from '../controllers/materiaPrimaController.js'

const router = express.Router()

router.get('/materia_prima', getMateriaPrima)

router.get('/insertar_materia_prima', insertarMateriaPrimaView)



export default router;