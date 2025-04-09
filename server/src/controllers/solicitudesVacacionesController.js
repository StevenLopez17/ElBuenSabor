import Usuario from '../models/usuarios.js'
import { generarId, generarJWT } from '../../helpers/tokens.js'
import { check, validationResult } from 'express-validator';
import SolicitudesVacaciones from '../models/solicitudVacaciones.js';
import { emailAprobacionVacaciones, emailRechazoVacaciones } from '../../helpers/email.js';

const vacacionesView = async (req, res) => {
    const { id } = req.usuario
    const success = []
    const errores = []
    res.render('vacaciones/solicitudesVacaciones', { usuario_id: id, errores, success })
}

const agregarSolicitud = async (req, res) => {
    try {
        const { usuario_id, fecha_inicio, fecha_fin } = req.body;
        const { id } = req.usuario
        const success = []
        const errores = []
        if (!usuario_id) errores.push({ msg: 'Algo salió mal, vuelve a intentarlo' });
        if (!fecha_inicio) errores.push({ msg: 'Fecha de inicio es obligatoria' });
        if (!fecha_fin) errores.push({ msg: 'Fecha de finalización es obligatoria' });
        if (errores.length > 0) {
            return res.render('vacaciones/solicitudesVacaciones', { usuario_id: id, errores, success });
        }
        await SolicitudesVacaciones.create({
            usuario_id,
            fecha_inicio,
            fecha_fin,
            estado: "Pendiente",
            fecha_solicitud: new Date(),
        });
        success.push({ msg: 'Solicitud creada con éxito' })
        // console.log('Solicitud creada con éxito');
        return res.render('vacaciones/solicitudesVacaciones', { usuario_id: id, errores, success });

    } catch (error) {
        console.error('Error al crear solicitud vacaciones:', error);
        res.status(500).json({ message: "Error al crear solicitud vacaciones:", error: error.message });
    }
}

const vacacionesSolicitadas = async (req, res) => {
    try {
        const { id } = req.usuario
        const vacaciones = await SolicitudesVacaciones.findAll({
            where: {
                usuario_id: id,
            }
        });
        if (!vacaciones) {
            return res.render('vacaciones/solicitudesRealizadas', { vacaciones: vacacionesConFechasFormateadas, usuario_id: id, mensaje: "No hay solicitudes registradas" });
        }
        const vacacionesConFechasFormateadas = vacaciones.map(solicitud => {
            return {
                ...solicitud.toJSON(),
                fecha_solicitud: solicitud.fecha_solicitud.toISOString().split('T')[0]
            };
        });
        return res.render('vacaciones/solicitudesRealizadas', { vacaciones: vacacionesConFechasFormateadas, usuario_id: id, mensaje: null });
    } catch (error) {
        console.error('Error al crear solicitud vacaciones:', error);
        res.status(500).json({ message: "Error al mostrar solicitudes", error: error.message });
    }
}

const vacacionesSolicitadasAdmin = async (req, res) => {
    try {
        const { id, rol } = req.usuario
        if (rol != 1) {
            return res.redirect('/')
        }
        const vacaciones = await SolicitudesVacaciones.findAll({
            where: {
                estado: 'Pendiente',
            },
            include: [
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['nombre']
                }
            ]
        });
        if (!vacaciones) {
            return res.render('vacaciones/solicitudesRealizadasAdmin', { vacaciones, mensaje: "No hay solicitudes pendientes" });
        }
        const vacacionesConFechasFormateadas = vacaciones.map(solicitud => {
            return {
                ...solicitud.toJSON(),
                fecha_solicitud: solicitud.fecha_solicitud.toISOString().split('T')[0]
            };
        });
        return res.render('vacaciones/solicitudesRealizadasAdmin', { vacaciones: vacacionesConFechasFormateadas, mensaje: null });
    } catch (error) {
        console.error('Error al mostrar solicitudes de vacaciones', error);
        res.status(500).json({ message: "Error al mostrar solicitudes", error: error.message });
    }
}

const aprobarSolicitud = async (req, res) => {
    try {
        const { id } = req.params;
        const solicitud = await SolicitudesVacaciones.findByPk(id);
        if (!solicitud) {
            return res.redirect('/vacacionesSolicitudes');
        }
        await solicitud.update({
            estado: 'Aprobada'
        });

        const usuario = await Usuario.findByPk(solicitud.usuario_id);
        //Enviar correo confirmacion
        console.log('Enviando correo..')
        emailAprobacionVacaciones({
            nombre: usuario.nombre,
            email: usuario.correo,
            fecha_inicio: solicitud.fecha_inicio,
            fecha_finalizacion: solicitud.fecha_fin
        })
        return res.redirect('/vacacionesSolicitudes');
    } catch (error) {
        console.error('Error al aprobar solicitud de vacaciones', error);
        res.status(500).json({ message: "Error al aprobar solicitud", error: error.message });
    }
}

const denegarSolicitud = async (req, res) => {
    try {
        const { id } = req.params;
        const solicitud = await SolicitudesVacaciones.findByPk(id);
        if (!solicitud) {
            return res.redirect('/vacacionesSolicitudes');
        }
        await solicitud.update({
            estado: 'Rechazada'
        });
        const usuario = await Usuario.findByPk(solicitud.usuario_id);
        //Enviar correo confirmacion
        console.log('Enviando correo..')
        emailRechazoVacaciones({
            nombre: usuario.nombre,
            email: usuario.correo,
            fecha_inicio: solicitud.fecha_inicio,
            fecha_finalizacion: solicitud.fecha_fin
        })
        return res.redirect('/vacacionesSolicitudes');
    } catch (error) {
        console.error('Error al denegar solicitud de vacaciones', error);
        res.status(500).json({ message: "Error al denegar solicitud", error: error.message });
    }
}

export { vacacionesView, agregarSolicitud, vacacionesSolicitadas, vacacionesSolicitadasAdmin, aprobarSolicitud, denegarSolicitud };