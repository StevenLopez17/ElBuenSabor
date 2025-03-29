import jwt from 'jsonwebtoken'
import Usuario from '../src/models/usuarios.js'
import obtenerUsuarioJWT from '../helpers/obtenerDatosJWT.js';


const identificarUsuario = async (req, res, next) => {
    const { _token } = req.cookies;

    if (!_token) {
        req.usuario = null;
        return res.redirect('/login');
    }

    const datosUsuario = obtenerUsuarioJWT(_token);

    if (datosUsuario?.error === 'Token expirado') {
        console.warn('Usuario con token expirado, redirigiendo a login...');
        res.clearCookie('_token');
        return res.redirect('/login');
    }

    if (datosUsuario) {
        req.usuario = {
            correo: datosUsuario.correo,
            nombre: datosUsuario.nombre,
            id: datosUsuario.id,
            rol: datosUsuario.rol
        };
        return next();
    } else {
        return res.clearCookie('_token').redirect('login');
    }
};

export default identificarUsuario;