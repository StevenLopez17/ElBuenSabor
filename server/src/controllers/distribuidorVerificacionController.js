import Distribuidores from '../models/distribuidorModel.js';
import Usuario from '../models/usuarios.js';
import Rol from '../models/rol.js';

/**
 * Controlador para la verificación y gestión de distribuidores
 */
class DistribuidorVerificacionController {
    
    /**
     * Verifica la correspondencia entre usuarios con rol distribuidor y registros en la tabla distribuidores
     * @param {Object} req - Request object
     * @param {Object} res - Response object
     */
    static async verificarCorrespondencia(req, res) {
        try {
            console.log("=== VERIFICACIÓN DE CORRESPONDENCIA DE DISTRIBUIDORES ===");
            
            // Obtener todos los usuarios con rol 3 (distribuidores)
            const usuariosDistribuidores = await Usuario.findAll({
                where: { rol: 3 },
                attributes: ['id', 'correo', 'nombre', 'rol']
            });
            
            // Obtener todos los distribuidores
            const distribuidores = await Distribuidores.findAll({
                attributes: ['id', 'usuario_id', 'empresa', 'telefono', 'estado']
            });
            
            // Verificar correspondencia
            const resultados = [];
            const usuariosSinDistribuidor = [];
            const distribuidoresSinUsuario = [];
            
            for (const usuario of usuariosDistribuidores) {
                const distribuidor = distribuidores.find(d => d.usuario_id === usuario.id);
                
                if (distribuidor) {
                    resultados.push({
                        usuario: {
                            id: usuario.id,
                            correo: usuario.correo,
                            nombre: usuario.nombre
                        },
                        distribuidor: {
                            id: distribuidor.id,
                            empresa: distribuidor.empresa,
                            telefono: distribuidor.telefono,
                            estado: distribuidor.estado
                        },
                        estado: 'CORRESPONDENCIA_CORRECTA'
                    });
                } else {
                    usuariosSinDistribuidor.push(usuario);
                    resultados.push({
                        usuario: {
                            id: usuario.id,
                            correo: usuario.correo,
                            nombre: usuario.nombre
                        },
                        distribuidor: null,
                        estado: 'SIN_DISTRIBUIDOR'
                    });
                }
            }
            
            // Verificar distribuidores sin usuario asociado
            for (const distribuidor of distribuidores) {
                const usuario = usuariosDistribuidores.find(u => u.id === distribuidor.usuario_id);
                if (!usuario) {
                    distribuidoresSinUsuario.push(distribuidor);
                }
            }
            
            const resumen = {
                total_usuarios_distribuidores: usuariosDistribuidores.length,
                total_distribuidores: distribuidores.length,
                correspondencias_correctas: resultados.filter(r => r.estado === 'CORRESPONDENCIA_CORRECTA').length,
                usuarios_sin_distribuidor: usuariosSinDistribuidor.length,
                distribuidores_sin_usuario: distribuidoresSinUsuario.length
            };
            
            res.json({
                success: true,
                resumen,
                resultados,
                usuarios_sin_distribuidor: usuariosSinDistribuidor,
                distribuidores_sin_usuario: distribuidoresSinUsuario
            });
            
        } catch (error) {
            console.error('Error en verificarCorrespondencia:', error);
            res.status(500).json({
                success: false,
                error: 'Error interno del servidor',
                message: error.message
            });
        }
    }
    
