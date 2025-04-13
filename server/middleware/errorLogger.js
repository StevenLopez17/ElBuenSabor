// src/middleware/errorLogger.js
import GestionError from '../src/models/gestionErrorModel.js';
import obtenerUsuarioJWT from '../helpers/obtenerDatosJWT.js';

const errorLogger = async (err, req, res, next) => {
  try {
    await GestionError.create({
      usuario_id: req.usuario?.id || null,
      mensaje: err.message,
      origen: req.originalUrl
    });
  } catch (logErr) {
    console.error("Error al registrar en gestion_error:", logErr);
  }

  res.status(500).render('error/error', {
    layout: 'layouts/layout_error', 
    mensaje: 'Ocurrió un error inesperado. Por favor, inténtalo de nuevo más tarde.',
  });
};

export default errorLogger;
