import Colaboradores from "../models/colaboradorModel.js";
import Horarios from "../models/horarioModel.js"
import GestionColaboradores from "../models/colaboradorModel.js";

//Metodo para agregar un colaborador
const insertColaborador = async (req, res) => {
    try {
        const { usuario_id, cargo, fecha_ingreso, horario_id } = req.body;

        await GestionColaboradores.create({
            usuario_id,
            cargo,
            fecha_ingreso,
            horario_id,
        });

        res.redirect('colaboradores')
    } catch (error) {
        console.error('Error al crear el registro de colaborador:', error);
        res.status(500).json({ message: "Error al agregar colaborador", error: error.message });
    }
};


//Metodo para obtener los Colaboradores almacenados
const getColaboradores = async (req, res) => {
    try {
        const colaboradores = await Colaboradores.findAll({
            include: {
                model: Horarios,
                as: 'Horario',
                attributes: ['descripcion']
            }
        });
        const horarios = await Horarios.findAll();

        if (colaboradores.length > 0) {
            console.log(`Se encontraron ${colaboradores.length} Colaboradores.`);
            res.render('gestionColaboradores/colaboradores', {
                colaboradores: colaboradores,
                horarios: horarios,
                mensaje: null
            });
        } else {
            console.log(`No se encontraron Colaboradores.`);
            res.render('gestionColaboradores/colaboradores', {
                colaboradores: [],
                horarios: [],
                mensaje: "No hay Colaboradores registrados."
            });
        }
    } catch (error) {
        console.error('Error al obtener los Colaboradores:', error);
        res.render('gestionColaboradores/colaboradores', {
            colaboradores: [],
            horarios: [],
            mensaje: "Error al cargar los Colaboradores."
        });
    }
};


const agregarVista = async (req, res) => {
    try {
        const horarios = await Horarios.findAll();

        if (!horarios || horarios.length === 0) {
            res.render('gestionColaboradores/colaboradores', {
                horarios: [],
                mensaje: "Error al mostrar horarios disponibles"
            });
        }

        res.render('gestionColaboradores/colaboradoresAgregar', {
            horarios: horarios,
            mensaje: null
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ message: "Error al renderizar agregar colaborador", error: error.message });
    }
};

//Metodo para actualizar los datos de un distribuidor
const updateColaborador = async (req, res) => {
    try {
        const { usuario_id, empresa, telefono, direccion, zona_cobertura } = req.body;
        const { id } = req.params;

        if (!id || !usuario_id || !empresa) {
            return res.status(400).json({ message: "ID, Usuario ID y Empresa son obligatorios" });
        }

        const distribuidor = await Colaboradores.findByPk(id);
        if (!distribuidor) {
            return res.status(404).json({ message: "Distribuidor no encontrado" });
        }

        await distribuidor.update({
            usuario_id,
            empresa,
            telefono,
            direccion,
            zona_cobertura
        });

        console.log('Distribuidor actualizado con éxito');
        res.redirect('/distribuidor');

    } catch (error) {
        console.error('Error al actualizar el distribuidor:', error);
        res.status(500).json({ message: "Error al actualizar distribuidor", error: error.message });
    }
};

//Metodo para renderizar la vista de actualizar los Colaboradores y que carga los datos del distribuidor a actualizar
const rendUpdateColaborador = async (req, res) => {
    try {
        console.log("ID recibido:", req.params.id);

        const distribuidor = await Colaboradores.findByPk(req.params.id);

        if (!distribuidor) {
            console.log("Distribuidor no encontrado en la base de datos");
            return res.status(404).send("Distribuidor no encontrado");
        }

        console.log("Distribuidor seleccionado:", JSON.stringify(distribuidor, null, 2));

        res.render('ColaboradoresEditar', {
            layout: 'layouts/layout',
            distribuidor: distribuidor
        });

    } catch (error) {
        console.error("Error al obtener el distribuidor:", error);
        res.status(500).send("Error interno del servidor");
    }
};


const cambiarColaboradorEstado = async (req, res) => {
    try {
        const { id } = req.params;

        const distribuidor = await Colaboradores.findByPk(id);
        if (!distribuidor) {
            return res.status(404).json({ message: "Distribuidor no encontrado" });
        }


        distribuidor.estado = !distribuidor.estado;
        await distribuidor.save();

        console.log(`El distribuidor de ID ${id} está ${distribuidor.estado ? 'Activo' : 'Inactivo'}`);

        res.redirect('/distribuidor');

    } catch (error) {
        console.error("Error al cambiar el estado del distribuidor:", error);
        res.status(500).json({ message: "Error al actualizar estado", error: error.message });
    }
};

export { insertColaborador, getColaboradores, updateColaborador, rendUpdateColaborador, cambiarColaboradorEstado, agregarVista };
