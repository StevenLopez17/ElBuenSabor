import Pedidos from "../models/pedidoModel.js";
import PedidoDetalle from "../models/pedidoDetalle.js";
import Productos from "../models/productoModel.js";
import sequelize, { Op } from "../../config/database.js";
import Distribuidores from '../models/distribuidorModel.js';
import Usuario from "../models/usuarios.js";
import PdfPrinter from 'pdfmake';
import { emailPagoPendiente } from '../../helpers/email.js';
import supabase, { supabaseAdmin } from '../../config/supabaseClient.js';

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Función para crear un pedido
const insertPedido = async (req, res) => {
  let t;
  try {
    const { fecha, distribuidorId, items } = req.body;
    let finalDistribuidorId = distribuidorId;

    // Si es un distribuidor (rol = 3), obtener su distribuidorId automáticamente
    if (req.usuario.rol === 3) {
      console.log("=== DEBUG: Buscando distribuidor ===");
      console.log("Usuario ID:", req.usuario.id);
      console.log("Usuario rol:", req.usuario.rol);
      
      let distribuidor = await Distribuidores.findOne({
        where: { usuario_id: req.usuario.id }
      });
      
      console.log("Distribuidor encontrado:", distribuidor);
      
      // Si no existe el distribuidor, crearlo automáticamente
      if (!distribuidor) {
        console.log("Creando distribuidor automáticamente para usuario_id:", req.usuario.id);
        
        try {
          distribuidor = await Distribuidores.create({
            usuario_id: req.usuario.id,
            empresa: `Empresa de ${req.usuario.nombre}`,
            telefono: '000000000',
            direccion: 'Dirección por defecto',
            zona_cobertura: 'Zona por defecto',
            fecha_registro: new Date(),
            estado: true
          });
          
          console.log("Distribuidor creado automáticamente:", distribuidor.id);
        } catch (error) {
          console.error("Error al crear distribuidor:", error);
          return res.status(400).json({ message: "Error al crear información del distribuidor" });
        }
      }
      
      finalDistribuidorId = distribuidor.id;
      console.log("Distribuidor ID asignado:", finalDistribuidorId);
    }

    if (!fecha || !finalDistribuidorId) {
      return res.status(400).json({ message: "Fecha y distribuidor son obligatorios" });
    }

    if (!items || typeof items !== 'object') {
      return res.redirect('/pedido/agregar?error=seleccioneProductos');
    }

    // Convertir el objeto items a un array de items válidos
    const itemsArray = Object.values(items).filter(item => 
      item && item.productoId && item.cantidad && parseFloat(item.cantidad) > 0
    );

    if (itemsArray.length === 0) {
      return res.redirect('/pedido/agregar?error=seleccioneProductos');
    }

    // Verificar que el distribuidor existe
    const distribuidor = await Distribuidores.findByPk(finalDistribuidorId);
    if (!distribuidor) {
      return res.status(400).json({ message: "Distribuidor no encontrado" });
    }

    // Inicia una transacción
    t = await sequelize.transaction();

    // Crear el pedido con precioTotal inicialmente en 0 y estado de entrega por defecto
    const nuevoPedido = await Pedidos.create(
      { 
        fecha, 
        distribuidorId: finalDistribuidorId, 
        precioTotal: 0,
        estadoDeEntrega: 'no entregado',
        estadoDePago: 'pendiente'
      },
      { transaction: t }
    );

    let precioTotal = 0;
    let validItems = 0;

    
    for (const item of itemsArray) {
      const { productoId, cantidad } = item;

      
      const producto = await Productos.findByPk(productoId);
      if (!producto) {
        console.warn(`Producto con id ${productoId} no encontrado. Se omitirá este ítem.`);
        continue;
      }

      const precioUnitario = producto.precio;
      const subtotal = precioUnitario * cantidad;
      precioTotal += subtotal;
      validItems++;

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

    if (validItems === 0) {
      throw new Error("No se seleccionó ningún producto válido para el pedido");
    }

    // Actualizar el precioTotal del pedido
    nuevoPedido.precioTotal = precioTotal;
    await nuevoPedido.save({ transaction: t });

    await t.commit();

    console.log("Pedido creado con éxito");
    res.redirect('/pedido?pedidoAgregado=true'); 
  } catch (error) {
    if (t) await t.rollback();
    console.error("Error al crear el pedido:", error);
    res.status(500).json({ message: "Error al crear pedido", error: error.message });
  }
};

// Función para obtener y renderizar la lista de pedidos
const getPedido = async (req, res) => {
  try {
    const notificacionPagoPendiente = req.query.notificacionPagoPendiente === 'true';
    const pedidoAgregado = req.query.pedidoAgregado === 'true';
    const pedidoEditado = req.query.pedidoEditado === 'true';
    const pedidoAprobado = req.query.pedidoAprobado === 'true';
    const accesoDenegado = req.query.error === 'accesoDenegado';
    
    if (!req.usuario) {
      return res.redirect('/login');
    }
    
    const { id, rol } = req.usuario;

    // Si no es administrador, solo puede ver sus propios pedidos
    if (rol !== 1) {
      // Para distribuidores (rol = 3)
      if (rol === 3) {
        const distribuidor = await Distribuidores.findOne({ where: { usuario_id: id } });
        if (!distribuidor) {
          console.error(`Distribuidor no encontrado para usuario_id: ${id}`);
          return res.render("pedidos/pedidos", {
            pedidos: [],
            mensaje: "Error: No se encontró información del distribuidor. Contacte al administrador.",
            rol,
            notificacionPagoPendiente: false,
            pedidoAgregado: false,
            pedidoEditado: false,
            pedidoAprobado: false,
            accesoDenegado: false
          });
        }

        const pedidos = await Pedidos.findAll({
          where: {
            distribuidorId: distribuidor.id,
            estadoDeEntrega: "no entregado",
            estadoDePago: "pendiente"
          },
          include: [
            {
              model: PedidoDetalle,
              as: 'detalles',
              include: [{ model: Productos, as: 'producto' }]
            },
            {
              model: Distribuidores,
              as: 'Distribuidor',
              attributes: ['id', 'empresa']
            }
          ]
        });

        const pedidosWithProductos = pedidos.map(pedido => {
          const pedidoJSON = pedido.toJSON();
          const precioTotal = pedidoJSON.detalles.reduce((total, d) => total + parseFloat(d.subtotal || 0), 0);
          return {
            ...pedidoJSON,
            precioTotal,
            empresa: pedido.Distribuidor?.empresa || 'No disponible',
            productos: pedidoJSON.detalles.map(d => ({ nombre: d.producto.nombre, cantidad: d.cantidad }))
          };
        });

        return res.render("pedidos/pedidos", {
          pedidos: pedidosWithProductos,
          mensaje: pedidos.length ? null : "No hay pedidos registrados.",
          rol,
          notificacionPagoPendiente,
          pedidoAgregado,
          pedidoEditado,
          pedidoAprobado,
          accesoDenegado
        });
      } 
      // Para otros roles no administradores (rol = 2)
      else {
        // Buscar si el usuario está asociado a algún distribuidor
        const distribuidor = await Distribuidores.findOne({ where: { usuario_id: id } });
        if (distribuidor) {
          const pedidos = await Pedidos.findAll({
            where: {
              distribuidorId: distribuidor.id,
              estadoDeEntrega: "no entregado",
              estadoDePago: "pendiente"
            },
            include: [
              {
                model: PedidoDetalle,
                as: 'detalles',
                include: [{ model: Productos, as: 'producto' }]
              },
              {
                model: Distribuidores,
                as: 'Distribuidor',
                attributes: ['id', 'empresa']
              }
            ]
          });

          const pedidosWithProductos = pedidos.map(pedido => {
            const pedidoJSON = pedido.toJSON();
            const precioTotal = pedidoJSON.detalles.reduce((total, d) => total + parseFloat(d.subtotal || 0), 0);
            return {
              ...pedidoJSON,
              precioTotal,
              empresa: pedido.Distribuidor?.empresa || 'No disponible',
              productos: pedidoJSON.detalles.map(d => ({ nombre: d.producto.nombre, cantidad: d.cantidad }))
            };
          });

          return res.render("pedidos/pedidos", {
            pedidos: pedidosWithProductos,
            mensaje: pedidos.length ? null : "No hay pedidos registrados.",
            rol,
            notificacionPagoPendiente,
            pedidoAgregado,
            pedidoEditado,
            pedidoAprobado,
            accesoDenegado
          });
        } else {
          // Si no está asociado a ningún distribuidor, mostrar mensaje
          return res.render("pedidos/pedidos", {
            pedidos: [],
            mensaje: "No tiene pedidos asociados.",
            rol,
            notificacionPagoPendiente: false,
            pedidoAgregado: false,
            pedidoEditado: false,
            pedidoAprobado: false,
            accesoDenegado: false
          });
        }
      }
    } 
    // Para administradores (rol = 1), mostrar todos los pedidos
    else {
      const pedidos = await Pedidos.findAll({
        where: {
          estadoDeEntrega: "no entregado",
          estadoDePago: "pendiente"
        },
        include: [
          {
            model: PedidoDetalle,
            as: 'detalles',
            include: [{ model: Productos, as: 'producto' }]
          },
          {
            model: Distribuidores,
            as: 'Distribuidor',
            attributes: ['id', 'empresa']
          }
        ]
      });

      const pedidosWithProductos = pedidos.map(pedido => {
        const pedidoJSON = pedido.toJSON();
        const precioTotal = pedidoJSON.detalles.reduce((total, d) => total + parseFloat(d.subtotal || 0), 0);
        return {
          ...pedidoJSON,
          precioTotal,
          empresa: pedido.Distribuidor?.empresa || 'No disponible',
          productos: pedidoJSON.detalles.map(d => ({ nombre: d.producto.nombre, cantidad: d.cantidad }))
        };
      });

      return res.render("pedidos/pedidos", {
        pedidos: pedidosWithProductos,
        mensaje: pedidos.length ? null : "No hay pedidos registrados.",
        rol,
        notificacionPagoPendiente,
        pedidoAgregado,
        pedidoEditado,
        pedidoAprobado,
        accesoDenegado
      });
    }
  } catch (error) {
    console.error("Error al obtener los pedidos:", error);
    res.render("pedidos/pedidos", {
      pedidos: [],
      mensaje: "Error al cargar los pedidos.",
      rol: req.usuario?.rol || null,
      notificacionPagoPendiente: false,
      pedidoAgregado: false,
      pedidoEditado: false,
      pedidoAprobado: false,
      accesoDenegado: false
    });
  }
};



// Función para obtener y renderizar todos los pedidos
const getTodosPedidos = async (req, res) => {
  try {
    const { id, rol } = req.usuario

    // Get current month's start and end dates
    const today = new Date();
    const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
    const endOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

    // Si no es administrador, solo puede ver sus propios pedidos
    if (rol !== 1) {
      const distribuidor = await Distribuidores.findOne({
        where: {
          usuario_id: id
        }
      });
      
      if (!distribuidor) {
        return res.render("pedidos/pedidostodos", { 
          pedidos: [], 
          mensaje: "No tiene pedidos asociados.", 
          mes: today.toLocaleString('es-ES', { month: 'long' }) 
        });
      }

      const pedidos = await Pedidos.findAll({
        where: {
          distribuidorId: distribuidor.id,
          // Add date filter for current month
          fecha: {
            [Op.between]: [startOfMonth, endOfMonth]
          }
        },
        include: [
          {
            model: PedidoDetalle,
            as: 'detalles',
            include: [
              { model: Productos, as: 'producto' }
            ]
          },
          {
            model: Distribuidores,
            as: 'Distribuidor',
            attributes: ['id', 'empresa']
          }
        ]
      });

      const pedidosWithProductos = pedidos.map(pedido => {
        const pedidoJSON = pedido.toJSON();
        // Calcular el precio total sumando los subtotales de todos los detalles
        const precioTotal = pedidoJSON.detalles.reduce((total, detalle) =>
          total + parseFloat(detalle.subtotal || 0), 0);

        return {
          ...pedidoJSON,
          precioTotal: precioTotal, // Asegurar que precioTotal se establece correctamente
          empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
          productos: pedidoJSON.detalles.map(detalle => ({
            nombre: detalle.producto.nombre,
            cantidad: detalle.cantidad
          }))
        };
      });
      
      res.render("pedidos/pedidostodos", { 
        pedidos: pedidosWithProductos, 
        mensaje: pedidos.length ? null : "No hay pedidos registrados.",
        mes: today.toLocaleString('es-ES', { month: 'long' }) 
      });
    }
    // Para administradores (rol = 1), mostrar todos los pedidos
    else {
      const pedidos = await Pedidos.findAll({
        where: {
          // Add date filter for current month
          fecha: {
            [Op.between]: [startOfMonth, endOfMonth]
          }
        },
        include: [
          {
            model: PedidoDetalle,
            as: 'detalles',
            include: [
              { model: Productos, as: 'producto' }
            ]
          },
          {
            model: Distribuidores,
            as: 'Distribuidor',
            attributes: ['id', 'empresa']
          }
        ]
      });
      const pedidosWithProductos = pedidos.map(pedido => {
        const pedidoJSON = pedido.toJSON();
        // Calcular el precio total sumando los subtotales de todos los detalles
        const precioTotal = pedidoJSON.detalles.reduce((total, detalle) =>
          total + parseFloat(detalle.subtotal || 0), 0);

        return {
          ...pedidoJSON,
          precioTotal: precioTotal, // Asegurar que precioTotal se establece correctamente
          empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
          productos: pedidoJSON.detalles.map(detalle => ({
            nombre: detalle.producto.nombre,
            cantidad: detalle.cantidad
          }))
        };
      });

      if (pedidos.length > 0) {
        console.log(`Se encontraron ${pedidos.length} pedidos.`);
        res.render("pedidos/pedidostodos", { pedidos: pedidosWithProductos, mensaje: null, mes: today.toLocaleString('es-ES', { month: 'long' }) });
      } else {
        console.log("No se encontraron pedidos.");
        res.render("pedidos/pedidostodos", { pedidos: [], mensaje: "No hay pedidos registrados.", mes: today.toLocaleString('es-ES', { month: 'long' }) });
      }
    }

  } catch (error) {
    console.error("Error al obtener todos los pedidos:", error);
    res.render("pedidos/pedidostodos", { pedidos: [], mensaje: "Error al cargar los pedidos." });
  }
};

// Función para actualizar un pedido
const updatePedido = async (req, res) => {
  let t;
  try {
    console.log("Datos recibidos para actualizar pedido:", req.body);
    console.log("Headers:", req.headers);
    const { id } = req.params; // id del pedido (idPedido)
    const { fecha, distribuidorId, estadoDePago, estadoDeEntrega, comprobanteDePago, productos } = req.body;
    console.log("Tipo de estadoDePago:", typeof estadoDePago);
    console.log("Tipo de estadoDeEntrega:", typeof estadoDeEntrega);
    
    console.log("Estado de Pago recibido:", estadoDePago);
    console.log("Estado de Entrega recibido:", estadoDeEntrega);
    console.log("Usuario:", req.usuario);

    // Buscar el pedido a actualizar
    const pedido = await Pedidos.findByPk(id);
    if (!pedido) {
      return res.status(404).json({ message: "Pedido no encontrado" });
    }

    t = await sequelize.transaction();

    // Actualizar campos básicos
    pedido.fecha = fecha || pedido.fecha;
    pedido.distribuidorId = distribuidorId || pedido.distribuidorId;

    // Usar los valores exactos permitidos por el enum estado_pago
    if (estadoDePago !== undefined && estadoDePago !== null) {
      // Asignamos el valor exacto conforme a los valores permitidos en el enum
      switch (estadoDePago.toLowerCase()) {
        case 'pendiente':
          pedido.estadoDePago = 'pendiente';
          break;
        case 'en revision':
        case 'en revisión':
        case 'revision':
        case 'revisión':
          pedido.estadoDePago = 'en revision';
          break;
        case 'aprobado':
        case 'pagado': // Para compatibilidad con el formulario anterior
          pedido.estadoDePago = 'aprobado';
          break;
        default:
          // Si el valor no coincide con ninguno de los casos, usamos el valor predeterminado
          pedido.estadoDePago = 'pendiente';
      }
    }

    // Valores para estado de entrega (asumimos que son "entregado" y "no entregado")
    if (estadoDeEntrega !== undefined && estadoDeEntrega !== null) {
      if (estadoDeEntrega.toLowerCase().includes('no')) {
        pedido.estadoDeEntrega = 'no entregado';
      } else {
        pedido.estadoDeEntrega = 'entregado';
      }
    }

    pedido.comprobanteDePago = comprobanteDePago || pedido.comprobanteDePago;

    // Procesar actualización de cantidades de productos si se envían
    if (productos && Array.isArray(productos) && productos.length > 0) {
      let precioTotal = 0;

      // Actualizar cada detalle del pedido con las nuevas cantidades
      for (const productoActualizado of productos) {
        const { id: detalleId, cantidad } = productoActualizado;

        if (detalleId && cantidad > 0) {
          // Buscar el detalle específico
          const detalle = await PedidoDetalle.findByPk(detalleId, { transaction: t });
          if (detalle) {
            // Buscar el producto para obtener el precio actualizado
            const producto = await Productos.findByPk(detalle.productoId, { transaction: t });
            if (producto) {
              // Actualizar cantidad y recalcular subtotal
              detalle.cantidad = cantidad;
              detalle.subtotal = producto.precio * cantidad;
              await detalle.save({ transaction: t });
            }
          }
        }
      }

      // Recalcular el precio total del pedido
      const detallesActualizados = await PedidoDetalle.findAll({
        where: { pedidoId: id },
        transaction: t
      });

      precioTotal = detallesActualizados.reduce((sum, detalle) => sum + parseFloat(detalle.subtotal), 0);
      pedido.precioTotal = precioTotal;
    }

    // Guardar cambios en el pedido
    await pedido.save({ transaction: t });
    await t.commit();

    console.log("Pedido actualizado exitosamente");
    console.log("Nuevo estado de pago:", pedido.estadoDePago);
    console.log("Nuevo estado de entrega:", pedido.estadoDeEntrega);
    res.redirect("/pedido?pedidoEditado=true");
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
    const { rol } = req.usuario;
    
    const pedido = await Pedidos.findByPk(id, {
      include: [
        { 
          model: PedidoDetalle, 
          as: 'detalles',
          include: [{ model: Productos, as: 'producto' }]
        }
      ]
    });

    if (!pedido) {
      console.log("Pedido no encontrado");
      return res.status(404).send("Pedido no encontrado");
    }

    res.render("pedidos/pedidoEditar", { 
      pedido, 
      rol,
      layout: 'layouts/layout' 
    });
  } catch (error) {
    console.error("Error al obtener el pedido:", error);
    res.status(500).send("Error interno del servidor");
  }
};

// Función para renderizar la vista de agregar un pedido
const rendAgregarPedido = async (req, res) => {
  try {
    const { id, rol } = req.usuario
    
    if (rol == 3) {
      const productos = await Productos.findAll();
      console.log("Productos encontrados:", productos.length);
      
      // Para distribuidores, no necesitamos validar que exista el distribuidor aquí
      // porque se validará en el momento de crear el pedido
      res.render("pedidos/pedidoAgregarDistribuidor", { 
        productos, 
        distribuidorId: null, // Se asignará automáticamente al crear el pedido
        error: req.query.error || null
      });
    }
    else if (rol == 1) {
      const productos = await Productos.findAll();
      const distribuidores = await Distribuidores.findAll();
      res.render("pedidos/pedidoAgregarAdmin", { 
        productos, 
        distribuidores,
        error: req.query.error || null
      });
    } else {
      res.redirect('/pedido?error=accesoDenegado')
    }
  } catch (error) {
    console.error("Error al renderizar vista de agregar pedido:", error);
    res.render("pedidos/pedidoAgregarDistribuidor", { 
      productos: [], 
      distribuidorId: null,
      error: "Error al cargar datos para el pedido. Contacte al administrador."
    });
  }
};



//PDF

const fontsPath = path.join(__dirname, '..', 'client', 'fonts');
const logoPath = path.join(__dirname, '..', '..', '..', 'public', 'images', 'Logo-Rellenos-El-Buen-Sabor-Version-Naranja.png');
const logoBase64 = fs.readFileSync(logoPath).toString('base64');
const printer = new PdfPrinter({
  Roboto: {
    normal: path.join(fontsPath, 'Roboto-Regular.ttf'),
    bold: path.join(fontsPath, 'Roboto-Medium.ttf'),
    italics: path.join(fontsPath, 'Roboto-Italic.ttf'),
    bolditalics: path.join(fontsPath, 'Roboto-MediumItalic.ttf')
  }
});

// Función para formatear montos con CRC
const formatCRC = (valor) => `CRC ${valor.toLocaleString()}`;

const exportarPDFPedido = async (req, res) => {
  try {
    const { id } = req.params;

    const pedido = await Pedidos.findByPk(id, {
      include: [
        {
          model: PedidoDetalle,
          as: 'detalles',
          include: [{ model: Productos, as: 'producto' }]
        },
        {
          model: Distribuidores,
          as: 'Distribuidor'
        }
      ]
    });

    if (!pedido) {
      return res.status(404).send("Pedido no encontrado");
    }

    const tableBody = pedido.detalles.map(detalle => [
      detalle.producto.nombre,
      `${detalle.cantidad.toFixed(2)} kg`,
      formatCRC(detalle.precioUnitario),
      formatCRC(detalle.subtotal),
      formatCRC(0),
      detalle.producto.id.toString().padStart(4, '0')
    ]);

    const docDefinition = {
      defaultStyle: { font: 'Roboto' },
      content: [
        {
          image: `data:image/png;base64,${logoBase64}`,
          width: 120,
          alignment: 'left',
          margin: [0, 0, 0, 10]
        },
        { text: 'CALBARR S.R.L.\nRELLENOS EL BUEN SABOR', fontSize: 14, bold: true, margin: [0, 0, 0, 10] },
        { text: 'Correo: rellenoselbuensabor@gmail.com\nTeléfono: +(506) 2102-0518' },
        { text: `Fecha de emisión: ${pedido.fecha}` },
        { text: `Condición de Venta: Contado\nMedio de Pago: Efectivo\nDistribuidor: ${pedido.Distribuidor?.empresa || 'Desconocido'}` },
        {
          table: {
            headerRows: 1,
            widths: ['*', 'auto', 'auto', 'auto', 'auto', 'auto'],
            body: [
              ['Descripción', 'Cantidad', 'Precio', 'Subtotal', 'Impuesto', 'Código'],
              ...tableBody
            ]
          },
          margin: [0, 10, 0, 10]
        },
        {
          table: {
            widths: ['*', 'auto'],
            body: [
              ['Subtotal', formatCRC(pedido.precioTotal)],
              ['Total del Comprobante', formatCRC(pedido.precioTotal)]
            ]
          }
        },
      ]
    };

    const pdfDir = path.join(__dirname, '..', 'client', 'pdf');
    if (!fs.existsSync(pdfDir)) {
      fs.mkdirSync(pdfDir, { recursive: true });
    }

    const filepath = path.join(pdfDir, `Pedido_${id}.pdf`);

    const pdfDoc = printer.createPdfKitDocument(docDefinition);
    const stream = fs.createWriteStream(filepath);
    pdfDoc.pipe(stream);
    pdfDoc.end();

    stream.on('finish', () => {
      res.download(filepath, `Pedido_${id}.pdf`, () => {
        fs.unlinkSync(filepath);
      });
    });

  } catch (error) {
    console.error('Error al exportar PDF del pedido:', error);
    res.status(500).json({ message: 'Error al exportar PDF del pedido', error: error.message });
  }
};

//Funcion enviar email pagos pendientes
const notificarPagoPendiente = async (req, res) => {
  try {
    const { idpedido } = req.params;

    const pedido = await Pedidos.findByPk(idpedido, {
      include: [
        {
          model: PedidoDetalle,
          as: 'detalles',
          include: [{ model: Productos, as: 'producto' }]
        },
        {
          model: Distribuidores,
          as: 'Distribuidor'
        }
      ]
    });
    const usuario = await Usuario.findByPk(pedido.Distribuidor.usuario_id)
    if (!usuario) {
      res.redirect('/pedido')
    }
    emailPagoPendiente({
      nombre: usuario.nombre,
      email: usuario.correo,
      precioTotal: pedido.precioTotal,
      pendiente: pedido.pendiente,
      fecha: pedido.fecha,
      idpedido: pedido.idpedido
    });
    console.log('Correo enviado..')
    res.redirect('/pedido?notificacionPagoPendiente=true');
    // console.log(JSON.stringify(pedido, null, 2));
  } catch (error) {
    console.error('Error al enviar email de pago pendiente:', error);
  }
}

// Función para subir un comprobante de pago
const subirComprobantePago = async (req, res) => {
  const { id } = req.params;
  const file = req.file;

  if (!file) return res.status(400).json({ error: 'No se recibió ningún archivo' });

  // Validar formato de archivo
  const allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];
  if (!allowedMimeTypes.includes(file.mimetype)) {
    return res.status(400).json({ error: 'Formato no permitido. Use PDF, JPG o PNG' });
  }

  const fileName = `${Date.now()}-${file.originalname}`;
  const bucketName = 'Comprobantes Pedidos';

  try {
    // Verificar si el bucket existe, si no, crearlo
    const { data: buckets, error: listError } = await supabaseAdmin
      .storage
      .listBuckets();

    if (listError) {
      console.error('Error al listar buckets:', listError);
      return res.status(500).json({ error: 'Error al verificar buckets de almacenamiento' });
    }

    // Verificar si el bucket "Comprobantes Pedidos" existe
    const bucketExists = buckets.some(bucket => bucket.name === bucketName);

    // Si el bucket no existe, crearlo
    if (!bucketExists) {
      console.log(`El bucket "${bucketName}" no existe. Creándolo...`);
      const { error: createError } = await supabaseAdmin.storage.createBucket(bucketName, {
        public: true, // Hacer el bucket público para que las URLs sean accesibles
        fileSizeLimit: 5242880, // Límite de 5MB por archivo
      });

      if (createError) {
        console.error('Error al crear el bucket:', createError);
        return res.status(500).json({ error: 'Error al crear el bucket de almacenamiento' });
      }
      console.log(`Bucket "${bucketName}" creado exitosamente.`);
    }

    // Paso 1: Subir la imagen a Supabase utilizando supabaseAdmin
    const { error: uploadError } = await supabaseAdmin.storage
      .from(bucketName)
      .upload(`pedidos/${id}/${fileName}`, file.buffer, {
        contentType: file.mimetype,
        upsert: true
      });

    if (uploadError) {
      console.error('Error al subir el comprobante:', uploadError);
      return res.status(500).json({ error: 'Error al subir el comprobante: ' + JSON.stringify(uploadError) });
    }

    // Paso 2: Obtener la URL pública de la imagen
    const { data } = supabaseAdmin.storage
      .from(bucketName)
      .getPublicUrl(`pedidos/${id}/${fileName}`);

    const imageUrl = data.publicUrl;

    // Paso 3: Actualizar el registro del pedido con la URL
    const pedido = await Pedidos.findByPk(id);
    if (!pedido) {
      return res.status(404).json({ error: 'Pedido no encontrado' });
    }

    pedido.comprobanteDePago = imageUrl;
    await pedido.save();

    return res.status(200).json({ url: imageUrl });
  } catch (error) {
    console.error('Error general en subirComprobantePago:', error);
    res.status(500).json({ error: 'Error en el servidor', detalles: error.message });
  }
};

