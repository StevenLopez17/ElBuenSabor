import Pedidos from "../models/pedidoModel.js";
import PedidoDetalle from "../models/pedidoDetalle.js";
import Productos from "../models/productoModel.js";
import sequelize from "../../config/database.js";
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
    let validItems = 0;

    // Procesar cada ítem del pedido
    for (const item of items) {
      const { productoId, cantidad } = item;

      // Buscar el producto para obtener el precio unitario
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
    const notificacionPagoPendiente = req.query.notificacionPagoPendiente === 'true';
    const { id, rol } = req.usuario
    if (rol == 3) {
      const distribuidor = await Distribuidores.findOne({
        where: {
          usuario_id: id
        }
      });
      if (!distribuidor) {
        return res.redirect('/');
      }
      const distribuidorId = distribuidor.id
      const pedidos = await Pedidos.findAll({
        where: {
          distribuidorId: distribuidorId,
          estadoDeEntrega: "no entregado",
          estadoDePago: "pendiente"
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
      const pedidosWithProductos = pedidos.map(pedido => ({
        ...pedido.toJSON(),
        empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
        productos: pedido.detalles.map(detalle => ({
          nombre: detalle.producto.nombre,
          cantidad: detalle.cantidad
        }))
      }));

      if (pedidos.length > 0) {
        // console.log(`Se encontraron ${pedidos.length} pedidos.`);
        res.render("pedidos/pedidos", { pedidos: pedidosWithProductos, mensaje: null, rol, notificacionPagoPendiente });
      } else {
        console.log("No se encontraron pedidos.");
        res.render("pedidos/pedidos", { pedidos: [], mensaje: "No hay pedidos registrados." });
      }
    }
    else if (rol == 1) {
      const pedidos = await Pedidos.findAll({
        where: {
          estadoDeEntrega: "no entregado",
          estadoDePago: "pendiente"
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
      const pedidosWithProductos = pedidos.map(pedido => ({
        ...pedido.toJSON(),
        empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
        productos: pedido.detalles.map(detalle => ({
          nombre: detalle.producto.nombre,
          cantidad: detalle.cantidad
        }))
      }));

      if (pedidos.length > 0) {
        // console.log(`Se encontraron ${pedidos.length} pedidos.`);
        res.render("pedidos/pedidos", { pedidos: pedidosWithProductos, mensaje: null, rol, notificacionPagoPendiente });
      } else {
        console.log("No se encontraron pedidos.");
        res.render("pedidos/pedidos", { pedidos: [], mensaje: "No hay pedidos registrados." });
      }
    }
    else {
      res.redirect('/')
    }
  } catch (error) {
    console.error("Error al obtener los pedidos:", error);
    res.render("pedidos/pedidos", { pedidos: [], mensaje: "Error al cargar los pedidos." });
  }
};

// Función para obtener y renderizar todos los pedidos
const getTodosPedidos = async (req, res) => {
  try {
    const { id, rol } = req.usuario
    if (rol == 3) {
      const distribuidor = await Distribuidores.findOne({
        where: {
          usuario_id: id
        }
      });
      if (!distribuidor) {
        return res.redirect('/');
      }
      const distribuidorId = distribuidor.id
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
        ]
      });

      const pedidosWithProductos = pedidos.map(pedido => ({
        ...pedido.toJSON(),
        empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
        productos: pedido.detalles.map(detalle => ({
          nombre: detalle.producto.nombre,
          cantidad: detalle.cantidad
        }))
      }));
      res.render("pedidos/pedidostodos", { pedidos: pedidosWithProductos });
    }
    else if (rol == 1) {
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
        ]
      });
      const pedidosWithProductos = pedidos.map(pedido => ({
        ...pedido.toJSON(),
        empresa: pedido.Distribuidor ? pedido.Distribuidor.empresa : 'No disponible',
        productos: pedido.detalles.map(detalle => ({
          nombre: detalle.producto.nombre,
          cantidad: detalle.cantidad
        }))
      }));

      if (pedidos.length > 0) {
        console.log(`Se encontraron ${pedidos.length} pedidos.`);
        res.render("pedidos/pedidostodos", { pedidos: pedidosWithProductos, mensaje: null });
      } else {
        console.log("No se encontraron pedidos.");
        res.render("pedidos/pedidostodos", { pedidos: [], mensaje: "No hay pedidos registrados." });
      }
    }
    else {
      res.redirect('/')
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
    const { id } = req.params; // id del pedido (idPedido)
    const { fecha, distribuidorId, estadoDePago, estadoDeEntrega, comprobanteDePago, productos } = req.body;

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
    if (estadoDePago) {
      // Asignamos el valor exacto conforme a los valores permitidos en el enum
      switch(estadoDePago.toLowerCase()) {
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
    if (estadoDeEntrega) {
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

    res.render("pedidos/pedidoEditar", { pedido, layout: 'layouts/layout' });
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
      const distribuidor = await Distribuidores.findOne({
        where: {
          usuario_id: id
        }
      });
      const distribuidorId = distribuidor.id
      res.render("pedidos/pedidoAgregarDistribuidor", { productos, distribuidorId /*, distribuidores*/ });
    }
    else if (rol == 1) {
      const productos = await Productos.findAll();
      const distribuidores = await Distribuidores.findAll();
      res.render("pedidos/pedidoAgregarAdmin", { productos, distribuidores /*, admin*/ });
    } else {
      res.redirect('/')
    }
  } catch (error) {
    console.error("Error al renderizar vista de agregar pedido:", error);
    res.render("pedidos/pedidoAgregar", { productos: [], mensaje: "Error al cargar datos para el pedido.", layout: 'layouts/layout' });
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
        { text: 'Ident. Jurídica:  3-102-873151' },
        { text: 'Correo: rellenoselbuensabor@gmail.com\nTeléfono: +(506) 2102-0518' },
        { text: `\nFactura Electrónica N° 0010000101000000${id.toString().padStart(4, '0')}` },
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
  subirComprobantePago
};
