import Clientes from "../models/clienteModel.js";
import Distribuidores from "../models/distribuidorModel.js";

//Metodo para agregar un cliente
const insertCliente = async (req, res) => {
  try {
    const { nombre, representante, numero, correo, direccion, distribuidor_id } = req.body;

    if (!nombre) {
      return res.status(400).json({ message: "Nombre es obligatorio" });
    }

    await Clientes.create({
      nombre,
      representante,
      numero,
      correo,
      direccion,
      distribuidor_id,
      estado: true,
    });

    console.log("Cliente creado con éxito");
    res.redirect("/cliente");
  } catch (error) {
    console.error("Error al crear el cliente:", error);
    res
      .status(500)
      .json({ message: "Error al agregar cliente", error: error.message });
  }
};

const rendInsertCliente = async (req, res) => {
  try {

    const distribuidores = await Distribuidores.findAll();

    res.render('clientes/clientesAgregar', {
      layout: 'layouts/layout',
      distribuidores
    });

  } catch (error) {
    console.error("Error al obtener los Distribuidores:", error);
    res.render('clientes/clientesAgregar', {
      layout: 'layouts/layout',
      clientes: [],
      mensaje: "Error al cargar los Distribuidores"
    });
  }
};

const getCliente = async (req, res) => {
  try {
    const { id, rol } = req.usuario;
    if (rol != 1) return res.redirect('/')
    const clientes = await Clientes.findAll({
      include: [{
        model: Distribuidores,
        attributes: ['empresa'],
        as: 'Distribuidor'
      }]
    });

    if (clientes.length > 0) {
      console.log(`Se encontraron ${clientes.length} clientes.`);
      res.render("clientes/clientes", {
        clientes: clientes,
        mensaje: null,
      });
    } else {
      console.log(`No se encontraron clientes.`);
      res.render("clientes/clientes", {
        clientes: [],
        mensaje: "No hay clientes registrados.",
      });
    }
  } catch (error) {
    console.error("Error al obtener los clientes:", error);
    res.render("clientes/clientes", {
      clientes: [],
      mensaje: "Error al cargar los clientes.",
    });
  }
};

const updateCliente = async (req, res) => {
  try {
    const { nombre, representante, numero, correo, direccion, distribuidor_id } = req.body;
    const { id } = req.params;

    if (!id || !nombre) {
      return res.status(400).json({ message: "ID y Nombre son obligatorios" });
    }

    const cliente = await Clientes.findByPk(id);
    if (!cliente) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    await cliente.update({
      nombre,
      representante,
      numero,
      correo,
      direccion,
      id_distribuidor: distribuidor_id
    });

    console.log("Cliente actualizado con éxito");
    res.redirect("/cliente");

  } catch (error) {
    console.error("Error al actualizar el cliente:", error);
    res.status(500).json({ message: "Error al actualizar cliente", error: error.message });
  }
};

const rendUpdateCliente = async (req, res) => {
  try {
    console.log("ID recibido:", req.params.id);

    const cliente = await Clientes.findByPk(req.params.id, {
      include: [{ model: Distribuidores, as: 'Distribuidor', attributes: ['id', 'empresa'] }]
    });

    if (!cliente) {
      console.log("Cliente no encontrado en la base de datos");
      return res.status(404).send("Cliente no encontrado");
    }

    console.log("Cliente seleccionado:", JSON.stringify(cliente, null, 2));

    const distribuidores = await Distribuidores.findAll({ attributes: ['id', 'empresa'] });

    res.render('clientes/clientesEditar', {
      cliente: cliente,
      distribuidores
    });

  } catch (error) {
    console.error("Error al obtener el cliente:", error);
    res.status(500).send("Error interno del servidor");
  }
};

const cambiarClienteEstado = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({ message: "ID es obligatorio" });
    }

    const cliente = await Clientes.findByPk(id);

    if (!cliente) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    cliente.estado = !cliente.estado;

    await cliente.save();

    console.log(`El cliente de ID ${id} está ${cliente.estado ? 'Activo' : 'Inactivo'}`);

    res.redirect('/cliente');
  } catch (error) {
    console.error("Error al cambiar el estado del cliente:", error);
    res.status(500).json({ message: "Error al cambiar el estado del cliente", error: error.message });
  }
};

export { insertCliente, getCliente, updateCliente, rendUpdateCliente, cambiarClienteEstado, rendInsertCliente };



