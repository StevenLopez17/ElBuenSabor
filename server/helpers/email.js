import nodemailer from 'nodemailer'
import { fileURLToPath } from 'url';
import path from 'path';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const logoPath = path.join(__dirname, '..', '..', '..', 'ElBuenSabor', 'public', 'images', 'Logo-Rellenos-El-Buen-Sabor-Version-Naranja.png');
// const logoBase64 = fs.readFileSync(logoPath).toString('base64');

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
        from: 'ElBuenSabor <no-reply@elbuen-sabor.com>',
        to: email,
        subject: 'Notificación Vacaciones ElBuenSabor',
        text: 'Notificación Vacaciones ElBuenSabor',
        html: `
            <html>
                <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px;">
                    <div style="max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
                    <img src="cid:logo" alt="Logo El Buen Sabor" style="max-width: 200px; display: block; margin: 0 auto 20px auto;" />

                    <h2 style="text-align: center; color: #2c3e50; margin-top: 0;">El Buen Sabor</h2>
                    <p style="font-size: 16px; color: #333;">Hola <strong>${nombre}</strong>,</p>

                    <p style="font-size: 16px; color: #333;">
                        Te informamos que tu solicitud de vacaciones con fecha de inicio 
                        <strong>${fecha_inicio}</strong> y fecha de finalización 
                        <strong>${fecha_finalizacion}</strong> ha sido <span style="color: green;"><strong>aprobada</strong></span>.
                    </p>

                    <p style="font-size: 14px; color: #666;">
                        Si tú no realizaste ninguna solicitud, puedes ignorar este mensaje.
                    </p>

                    <p style="font-size: 14px; color: #999; margin-top: 30px;">
                        Atentamente,<br>
                        Equipo de Recursos Humanos
                    </p>
                    </div>
                </body>
                </html>
        `,
        attachments: [
            {
                filename: 'logo.png',
                path: logoPath,
                cid: 'logo'
            }
        ]
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
        from: 'ElBuenSabor <no-reply@elbuen-sabor.com>',
        to: email,
        subject: 'Notificación Vacaciones ElBuenSabor',
        text: 'Notificación Vacaciones ElBuenSabor',
        html: `
            <html>
                <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px;">
                    <div style="max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
                    <img src="cid:logo" alt="Logo El Buen Sabor" style="max-width: 200px; display: block; margin: 0 auto 20px auto;" />

                    <p style="font-size: 16px; color: #333;">Hola <strong>${nombre}</strong>,</p>

                    <p style="font-size: 16px; color: #333;">
                        Te informamos que tu solicitud de vacaciones con fecha de inicio 
                        <strong>${fecha_inicio}</strong> y fecha de finalización 
                        <strong>${fecha_finalizacion}</strong> ha sido <span style="color: red;"><strong>rechazada</strong></span>.
                    </p>

                    <p style="font-size: 14px; color: #666;">
                        Si tú no realizaste ninguna solicitud, puedes ignorar este mensaje.
                    </p>

                    <p style="font-size: 14px; color: #999; margin-top: 30px;">
                        Atentamente,<br>
                        Equipo de Recursos Humanos
                    </p>
                    </div>
                </body>
                </html>
        `,
        attachments: [
            {
                filename: 'logo.png',
                path: logoPath,
                cid: 'logo'
            }
        ]
    });
}


export const emailPagoPendiente = async (datos) => {
    const transport = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    const { email, precioTotal, pendiente, fecha, idpedido, nombre } = datos;

    //Enviar el email
    await transport.sendMail({
        from: 'ElBuenSabor <no-reply@elbuen-sabor.com>',
        to: email,
        subject: 'Notificación de Pago Pendiente - Pedido #' + idpedido,
        text: `Hola ${nombre}, tienes un pago pendiente por tu pedido #${idpedido}. Monto total: ₡${precioTotal}. Monto pendiente: ₡${pendiente}. Fecha del pedido: ${fecha}.`,
        html: `
            <html>
                <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
                    <div style="max-width: 600px; margin: auto; background-color: #fff; border-radius: 8px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                        <img src="cid:logo" alt="Logo El Buen Sabor" style="max-width: 200px; display: block; margin: 0 auto 20px auto;" />

                        <h2 style="color: #d9534f;">⚠️ Pago Pendiente</h2>

                        <p style="font-size: 16px; color: #333;">Hola <strong>${nombre}</strong>,</p>

                        <p style="font-size: 16px; color: #333;">
                            Te informamos que tienes un <strong>pago pendiente</strong> relacionado con tu pedido <strong>#${idpedido}</strong> realizado el día <strong>${fecha}</strong>.
                        </p>

                        <ul style="font-size: 16px; color: #333; padding-left: 20px;">
                            <li><strong>Monto pendiente:</strong> ₡${precioTotal}</li>
                        </ul>

                        <p style="font-size: 15px; color: #666;">
                            Te agradecemos que realices el pago correspondiente lo antes posible para evitar retrasos en la entrega.
                        </p>

                        <p style="font-size: 14px; color: #999; margin-top: 30px;">
                            Si ya realizaste el pago, por favor ignora este mensaje.
                        </p>

                        <p style="font-size: 14px; color: #999; margin-top: 30px;">
                            Saludos cordiales,<br>
                            <strong>El equipo de ElBuenSabor</strong>
                        </p>

                    </div>
                </body>
            </html>
        `,
        attachments: [
            {
                filename: 'logo.png',
                path: logoPath,
                cid: 'logo'
            }
        ]
    });
}