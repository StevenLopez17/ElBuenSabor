import Horarios from "../models/horarioModel.js"

const getHorarios = async (req, res) => {
    try {
        const horarios = await Horarios.findAll({
            attributes: ['id', 'descripcion']
        });

        res.render('horariosAdmin/horarios', { horarios })
    } catch (error) {
        console.error('Error cargar horarios', error);
        res.status(500).json({ message: "Error al cargar horarios", error: error.message });
    }
};

const agregarHorarioView = async (req, res) => {
    let errores = [];
    let success = [];
    res.render('horariosAdmin/agregarHorario', { errores, success });
}

const agregarHorario = async (req, res) => {
    try {
        let errores = [];
        let success = [];
        const { id, descripcion } = req.body;
        const horario = { id, descripcion };

        const result = await Horarios.create(horario);

        if (!result) {
            return res.render('horariosAdmin/agregarHorario', { errores: [{ msg: 'Algo salió mal, intente de nuevo' }], success });
        }

        return res.render('horariosAdmin/agregarHorario', { success: [{ msg: 'Horario agregado exitosamente' }], errores });

    } catch (error) {
        console.error('Error insertando horario', error);
        return res.status(500).json({ message: "Error al insertar horario", error: error.message });
    }
};

const eliminarHorario = async (req, res) => {
    try {
        const { id } = req.params;
        let errores = [];
        let success = [];
        const result = await Horarios.destroy({ where: { id } });

        if (!result) {
            return res.render('horariosAdmin/horarios', {
                errores: [{ msg: 'No se encontró el horario para eliminar.' }]
            });
        }

        res.redirect('/horarios');

    } catch (error) {
        console.error('Error eliminando horario', error);
        return res.status(500).json({ message: "Error al eliminar horario", error: error.message });
    }
};

export { getHorarios, agregarHorarioView, agregarHorario, eliminarHorario };