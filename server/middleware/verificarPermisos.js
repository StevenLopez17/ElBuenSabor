import jwt from 'jsonwebtoken';
import obtenerUsuarioJWT from '../helpers/obtenerDatosJWT.js';

// Middleware para verificar si el usuario es administrador
const verificarAdmin = (req, res, next) => {
    // Si ya tenemos el usuario en req.usuario (del middleware identificarUsuario)
    if (req.usuario) {
        if (req.usuario.rol !== 1) {
            return res.redirect('/pedido?error=accesoDenegado');
        }
        return next();
    }

    // Si no tenemos req.usuario, verificar el token directamente
    const { _token } = req.cookies;
    
    if (!_token) {
        return res.redirect('/login');
    }

    const datosUsuario = obtenerUsuarioJWT(_token);
    
    if (!datosUsuario || datosUsuario.error) {
        return res.redirect('/login');
    }

    // Verificar si el usuario es administrador (rol = 1)
    if (datosUsuario.rol !== 1) {
        return res.redirect('/pedido?error=accesoDenegado');
    }

    next();
};

// Middleware para verificar si el usuario puede acceder a módulos específicos
const verificarAccesoModulo = (moduloPermitido) => {
    return (req, res, next) => {
        const { _token } = req.cookies;
        
        if (!_token) {
            return res.redirect('/login');
        }

        const datosUsuario = obtenerUsuarioJWT(_token);
        
        if (!datosUsuario || datosUsuario.error) {
            return res.redirect('/login');
        }

        // Si es administrador, puede acceder a todo
        if (datosUsuario.rol === 1) {
            return next();
        }

        // Si no es administrador, solo puede acceder al módulo de pedidos
        if (moduloPermitido === 'pedidos' && (datosUsuario.rol === 2 || datosUsuario.rol === 3)) {
            return next();
        }

        // Si intenta acceder a otros módulos, redirigir a pedidos
        return res.redirect('/pedido?error=accesoDenegado');
    };
};

export { verificarAdmin, verificarAccesoModulo };
