import express from 'express'
import { vacacionesView, agregarSolicitud, vacacionesSolicitadas, vacacionesSolicitadasAdmin, aprobarSolicitud, denegarSolicitud } from '../controllers/solicitudesVacacionesController.js';
import identificarUsuario from '../../middleware/identificarUsuario.js';

const router = express.Router()

router.get('/vacaciones', identificarUsuario, vacacionesView);

router.post('/agregarSolicitud', identificarUsuario, agregarSolicitud);

router.get('/vacacionesSolicitadasUser', identificarUsuario, vacacionesSolicitadas);

router.get('/vacacionesSolicitudes', identificarUsuario, vacacionesSolicitadasAdmin);

router.post('/aprobarSolicitud/:id', aprobarSolicitud);

router.post('/denegarSolicitud/:id', denegarSolicitud);

export default router

