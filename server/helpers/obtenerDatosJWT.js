import jwt from 'jsonwebtoken';

const obtenerUsuarioJWT = (token) => {
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        return {
            correo: decoded.correo,
            nombre: decoded.nombre,
            id: decoded.id,
            rol: decoded.rol
        };
    } catch (error) {
        console.error('Error al verificar el token:', error);
        return null;
    }
};

export default obtenerUsuarioJWT;