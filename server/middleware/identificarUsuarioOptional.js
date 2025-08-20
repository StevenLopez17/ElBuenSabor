import jwt from 'jsonwebtoken'
import Usuario from '../src/models/usuarios.js'
import obtenerUsuarioJWT from '../helpers/obtenerDatosJWT.js';

// Middleware opcional que identifica al usuario si está logueado, 
// pero no redirige si no lo está (para rutas públicas)
const identificarUsuarioOptional = async (req, res, next) => {
    const { _token } = req.cookies;

    if (!_token) {
        req.usuario = null;
        return next();
    }

    const datosUsuario = obtenerUsuarioJWT(_token);

    if (datosUsuario?.error === 'Token expirado') {
        console.warn('Usuario con token expirado, limpiando cookie...');
        res.clearCookie('_token');
        req.usuario = null;
        return next();
    }

    if (datosUsuario) {
        req.usuario = {
            correo: datosUsuario.correo,
            nombre: datosUsuario.nombre,
            id: datosUsuario.id,
            rol: datosUsuario.rol,
            imagen_url: datosUsuario.imagen_url
        };
    } else {
        res.clearCookie('_token');
        req.usuario = null;
    }
    
    return next();
};

export default identificarUsuarioOptional;
