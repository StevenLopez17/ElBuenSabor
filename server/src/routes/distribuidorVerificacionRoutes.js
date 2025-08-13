import express from 'express';
import DistribuidorVerificacionController from '../controllers/distribuidorVerificacionController.js';
import identificarUsuario from '../../middleware/identificarUsuario.js';
import { verificarAdmin } from '../../middleware/verificarPermisos.js';

const router = express.Router();

/**
 * Rutas para la verificación y gestión de distribuidores
 * Todas las rutas requieren autenticación y rol de administrador
 */

// Verificar correspondencia entre usuarios y distribuidores
router.get('/verificar-correspondencia', 
    identificarUsuario, 
    verificarAdmin, 
    DistribuidorVerificacionController.verificarCorrespondencia
);

// Crear automáticamente distribuidores faltantes
router.post('/crear-distribuidores-faltantes', 
    identificarUsuario, 
    verificarAdmin, 
    DistribuidorVerificacionController.crearDistribuidoresFaltantes
);

// Obtener estadísticas de distribuidores
router.get('/estadisticas', 
    identificarUsuario, 
    verificarAdmin, 
    DistribuidorVerificacionController.obtenerEstadisticas
);

// Limpiar distribuidores huérfanos
router.delete('/limpiar-huerfanos', 
    identificarUsuario, 
    verificarAdmin, 
    DistribuidorVerificacionController.limpiarDistribuidoresHuerfanos
);

export default router;