// Función para aprobar un pedido
const aprobarPedido = async (req, res) => {
  try {
    const { id } = req.params;
    const { id: userId, rol } = req.usuario;

    // Solo administradores pueden aprobar pedidos
    if (rol !== 1) {
      return res.status(403).json({ error: 'No tiene permisos para aprobar pedidos' });
    }

    const pedido = await Pedidos.findByPk(id, {
      include: [
        {
          model: Distribuidores,
          as: 'Distribuidor',
          attributes: ['empresa', 'telefono']
        }
      ]
    });

    if (!pedido) {
      return res.status(404).json({ error: 'Pedido no encontrado' });
    }

    // Cambiar estado a aprobado
    pedido.estadoDePago = 'aprobado';
    await pedido.save();

    // Aquí se podría enviar una notificación al distribuidor
    console.log(`Pedido ${id} aprobado. Notificar a distribuidor: ${pedido.Distribuidor?.empresa}`);

    res.redirect('/pedido?pedidoAprobado=true');
  } catch (error) {
    console.error('Error al aprobar pedido:', error);
    res.status(500).json({ error: 'Error al aprobar pedido' });
  }
};

// Función para obtener y renderizar historial de pedidos
const getHistorialPedidos = async (req, res) => {
  try {
    const { id, rol } = req.usuario

    // Si no es administrador, solo puede ver sus propios pedidos
    if (rol !== 1) {
      const distribuidor = await Distribuidores.findOne({
        where: {
          usuario_id: id
        }
      });
      
      if (!distribuidor) {
        return res.render("pedidos/historialPedidos", { 
          pedidos: [], 
          mensaje: "No tiene pedidos asociados." 
        });
      }

      const pedidos = await Pedidos.findAll({
        where: {
          distribuidorId: distribuidor.id
        },
        include: [
          {
            model: PedidoDetalle,
            as: 'detalles',
            include: [
              { model: Productos, as: 'producto' }
            ]
          },
          {
            model: Distribuidores,
            as: 'Distribuidor',
            attributes: ['id', 'empresa']
          }
        ],
        order: [['fecha', 'DESC']]
      });

      const pedidosWithProductos = pedidos.map(pedido => {
        const pedidoJSON = pedido.toJSON();
        // Calcular el precio total sumando los subtotales de todos los detalles
        const precioTotal = pedidoJSON.detalles.reduce((total, detalle) =>
          total + parseFloat(detalle.subtotal || 0), 0);

        return {
          ...pedidoJSON,
          precioTotal: precioTotal,
          empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
          productos: pedidoJSON.detalles.map(detalle => ({
            nombre: detalle.producto.nombre,
            cantidad: detalle.cantidad
          }))
        };
      });
      
      res.render("pedidos/historialPedidos", { 
        pedidos: pedidosWithProductos, 
        mensaje: pedidos.length ? null : "No hay pedidos registrados." 
      });
    }
    // Para administradores (rol = 1), mostrar todos los pedidos
    else {
      const pedidos = await Pedidos.findAll({
        include: [
          {
            model: PedidoDetalle,
            as: 'detalles',
            include: [
              { model: Productos, as: 'producto' }
            ]
          },
          {
            model: Distribuidores,
            as: 'Distribuidor',
            attributes: ['id', 'empresa']
          }
        ],
        order: [['fecha', 'DESC']]
      });
      const pedidosWithProductos = pedidos.map(pedido => {
        const pedidoJSON = pedido.toJSON();
        // Calcular el precio total sumando los subtotales de todos los detalles
        const precioTotal = pedidoJSON.detalles.reduce((total, detalle) =>
          total + parseFloat(detalle.subtotal || 0), 0);

        return {
          ...pedidoJSON,
          precioTotal: precioTotal,
          empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
          productos: pedidoJSON.detalles.map(detalle => ({
            nombre: detalle.producto.nombre,
            cantidad: detalle.cantidad
          }))
        };
      });

      if (pedidos.length > 0) {
        res.render("pedidos/historialPedidos", { pedidos: pedidosWithProductos, mensaje: null });
      } else {
        res.render("pedidos/historialPedidos", { pedidos: [], mensaje: "No hay pedidos registrados." });
      }
    }

  } catch (error) {
    console.error("Error al obtener el historial de pedidos:", error);
    res.render("pedidos/historialPedidos", { pedidos: [], mensaje: "Error al cargar los pedidos." });
  }
};

export {
  insertPedido,
  getPedido,
  getTodosPedidos,
  updatePedido,
  deletePedido,
  rendUpdatePedido,
  rendAgregarPedido,
  exportarPDFPedido,
  notificarPagoPendiente,
  subirComprobantePago,
  getHistorialPedidos,
  aprobarPedido
};
