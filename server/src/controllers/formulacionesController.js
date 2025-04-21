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
        return res.redirect('/agregarForms?error=camposObligatorios');
      }
  
      // Convertir arrays en formato seguro
      const cantidades = Array.isArray(cantidad) ? cantidad : [cantidad];
      const precios = Array.isArray(precio_total) ? precio_total : [precio_total];
      const materias = Array.isArray(materia_id) ? materia_id : [materia_id];
  
      // Filtrar los ingredientes que no tengan cantidad
      const datosValidos = materias
        .map((id, i) => ({
          materia_id: id,
          cantidad: cantidades[i],
          precio: precios[i]
        }))
        .filter(item => item.cantidad && item.cantidad !== '');
  
      if (datosValidos.length === 0) {
        return res.redirect('/agregarForms?error=sinIngredientesValidos');
      }
  
      let precioFinal = datosValidos.reduce((acc, val) => acc + parseFloat(val.precio || 0), 0);
  
      // Crear la formulación
      const nuevaFormulacion = await Formulaciones.create({
        nombre,
        total_producir: parseInt(total_producir),
        precio_total: precioFinal
      });
  
      // Guardar solo las materias primas válidas
      for (const item of datosValidos) {
        await GestionFormulaciones.create({
          formulacion_id: nuevaFormulacion.id,
          materia_prima_id: item.materia_id,
          cantidad: item.cantidad
        });
      }
  
      console.log("Fórmula creada con éxito");
      res.redirect('/formulaciones?formulacionAgregada=true');
  
    } catch (error) {
      console.error("Error al guardar la formulación:", error);
      res.status(500).json({ mensaje: "Error al guardar la formulación", error: error.message });
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
                formulacionAgregada: req.query.formulacionAgregada === 'true'
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
