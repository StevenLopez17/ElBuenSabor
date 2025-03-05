import Formulaciones from '../models/formulacionesModel.js';
import GestionFormulaciones from '../models/gestion_formulacionesModel.js';
import MateriaPrima from '../models/materiaPrimaModel.js';

//Renderiza la vista para agregar fórmulas con materias primas
const renderizaForm = async (req, res) => {
    try {
        const materiasPrimas = await MateriaPrima.findAll();
        res.render('formulaciones/agregarFormulaciones', { materiasPrimas });
    } catch (error) {
        console.error("Error al cargar materias primas:", error);
        res.render('formulaciones/agregarFormulaciones', { materiasPrimas: [], mensaje: "Error al cargar las materias primas" });
    }
};

//Guarda la nueva formulación y sus ingredientes
const guardarFormulacion = async (req, res) => {
    try {
        console.log("Datos ingresados:", req.body); 

        const { nombre, materia_id, cantidad, precio_total, total_producir } = req.body;

        if (!nombre || !materia_id || materia_id.length === 0 || !total_producir) {
            return res.status(400).json({ mensaje: "Todos los campos son obligatorios" });
        }

        let precioFinal = precio_total.reduce((acc, val) => acc + parseFloat(val), 0);

        // Crear la formulación con el `total_producir`
        const nuevaFormulacion = await Formulaciones.create({
            nombre,
            total_producir: parseInt(total_producir),
            precio_total: precioFinal
        });

        // Insertar las materias primas en 'gestion_formulaciones'
        for (let i = 0; i < materia_id.length; i++) {
            await GestionFormulaciones.create({
                formulacion_id: nuevaFormulacion.id,
                materia_prima_id: materia_id[i],
                cantidad: cantidad[i]
            });
        }

        console.log("Fórmula creada con éxito");
        res.redirect('/materiaPrima');

    } catch (error) {
        console.error("Error al guardar la formulación:", error);
        res.status(500).json({ mensaje: "Error al guardar la formulación" });
    }
};

const getVistaFormulaciones = async (req, res) => {
    try {
        const formulaciones = await Formulaciones.findAll({
            include: [
                {
                    model: GestionFormulaciones,
                    as: "Gestiones",
                    include: [{ model: MateriaPrima, as: "MateriaPrima" }]
                }
            ]
        });

        if (formulaciones.length > 0) {
            console.log(`Se encontraron ${formulaciones.length} formulaciones.`);
            res.render("formulaciones/formulaciones", {
                formulaciones,
                mensaje: null,
            });
        } else {
            console.log(`No se encontraron formulaciones.`);
            res.render("formulaciones/formulaciones", {
                formulaciones: [],
                mensaje: "No hay formulaciones almacenadas.",
            });
        }
    } catch (error) {
        console.error("Error al obtener las formulaciones:", error);
        res.render("formulaciones/formulaciones", {
            formulaciones: [],
            mensaje: "Error al cargar las formulaciones.",
        });
    }
};




export { renderizaForm, guardarFormulacion, getVistaFormulaciones };
