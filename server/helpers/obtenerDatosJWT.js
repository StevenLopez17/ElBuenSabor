import jwt from 'jsonwebtoken';

const obtenerUsuarioJWT = (token) => {
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        return {
            correo: decoded.correo,
            nombre: decoded.nombre,
            id: decoded.id,
            rol: decoded.rol,
            imagen_url: decoded.imagen_url
        };
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            console.warn('Token expirado en:', error.expiredAt);
            return { error: 'Token expirado' };
        } else {
            console.error('Error al verificar el token:', error);
            return null;
        }
    }
};

export default obtenerUsuarioJWT;