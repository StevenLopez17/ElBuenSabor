import Usuario from '../models/usuarios.js'
import { generarId, generarJWT } from '../../helpers/tokens.js'
import { check, validationResult } from 'express-validator';
import bcrypt from 'bcrypt'
import Rol from '../models/rol.js'
import supabase, { supabaseAdmin } from '../../config/supabaseClient.js'


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
            const token = generarJWT({ 
                id: usuario.id, 
                nombre: usuario.nombre, 
                rol: usuario.rol_id, 
                correo: usuario.correo,
                imagen_url: usuario.imagen_url
            });
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
    const nuevoPath = `avatars/${id}/${fileName}`;
  
    try {
      // 1. Obtener usuario actual
      const usuario = await Usuario.findByPk(id);
      if (!usuario) return res.status(404).json({ error: 'Usuario no encontrado' });
  
      // 2. Extraer nombre del archivo anterior (si existe)
      const rutaAnterior = usuario.imagen_url || '';
      const basePath = `https://uerxbwntfwyvkspdtlaq.supabase.co/storage/v1/object/public/perfiles/`;
      const imagenAntigua = rutaAnterior.startsWith(basePath)
        ? rutaAnterior.replace(basePath, '')
        : null;
  
      // 3. Eliminar imagen anterior
      if (imagenAntigua) {
        const { error: deleteError } = await supabaseAdmin.storage
          .from('perfiles')
          .remove([imagenAntigua]);
  
        if (deleteError) console.warn("No se pudo eliminar imagen anterior:", deleteError.message);
      }
  
      // 4. Subir nueva imagen
      const { error: uploadError } = await supabaseAdmin.storage
        .from('perfiles')
        .upload(nuevoPath, file.buffer, {
          contentType: file.mimetype,
          upsert: true
        });
  
      if (uploadError) {
        console.error('Error al subir imagen:', uploadError);
        return res.status(500).json({ error: 'Error al subir la imagen' });
      }
  
      // 5. Obtener nueva URL pública
      const cdnPath = nuevoPath.replace('avatars/', '');
     const nuevaUrl = `https://uerxbwntfwyvkspdtlaq.supabase.co/storage/v1/public/perfiles/${cdnPath}`;

// 6. Actualizar la ruta en la base de datos
usuario.imagen_url = nuevaUrl;
await usuario.save();
  
      // 7. Actualizar token en cookie (opcional si lo usás)
      const token = generarJWT({ 
        id: usuario.id,
        nombre: usuario.nombre,
        rol: usuario.rol_id,
        correo: usuario.correo,
        imagen_url: nuevaUrl
      });
  
      res.cookie('_token', token, { httpOnly: true });
      return res.status(200).json({ url: nuevaUrl });
  
    } catch (error) {
      console.error("Error general:", error);
      return res.status(500).json({ error: 'Error interno del servidor', detalles: error.message });
    }
  };


export { insertUsuario, getUsuario, profileView, updatePassword, cerrarSesion};