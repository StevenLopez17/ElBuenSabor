import express from 'express'
import { getHorarios, agregarHorarioView, agregarHorario, eliminarHorario } from '../controllers/horariosController.js';

const router = express.Router()

router.get('/horarios', getHorarios);

router.get('/agregarHorario', agregarHorarioView)

router.post('/agregarHorario', agregarHorario)

router.get('/horarioEliminar/:id', eliminarHorario);

export default router
