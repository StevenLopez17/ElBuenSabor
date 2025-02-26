import Usuario from '../models/usuarios.js'
import { generarId, generarJWT } from '../../helpers/tokens.js'
import { check, validationResult } from 'express-validator';
import identificarUsuario from '../../middleware/identificarUsuario.js';


const insertUsuario = async (req, res) => {
    const { nombre, correo, contrasena, rol } = req.body;
    // console.log(nombre, correo, contrasena);

    if (nombre && correo && contrasena) {
        try {
            await Usuario.create({
                nombre: nombre,
                correo: correo,
                contrasena: contrasena,
                rol_id: 1,
                token: generarId()
            });
            console.log('Usuario creado con éxito');
            res.render('auth/profile', {
                usuario: req.body
            })

        } catch (error) {
            console.error('Error al crear el usuario:', error);
            res.render('index', {
                usuario: req.body
            })
        }
    } else {
        console.log('Todos los campos son requeridos');
        res.render('index', {
            usuario: req.body
        })
    }
}

const getUsuario = async (req, res) => {
    try {
        const { correo, contrasena } = req.body
        const usuario = await Usuario.findOne({
            where: {
                correo: correo
            }
        });

        if (usuario) {
            if (!usuario.verificarPassword(contrasena)) {
                return res.render('login', {
                    // pagina: 'Iniciar Sesión',
                    layout: false,
                    errores: [{ msg: 'El Password Es Incorrecto' }]
                });
            }
            console.log(`Usuario ${usuario.correo} autenticado correctamente!`);

            // Generar JWT
            const token = generarJWT({ id: usuario.id, nombre: usuario.nombre });
            return res.cookie('_token', token, {
                httpOnly: true
                //secure: true,
                //sameSite: true
            }).redirect('/');

        } else {
            console.log(`No se encontró un usuario con el correo: ${correo}`);
            res.render('login', {
                layout: false,
                usuario: usuario,
                mensaje: "No se pudo encontrar al usuario"
            })
        }
    } catch (error) {
        console.error('Error al obtener el usuario:', error);
        res.render('login', {
            layout: false
        });
    }
}


const cerrarSesion = (req, res) => {
    return res.clearCookie('_token').status(200).redirect('/');
}


const profileView = (req, res, next) => {
    res.render('auth/profile')
}



export { insertUsuario, getUsuario, profileView };