import nodemailer from 'nodemailer'


export const emailAprobacionVacaciones = async (datos) => {
    const transport = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    const { email, nombre, fecha_inicio, fecha_finalizacion } = datos;
    //Enviar el email
    await transport.sendMail({
        from: 'BienesRaices.com',
        to: email,
        subject: 'Notificación Vacaciones ElBuenSabor',
        text: 'Notificación Vacaciones ElBuenSabor',
        html: `
            <p>Hola ${nombre},</p>

            <p>Tu solicitud de vacaciones con fecha de inicio ${fecha_inicio} y fecha de finalización ${fecha_finalizacion}, ha sido aprobada

            <p>Si tu no realizaste ninguna solicitud puedes ignorar el mensaje</p>
        `
    });
}


export const emailRechazoVacaciones = async (datos) => {
    const transport = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    const { email, nombre, fecha_inicio, fecha_finalizacion } = datos;
    //Enviar el email
    await transport.sendMail({
        from: 'BienesRaices.com',
        to: email,
        subject: 'Notificación Vacaciones ElBuenSabor',
        text: 'Notificación Vacaciones ElBuenSabor',
        html: `
            <p>Hola ${nombre},</p>

            <p>Tu solicitud de vacaciones con fecha de inicio ${fecha_inicio} y fecha de finalización ${fecha_finalizacion}, ha sido rechazada

            <p>Si tu no realizaste ninguna solicitud puedes ignorar el mensaje</p>
        `
    });
}

