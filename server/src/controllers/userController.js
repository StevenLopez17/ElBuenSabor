import Usuario from '../models/usuarios.js'
import { generarId, generarJWT } from '../../helpers/tokens.js'
import { check, validationResult } from 'express-validator';
import bcrypt from 'bcrypt'
import Rol from '../models/rol.js'
import supabase from '../../config/supabaseClient.js'


const insertUsuario = async (req, res) => {
    const { nombre, correo, contrasena, rol_id } = req.body;
    let errores = [];
    let success = [];
    if (!nombre) errores.push({ msg: 'El nombre es obligatorio' });
    if (!correo) errores.push({ msg: 'El correo es obligatorio' });
    if (!contrasena) errores.push({ msg: 'La contraseña es obligatoria' });
    if (!rol_id) errores.push({ msg: 'El rol es obligatorio' });
    const roles = await Rol.findAll();
    if (errores.length > 0) {
        return res.render('auth/registro', { layout: false, errores, success, roles });
    }

    try {
        const usuario = await Usuario.findOne({
            where: {
                correo: correo
            }
        });

        if (usuario) {
            errores.push({ msg: 'Intente con un correo diferente' });
            return res.render('auth/registro', { layout: false, errores, success, roles });
        }
        await Usuario.create({
            nombre: nombre,
            correo: correo,
            contrasena: contrasena,
            rol_id: rol_id,
            token: generarId()
        });

        success.push({ msg: 'Usuario creado con éxito' });
        return res.render('auth/registro', { layout: false, usuario: req.body, errores, success, roles });
    } catch (error) {
        console.error('Error al crear usuario', error);
        errores.push({ msg: 'Error interno del servidor' });
    }
    return res.render('auth/registro', { layout: false, errores, success, roles });
}

const getUsuario = async (req, res) => {
    try {
        const { correo, contrasena } = req.body
        let errores = [];
        let success = [];

        if (!correo) errores.push({ msg: 'El correo es obligatorio' });
        if (!contrasena) errores.push({ msg: 'La contraseña es obligatoria' });
        if (errores.length > 0) {
            return res.render('login', { layout: false, errores, success });
        }

        // Buscar al usuario en base de datos
        const usuario = await Usuario.findOne({
            where: {
                correo: correo
            }
        });

        if (usuario) {
            if (!usuario.verificarPassword(contrasena)) {
                errores.push({ msg: 'Credenciales incorrectas' });
                return res.render('login', { layout: false, errores, success });
            }
            console.log(`Usuario ${usuario.correo} autenticado correctamente!`);
            // Generar JWT
            const token = generarJWT({ id: usuario.id, nombre: usuario.nombre, rol: usuario.rol_id, correo: usuario.correo });
            // console.log("Token generado:", jwt.decode(token));
            return res.cookie('_token', token, {
                httpOnly: true
                //secure: true,
                //sameSite: true
            }).redirect('/');

        } else {
            console.log(`No se encontró un usuario con el correo: ${correo}`);
            errores.push({ msg: 'Debe ponerse en contacto con el administrador para crear una cuenta!' });
            return res.render('login', { layout: false, errores, success });
        }
    } catch (error) {
        console.error('Error al obtener el usuario:', error);
        res.render('login', {
            layout: false,
            errores: [{ msg: 'Error al obtener usuario' }],
            success: []
        });
    }
}


const cerrarSesion = (req, res) => {
    return res.clearCookie('_token').status(200).redirect('/login');
}


const profileView = async (req, res, next) => {
    const usuario = req.usuario
    const rol = await Rol.findOne({
        where: {
            id: req.usuario.rol
        }
    });
    const rol_name = rol.nombre
    res.render('auth/profile', { usuario, rol_name })
}

const updatePassword = async (req, res, next) => {
    const { correo, contrasena, primerNuevaContrasena, segundaNuevaContrasena } = req.body;
    let errores = [];
    let success = [];

    if (!correo) errores.push({ msg: 'El correo es obligatorio' });
    if (!contrasena) errores.push({ msg: 'La contraseña actual es obligatoria' });
    if (!primerNuevaContrasena) errores.push({ msg: 'La nueva contraseña es obligatoria' });
    if (!segundaNuevaContrasena) errores.push({ msg: 'Debe confirmar la nueva contraseña' });

    if (errores.length > 0) {
        return res.render('auth/updateUsuario', { layout: false, errores, success });
    }
    if (primerNuevaContrasena !== segundaNuevaContrasena) {
        errores.push({ msg: 'La nueva contraseña debe coincidir' });
        return res.render('auth/updateUsuario', { layout: false, errores, success });
    }

    try {
        const usuario = await Usuario.findOne({ where: { correo } });

        if (!usuario) {
            errores.push({ msg: 'Usuario no encontrado' });
            return res.render('auth/updateUsuario', { layout: false, errores, success });
        }

        if (!usuario.verificarPassword(contrasena)) {
            errores.push({ msg: 'Credenciales incorrectas' });
            return res.render('auth/updateUsuario', { layout: false, errores, success });
        }

        const salt = await bcrypt.genSalt(10);
        const hashPassword = await bcrypt.hash(primerNuevaContrasena, salt);

        const resultado = await Usuario.update(
            { contrasena: hashPassword },
            { where: { correo } }
        );

        if (resultado[0] > 0) {
            success.push({ msg: 'Contraseña actualizada correctamente' });
        } else {
            errores.push({ msg: 'No se pudo actualizar la contraseña' });
        }
    } catch (error) {
        console.error('Error al actualizar la contraseña:', error);
        errores.push({ msg: 'Error interno del servidor' });
    }

    return res.render('auth/updateUsuario', { layout: false, errores, success });
};


export const subirImagenPerfil = async (req, res) => {
    const { id } = req.params;
    const file = req.file;
  
    if (!file) return res.status(400).json({ error: 'No se recibió ningún archivo' });
  
    const fileName = `${Date.now()}-${file.originalname}`;
  
    const { error: uploadError } = await supabase.storage
      .from('perfiles')
      .upload(`avatars/${id}/${fileName}`, file.buffer, {
        contentType: file.mimetype,
        upsert: true
      });
  
    if (uploadError) {
      console.error(uploadError);
      return res.status(500).json({ error: 'Error al subir la imagen' });
    }
  
    const { data } = supabase.storage
      .from('perfiles')
      .getPublicUrl(`avatars/${id}/${fileName}`);
  
    const imageUrl = data.publicUrl;
  
    await supabase
      .from('usuarios')
      .update({ imagen_url: imageUrl })
      .eq('id', id);
  
    res.status(200).json({ url: imageUrl });
  };


export { insertUsuario, getUsuario, profileView, updatePassword, cerrarSesion};