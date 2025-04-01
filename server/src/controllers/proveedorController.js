import Proveedores from '../models/proveedorModel.js'; // Corrected filename

// Método para agregar un proveedor
const insertProveedor = async (req, res) => {
  try {
    const { nombre, contacto, telefono, correo, direccion } = req.body;

    if (!nombre) {
      return res.status(400).json({ message: "El nombre es obligatorio" });
    }

    await Proveedores.create({
      nombre,
      contacto,
      telefono,
      correo,
      direccion,
      estado: true
    });

    console.log("Proveedor creado con éxito");
    res.redirect("/proveedores"); // Ajusta la ruta según tu vista
  } catch (error) {
    console.error("Error al crear el proveedor:", error);
    res.status(500).json({ message: "Error al agregar proveedor", error: error.message });
  }
};

// Método para renderizar la vista de agregar proveedor
const rendInsertProveedor = async (req, res) => {
  try {
    res.render("proveedores/proveedoresAgregar", { layout: 'layouts/layout' });
  } catch (error) {
    console.error("Error al renderizar vista de agregar proveedor:", error);
    res.render("proveedores/proveedoresAgregar", { layout: 'layouts/layout', mensaje: "Error al cargar la vista" });
  }
};

// Método para obtener y renderizar la lista de proveedores
const getProveedores = async (req, res) => {
  try {
    const proveedores = await Proveedores.findAll();

    if (proveedores.length > 0) {
      console.log(`Se encontraron ${proveedores.length} proveedores.`);
      res.render("proveedores/proveedores", { proveedores, mensaje: null, layout: 'layouts/layout' });
    } else {
      console.log("No se encontraron proveedores.");
      res.render("proveedores/proveedores", { proveedores: [], mensaje: "No hay proveedores registrados.", layout: 'layouts/layout' });
    }
  } catch (error) {
    console.error("Error al obtener los proveedores:", error);
    res.render("proveedores/proveedores", { proveedores: [], mensaje: "Error al cargar los proveedores.", layout: 'layouts/layout' });
  }
};

// Método para actualizar un proveedor
const updateProveedor = async (req, res) => {
  try {
    const { nombre, contacto, telefono, correo, direccion } = req.body;
    const { id } = req.params;

    if (!id || !nombre) {
      return res.status(400).json({ message: "ID y nombre son obligatorios" });
    }

    const proveedor = await Proveedores.findByPk(id);
    if (!proveedor) {
      return res.status(404).json({ message: "Proveedor no encontrado" });
    }

    await proveedor.update({
      nombre,
      contacto,
      telefono,
      correo,
      direccion
    });

    console.log("Proveedor actualizado con éxito");
    res.redirect("/proveedores");
  } catch (error) {
    console.error("Error al actualizar el proveedor:", error);
    res.status(500).json({ message: "Error al actualizar proveedor", error: error.message });
  }
};

// Método para renderizar la vista de edición de un proveedor
const rendUpdateProveedor = async (req, res) => {
  try {
    const { id } = req.params;
    const proveedor = await Proveedores.findByPk(id);

    if (!proveedor) {
      console.log("Proveedor no encontrado");
      return res.status(404).send("Proveedor no encontrado");
    }

    res.render("proveedores/proveedoresEditar", { proveedor, layout: 'layouts/layout' });
  } catch (error) {
    console.error("Error al obtener el proveedor:", error);
    res.status(500).send("Error interno del servidor");
  }
};

// Método para cambiar el estado de un proveedor (activar/desactivar)
const cambiarProveedorEstado = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({ message: "ID es obligatorio" });
    }

    const proveedor = await Proveedores.findByPk(id);
    if (!proveedor) {
      return res.status(404).json({ message: "Proveedor no encontrado" });
    }

    proveedor.estado = !proveedor.estado;
    await proveedor.save();

    console.log(`El proveedor de ID ${id} está ${proveedor.estado ? 'Activo' : 'Inactivo'}`);
    res.redirect("/proveedores");
  } catch (error) {
    console.error("Error al cambiar el estado del proveedor:", error);
    res.status(500).json({ message: "Error al cambiar el estado del proveedor", error: error.message });
  }
};

export {
  insertProveedor,
  getProveedores,
  updateProveedor,
  rendUpdateProveedor,
  cambiarProveedorEstado,
  rendInsertProveedor
};