    /**
     * Crea automáticamente registros de distribuidor para usuarios que no los tienen
     * @param {Object} req - Request object
     * @param {Object} res - Response object
     */
    static async crearDistribuidoresFaltantes(req, res) {
        try {
            console.log("=== CREACIÓN AUTOMÁTICA DE DISTRIBUIDORES FALTANTES ===");
            
            // Obtener usuarios con rol distribuidor que no tienen registro en la tabla distribuidores
            const usuariosSinDistribuidor = await Usuario.findAll({
                where: { rol: 3 },
                attributes: ['id', 'correo', 'nombre']
            });
            
            const resultados = [];
            const creados = [];
            const errores = [];
            
            for (const usuario of usuariosSinDistribuidor) {
                try {
                    // Verificar si ya existe un distribuidor para este usuario
                    const distribuidorExistente = await Distribuidores.findOne({
                        where: { usuario_id: usuario.id }
                    });
                    
                    if (distribuidorExistente) {
                        resultados.push({
                            usuario: usuario.correo,
                            accion: 'YA_EXISTE',
                            distribuidor_id: distribuidorExistente.id,
                            mensaje: 'El distribuidor ya existe'
                        });
                    } else {
                        // Crear distribuidor automáticamente
                        const nuevoDistribuidor = await Distribuidores.create({
                            usuario_id: usuario.id,
                            empresa: `Empresa de ${usuario.nombre}`,
                            telefono: '000000000',
                            direccion: 'Dirección por defecto',
                            zona_cobertura: 'Zona por defecto',
                            fecha_registro: new Date(),
                            estado: true
                        });
                        
                        creados.push(nuevoDistribuidor);
                        resultados.push({
                            usuario: usuario.correo,
                            accion: 'CREADO',
                            distribuidor_id: nuevoDistribuidor.id,
                            mensaje: 'Distribuidor creado exitosamente'
                        });
                        
                        console.log(`✅ Distribuidor creado para usuario ${usuario.correo} (ID: ${nuevoDistribuidor.id})`);
                    }
                    
                } catch (error) {
                    errores.push({
                        usuario: usuario.correo,
                        error: error.message
                    });
                    
                    resultados.push({
                        usuario: usuario.correo,
                        accion: 'ERROR',
                        error: error.message
                    });
                    
                    console.error(`❌ Error al crear distribuidor para ${usuario.correo}:`, error.message);
                }
            }
            
            const resumen = {
                total_usuarios_verificados: usuariosSinDistribuidor.length,
                distribuidores_creados: creados.length,
                ya_existian: resultados.filter(r => r.accion === 'YA_EXISTE').length,
                errores: errores.length
            };
            
            res.json({
                success: true,
                resumen,
                resultados,
                creados: creados.map(d => ({
                    id: d.id,
                    usuario_id: d.usuario_id,
                    empresa: d.empresa
                })),
                errores
            });
            
        } catch (error) {
            console.error('Error en crearDistribuidoresFaltantes:', error);
            res.status(500).json({
                success: false,
                error: 'Error interno del servidor',
                message: error.message
            });
        }
    }
    
    /**
     * Obtiene estadísticas de distribuidores
     * @param {Object} req - Request object
     * @param {Object} res - Response object
     */
    static async obtenerEstadisticas(req, res) {
        try {
            const totalUsuariosDistribuidores = await Usuario.count({
                where: { rol: 3 }
            });
            
            const totalDistribuidores = await Distribuidores.count();
            
            const distribuidoresActivos = await Distribuidores.count({
                where: { estado: true }
            });
            
            const distribuidoresInactivos = await Distribuidores.count({
                where: { estado: false }
            });
            
            const usuariosSinDistribuidor = await Usuario.count({
                where: { rol: 3 }
            }) - await Distribuidores.count();
            
            res.json({
                success: true,
                estadisticas: {
                    total_usuarios_distribuidores: totalUsuariosDistribuidores,
                    total_distribuidores: totalDistribuidores,
                    distribuidores_activos: distribuidoresActivos,
                    distribuidores_inactivos: distribuidoresInactivos,
                    usuarios_sin_distribuidor: Math.max(0, usuariosSinDistribuidor),
                    porcentaje_cobertura: totalUsuariosDistribuidores > 0 
                        ? Math.round((totalDistribuidores / totalUsuariosDistribuidores) * 100) 
                        : 0
                }
            });
            
        } catch (error) {
            console.error('Error en obtenerEstadisticas:', error);
            res.status(500).json({
                success: false,
                error: 'Error interno del servidor',
                message: error.message
            });
        }
    }
    
    /**
     * Limpia distribuidores huérfanos (sin usuario asociado)
     * @param {Object} req - Request object
     * @param {Object} res - Response object
     */
    static async limpiarDistribuidoresHuerfanos(req, res) {
        try {
            console.log("=== LIMPIEZA DE DISTRIBUIDORES HUÉRFANOS ===");
            
            const distribuidores = await Distribuidores.findAll();
            const usuariosDistribuidores = await Usuario.findAll({
                where: { rol: 3 },
                attributes: ['id']
            });
            
            const idsUsuarios = usuariosDistribuidores.map(u => u.id);
            const distribuidoresHuerfanos = distribuidores.filter(d => !idsUsuarios.includes(d.usuario_id));
            
            const eliminados = [];
            const errores = [];
            
            for (const distribuidor of distribuidoresHuerfanos) {
                try {
                    await distribuidor.destroy();
                    eliminados.push(distribuidor);
                    console.log(`🗑️ Distribuidor huérfano eliminado: ID ${distribuidor.id}`);
                } catch (error) {
                    errores.push({
                        distribuidor_id: distribuidor.id,
                        error: error.message
                    });
                }
            }
            
            res.json({
                success: true,
                resumen: {
                    total_distribuidores_verificados: distribuidores.length,
                    distribuidores_huerfanos_encontrados: distribuidoresHuerfanos.length,
                    eliminados: eliminados.length,
                    errores: errores.length
                },
                eliminados: eliminados.map(d => ({
                    id: d.id,
                    usuario_id: d.usuario_id,
                    empresa: d.empresa
                })),
                errores
            });
            
        } catch (error) {
            console.error('Error en limpiarDistribuidoresHuerfanos:', error);
            res.status(500).json({
                success: false,
                error: 'Error interno del servidor',
                message: error.message
            });
        }
    }
}

export default DistribuidorVerificacionController;
