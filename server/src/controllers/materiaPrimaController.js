import MateriaPrima from '../models/materiaPrimaModel.js';

// Método para agregar una materia prima
export const insertMateriaPrima = async (req, res) => {
  try {
    const { nombre, precio, stock } = req.body;

    if (!nombre) {
      return res.status(400).json({ message: "Nombre es obligatorio" });
    }

    await MateriaPrima.create({
      nombre,
      precio,
      stock,
    });

    console.log("Materia prima creada con éxito");
    res.redirect("/materiaPrima");
  } catch (error) {
    console.error("Error al crear la materia prima:", error);
    res
      .status(500)
      .json({ message: "Error al agregar materia prima", error: error.message });
  }
};

// Método para obtener las materias primas
export const getMateriaPrima = async (req, res) => {
  try {
    const materiasPrimas = await MateriaPrima.findAll({
      attributes: ['id', 'nombre', 'precio', 'stock'] // Remove createdAt and updatedAt
    });
    res.render('materiasPrimas/materiaPrima', { materiasPrimas, mensaje: null });
  } catch (error) {
    console.error('Error al obtener las materias primas:', error);
    res.render('materiasPrimas/materiaPrima', { materiasPrimas: [], mensaje: 'Error al obtener las materias primas' });
  }
};

// Método para actualizar una materia prima
export const updateMateriaPrima = async (req, res) => {
  try {
    const { nombre, precio, stock } = req.body;
    const { id } = req.params;

    if (!id || !nombre) {
      return res.status(400).json({ message: "ID y Nombre son obligatorios" });
    }

    const materiaPrima = await MateriaPrima.findByPk(id);
    if (!materiaPrima) {
      return res.status(404).json({ message: "Materia prima no encontrada" });
    }

    await materiaPrima.update({
      nombre,
      precio,
      stock
    });

    console.log("Materia prima actualizada con éxito");
    res.redirect("/materiaPrima");

  } catch (error) {
    console.error("Error al actualizar la materia prima:", error);
    res.status(500).json({ message: "Error al actualizar materia prima", error: error.message });
  }
};

// Método para eliminar una materia prima
export const deleteMateriaPrima = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({ message: "ID es obligatorio" });
    }

    const materiaPrima = await MateriaPrima.findByPk(id);

    if (!materiaPrima) {
      return res.status(404).json({ message: "Materia prima no encontrada" });
    }

    await materiaPrima.destroy();

    console.log("Materia prima eliminada con éxito");
    res.redirect("/materiaPrima");
  } catch (error) {
    console.error("Error al eliminar la materia prima:", error);
    res.status(500).json({ message: "Error al eliminar materia prima", error: error.message });
  }
};

// Método para renderizar la vista de edición de una materia prima
export const rendUpdateMateriaPrima = async (req, res) => {
  try {
    console.log("ID recibido:", req.params.id);

    const materiaPrima = await MateriaPrima.findByPk(req.params.id);

    if (!materiaPrima) {
      console.log("Materia prima no encontrada en la base de datos");
      return res.status(404).send("Materia prima no encontrada");
    }

    console.log("Materia prima seleccionada:", JSON.stringify(materiaPrima, null, 2));

    res.render('materiasPrimas/materiaPrimaEditar', {
      materiaPrima: materiaPrima
    });

  } catch (error) {
    console.error("Error al obtener la materia prima:", error);
    res.status(500).send("Error interno del servidor");
  }
};

// Método para renderizar la vista de agregar una materia prima
export const rendAgregarMateriaPrima = (req, res) => {
  res.render('materiasPrimas/materiaPrimaAgregar');
};


