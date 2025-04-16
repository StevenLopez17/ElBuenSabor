import Pagos from "../models/pagoModel.js";
import Proveedores from "../models/proveedorModel.js";

// Método para registrar un pago
const insertPago = async (req, res) => {
  try {
    const { proveedor_id, fecha_pago, precio, impuesto, referencia, notas } = req.body;

    // Validar que se hayan enviado los campos obligatorios
    if (!proveedor_id || !fecha_pago || !precio || !impuesto) {
      return res.status(400).json({ message: "Proveedor, fecha, precio e impuesto son obligatorios" });
    }

    // Calcular el precio total: precio + impuesto
    const total = parseFloat(precio) + parseFloat(impuesto);

    await Pagos.create({
      proveedor_id,
      fecha_pago,
      precio,
      impuesto,
      precio_total: total,
      referencia,
      notas
    });

    console.log("Pago registrado con éxito");
    res.redirect("/pagos"); // Ajusta la ruta según tu vista
  } catch (error) {
    console.error("Error al registrar el pago:", error);
    res.status(500).json({ message: "Error al registrar pago", error: error.message });
  }
};

// Método para renderizar la vista de agregar un pago
const rendInsertPago = async (req, res) => {
  try {
    // Obtener la lista de proveedores
    const proveedores = await Proveedores.findAll({ attributes: ['id', 'nombre'] });
    res.render("pagos/pagosAgregar", { proveedores, layout: 'layouts/layout', mensaje: null }); // Asegúrate de enviar 'mensaje'
  } catch (error) {
    console.error("Error al renderizar la vista de agregar pago:", error);
    res.render("pagos/pagosAgregar", { proveedores: [], layout: 'layouts/layout', mensaje: "Error al cargar la vista" });
  }
};

// Método para obtener y renderizar la lista de pagos
const getPagos = async (req, res) => {
  try {
    const { id, rol } = req.usuario;
    if (rol != 1) return res.redirect('/')

    const pagos = await Pagos.findAll({
      include: [{
        model: Proveedores,
        as: 'proveedor',
        attributes: ['id', 'nombre']
      }]
    });

    // Asegúrate de convertir los valores numéricos
    const pagosFormateados = pagos.map(pago => ({
      ...pago.toJSON(),
      precio: parseFloat(pago.precio),
      impuesto: parseFloat(pago.impuesto),
      precio_total: parseFloat(pago.precio_total)
    }));

    if (pagosFormateados.length > 0) {
      console.log(`Se encontraron ${pagosFormateados.length} pagos.`);
      res.render("pagos/pagos", { pagos: pagosFormateados, mensaje: null, layout: 'layouts/layout' });
    } else {
      console.log("No se encontraron pagos.");
      res.render("pagos/pagos", { pagos: [], mensaje: "No hay pagos registrados.", layout: 'layouts/layout' });
    }
  } catch (error) {
    console.error("Error al obtener los pagos:", error);
    res.render("pagos/pagos", { pagos: [], mensaje: "Error al cargar los pagos.", layout: 'layouts/layout' });
  }
};

// Método para actualizar un pago
const updatePago = async (req, res) => {
  try {
    const { proveedor_id, fecha_pago, precio, impuesto, referencia, notas } = req.body;
    const { id } = req.params;

    if (!id || !proveedor_id || !fecha_pago || !precio || !impuesto) {
      return res.status(400).json({ message: "ID, proveedor, fecha, precio e impuesto son obligatorios" });
    }

    const pago = await Pagos.findByPk(id);
    if (!pago) {
      return res.status(404).json({ message: "Pago no encontrado" });
    }

    // Calcular el precio total
    const total = parseFloat(precio) + parseFloat(impuesto);

    await pago.update({
      proveedor_id,
      fecha_pago,
      precio,
      impuesto,
      precio_total: total,
      referencia,
      notas
    });

    console.log("Pago actualizado con éxito");
    res.redirect("/pagos");
  } catch (error) {
    console.error("Error al actualizar el pago:", error);
    res.status(500).json({ message: "Error al actualizar pago", error: error.message });
  }
};

// Método para renderizar la vista de edición de un pago
const rendUpdatePago = async (req, res) => {
  try {
    const { id } = req.params;
    const pago = await Pagos.findByPk(id, {
      include: [{ model: Proveedores, as: 'proveedor', attributes: ['id', 'nombre'] }]
    });

    if (!pago) {
      console.log("Pago no encontrado");
      return res.status(404).send("Pago no encontrado");
    }

    const proveedores = await Proveedores.findAll({ attributes: ['id', 'nombre'] });
    res.render("pagos/pagosEditar", { pago, proveedores, layout: 'layouts/layout', mensaje: null }); // Asegúrate de enviar 'mensaje'
  } catch (error) {
    console.error("Error al obtener el pago:", error);
    res.render("pagos/pagosEditar", { pago: null, proveedores: [], layout: 'layouts/layout', mensaje: "Error al cargar la vista" });
  }
};

export {
  insertPago,
  getPagos,
  updatePago,
  rendUpdatePago,
  rendInsertPago
};
