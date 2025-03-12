import Pedidos from "../models/pedidoModel.js";
import PedidoDetalle from "../models/pedidoDetalle.js";
import Productos from "../models/productoModel.js";
import sequelize from "../../config/database.js";

// Función para crear un pedido
const insertPedido = async (req, res) => {
  let t;
  try {
    console.log("Datos recibidos para crear pedido:", req.body);

    // Se espera que req.body contenga: fecha, distribuidorId e items (arreglo de { productoId, cantidad })
    const { fecha, distribuidorId, items } = req.body;

    if (!fecha || !distribuidorId || !items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: "Faltan datos para crear el pedido" });
    }

    // Inicia una transacción
    t = await sequelize.transaction();

    // Crear el pedido con precioTotal inicialmente en 0
    const nuevoPedido = await Pedidos.create(
      { fecha, distribuidorId, precioTotal: 0 },
      { transaction: t }
    );

    let precioTotal = 0;

    // Procesar cada ítem del pedido
    for (const item of items) {
      const { productoId, cantidad } = item;

      // Buscar el producto para obtener el precio unitario
      const producto = await Productos.findByPk(productoId);
      if (!producto) {
        throw new Error(`Producto con id ${productoId} no encontrado`);
      }

      const precioUnitario = producto.precio;
      const subtotal = precioUnitario * cantidad;
      precioTotal += subtotal;

      // Crear el registro en la tabla de detalles
      await PedidoDetalle.create(
        {
          pedidoId: nuevoPedido.idpedido,
          productoId,
          cantidad,
          precioUnitario,
          subtotal
        },
        { transaction: t }
      );
    }

    // Actualizar el precioTotal del pedido
    nuevoPedido.precioTotal = precioTotal;
    await nuevoPedido.save({ transaction: t });

    await t.commit();

    console.log("Pedido creado con éxito");
    res.redirect("/pedido"); // Ajusta la ruta según tu vista
  } catch (error) {
    if (t) await t.rollback();
    console.error("Error al crear el pedido:", error);
    res.status(500).json({ message: "Error al crear pedido", error: error.message });
  }
};

// Función para obtener y renderizar la lista de pedidos
const getPedido = async (req, res) => {
  try {
    const pedidos = await Pedidos.findAll({
      include: [
        {
          model: PedidoDetalle,
          as: 'detalles',
          include: [
            { model: Productos, as: 'producto' }
          ]
        }
      ]
    });

    if (pedidos.length > 0) {
      console.log(`Se encontraron ${pedidos.length} pedidos.`);
      res.render("pedidos", { pedidos, mensaje: null, layout: 'layouts/layout' });
    } else {
      console.log("No se encontraron pedidos.");
      res.render("pedidos", { pedidos: [], mensaje: "No hay pedidos registrados.", layout: 'layouts/layout' });
    }
  } catch (error) {
    console.error("Error al obtener los pedidos:", error);
    res.render("pedidos", { pedidos: [], mensaje: "Error al cargar los pedidos.", layout: 'layouts/layout' });
  }
};

// Función para actualizar un pedido (incluye actualización de detalles si se envían nuevos ítems)
const updatePedido = async (req, res) => {
  let t;
  try {
    console.log("Datos recibidos para actualizar pedido:", req.body);
    const { id } = req.params; // id del pedido (idPedido)
    const { fecha, distribuidorId, items, estadoDePago, estadoDeEntrega, comprobanteDePago } = req.body;

    // Buscar el pedido a actualizar
    const pedido = await Pedidos.findByPk(id);
    if (!pedido) {
      return res.status(404).json({ message: "Pedido no encontrado" });
    }

    t = await sequelize.transaction();

    // Actualizar campos básicos
    pedido.fecha = fecha || pedido.fecha;
    pedido.distribuidorId = distribuidorId || pedido.distribuidorId;
    pedido.estadoDePago = estadoDePago || pedido.estadoDePago;
    pedido.estadoDeEntrega = estadoDeEntrega || pedido.estadoDeEntrega;
    pedido.comprobanteDePago = comprobanteDePago || pedido.comprobanteDePago;

    let precioTotal = 0;
    // Si se envían nuevos ítems, se actualizan los detalles
    if (items && Array.isArray(items) && items.length > 0) {
      // Eliminar los detalles existentes para el pedido
      await PedidoDetalle.destroy({ where: { pedidoId: pedido.idpedido }, transaction: t });
      
      // Crear nuevos detalles y recalcular el precio total
      for (const item of items) {
        const { productoId, cantidad } = item;
        const producto = await Productos.findByPk(productoId);
        if (!producto) {
          throw new Error(`Producto con id ${productoId} no encontrado`);
        }
        const precioUnitario = producto.precio;
        const subtotal = precioUnitario * cantidad;
        precioTotal += subtotal;

        await PedidoDetalle.create(
          {
            pedidoId: pedido.idpedido,
            productoId,
            cantidad,
            precioUnitario,
            subtotal
          },
          { transaction: t }
        );
      }
      pedido.precioTotal = precioTotal;
    }

    // Guardar cambios en el pedido
    await pedido.save({ transaction: t });
    await t.commit();

    console.log("Pedido actualizado exitosamente");
    res.redirect("/pedido");
  } catch (error) {
    if (t) await t.rollback();
    console.error("Error al actualizar pedido:", error);
    res.status(500).json({ message: "Error al actualizar pedido", error: error.message });
  }
};

// Función para eliminar un pedido
const deletePedido = async (req, res) => {
  try {
    const { id } = req.params;
    const pedido = await Pedidos.findByPk(id);

    if (!pedido) {
      return res.status(404).json({ message: "Pedido no encontrado" });
    }

    await pedido.destroy();
    console.log("Pedido eliminado con éxito");
    res.redirect("/pedido");
  } catch (error) {
    console.error("Error al eliminar pedido:", error);
    res.status(500).json({ message: "Error al eliminar pedido", error: error.message });
  }
};

// Función para renderizar la vista de edición de un pedido
const rendUpdatePedido = async (req, res) => {
  try {
    const { id } = req.params;
    const pedido = await Pedidos.findByPk(id, {
      include: [{ model: PedidoDetalle, as: 'detalles' }]
    });

    if (!pedido) {
      console.log("Pedido no encontrado");
      return res.status(404).send("Pedido no encontrado");
    }

    res.render("pedidoEditar", { pedido, layout: 'layouts/layout' });
  } catch (error) {
    console.error("Error al obtener el pedido:", error);
    res.status(500).send("Error interno del servidor");
  }
};

// Función para renderizar la vista de agregar un pedido
const rendAgregarPedido = async (req, res) => {
  try {
    // Para crear un pedido se puede requerir la lista de productos (y, opcionalmente, distribuidores)
    const productos = await Productos.findAll();
    // Si es necesario, puedes agregar también la lista de distribuidores:
    // const distribuidores = await Distribuidores.findAll();
    res.render("pedidoAgregar", { productos, layout: 'layouts/layout' /*, distribuidores*/ });
  } catch (error) {
    console.error("Error al renderizar vista de agregar pedido:", error);
    res.render("pedidoAgregar", { productos: [], mensaje: "Error al cargar datos para el pedido.", layout: 'layouts/layout' });
  }
};

export { 
  insertPedido, 
  getPedido, 
  updatePedido, 
  deletePedido, 
  rendUpdatePedido, 
  rendAgregarPedido 
};
