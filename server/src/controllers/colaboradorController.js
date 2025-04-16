import Colaboradores from "../models/colaboradorModel.js";
import Horarios from "../models/horarioModel.js"
// import GestionColaboradores from "../models/colaboradorModel.js";

//Metodo para agregar un colaborador
const insertColaborador = async (req, res) => {
    try {
        const { usuario_id, cargo, fecha_ingreso, horario_id } = req.body;

        await Colaboradores.create({
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
        const { id, rol } = req.usuario;
        if (rol != 1) return res.redirect('/')
        const colaboradores = await Colaboradores.findAll({
            include: {
                model: Horarios,
                as: 'Horario',
                attributes: ['descripcion']
            }
        });
        const horarios = await Horarios.findAll();

        if (colaboradores.length > 0) {
            // console.log(`Se encontraron ${colaboradores.length} Colaboradores.`);
            res.render('gestionColaboradores/colaboradores', {
                layout: 'layouts/layout',
                colaboradores: colaboradores,
                horarios: horarios,
                mensaje: null
            });
        } else {
            // console.log(`No se encontraron Colaboradores.`);
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

        // if (!horarios || horarios.length === 0) {
        //     res.render('gestionColaboradores/colaboradores', {
        //         horarios: [],
        //         mensaje: "Error al mostrar horarios disponibles"
        //     });
        // }

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
        const { usuario_id, cargo, fecha_ingreso, horario } = req.body;
        const { id } = req.params;

        if (!id || !usuario_id || !cargo || !fecha_ingreso) {
            return res.status(400).json({ message: "Todos los campos son obligatorios" });
        }

        const colaborador = await Colaboradores.findByPk(id);
        if (!colaborador) {
            return res.status(404).json({ message: "Colaborador no encontrado" });
        }

        await colaborador.update({
            usuario_id,
            cargo,
            fecha_ingreso,
            horario_id: horario
        });

        console.log('Colaborador actualizado con éxito');
        res.redirect('/colaboradores');

    } catch (error) {
        console.error('Error al actualizar el colaborador:', error);
        res.status(500).json({ message: "Error al actualizar colaborador", error: error.message });
    }
};

//Metodo para renderizar la vista de actualizar los Colaboradores y que carga los datos del distribuidor a actualizar
const rendUpdateColaborador = async (req, res) => {
    try {
        console.log("ID recibido:", req.params.id);

        const colaborador = await Colaboradores.findByPk(req.params.id, {
            include: {
                model: Horarios,
                attributes: ['descripcion']
            }
        });


        if (!colaborador) {
            console.log("Colaborador no encontrado en la base de datos");
            return res.status(404).send("Colaborador no encontrado");
        }

        console.log("Colaborador seleccionado:", JSON.stringify(colaborador, null, 2));
        function formatDate(fecha) {
            if (!fecha) return "";
            return new Date(fecha).toISOString().split('T')[0];
        }
        const horarios = await Horarios.findAll();

        res.render('gestionColaboradores/colaboradoresEditar', {
            colaborador,
            formatDate,
            horarios
        });

    } catch (error) {
        console.error("Error al obtener el distribuidor:", error);
        res.status(500).send("Error interno del servidor");
    }
};


const cambiarColaboradorEstado = async (req, res) => {
    try {
        const { id } = req.params;

        const colaborador = await Colaboradores.findByPk(id);
        if (!colaborador) {
            return res.status(404).json({ message: "Colaborador no encontrado" });
        }


        colaborador.estado = !Boolean(colaborador.estado);
        await colaborador.save();

        console.log(`El colaborador de ID ${id} está ${colaborador.estado ? 'Activo' : 'Inactivo'}`);

        res.redirect('/colaboradores');

    } catch (error) {
        console.error("Error al cambiar el estado del colaborador:", error);
        res.status(500).json({ message: "Error al actualizar estado", error: error.message });
    }
};

export { insertColaborador, getColaboradores, updateColaborador, rendUpdateColaborador, cambiarColaboradorEstado, agregarVista };
