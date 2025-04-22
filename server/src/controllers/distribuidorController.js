import Distribuidores from "../models/distribuidorModel.js";
import Clientes from "../models/clienteModel.js";
import Pedidos from "../models/pedidoModel.js";
import Usuario from '../models/usuarios.js';
import Rol from '../models/rol.js';
import PdfPrinter from 'pdfmake';
import exceljs from 'exceljs';
import fs from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';
import sequelize from '../../config/database.js';

//Variables globales
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const printer = new PdfPrinter({
  Helvetica: { normal: 'Helvetica', bold: 'Helvetica-Bold' }
});



//Metodo para agregar un distribuidor
const insertDistribuidor = async (req, res, next) => {
  try {
    const usuario_id = req.usuario.id; 
    const { empresa, telefono, direccion, zona_cobertura } = req.body;

    if (!usuario_id || !empresa) {
      return res.status(400).json({ message: "Usuario ID y Empresa son obligatorios" });
    }

    await Distribuidores.create({
      usuario_id,
      empresa,
      telefono,
      direccion,
      zona_cobertura,
      estado: true
    });

    console.log('Distribuidor creado con éxito');
    res.redirect('/distribuidor?distribuidorAgregado=true');

  } catch (error) {
    next(error);
  }
};



//Metodo para cargar la vista de insercion de distribuidores con la lista de clientes
const rendInsertDistribuidor = async (req, res) => {
  try {
    const usuarios = await Usuario.findAll({
      attributes: ['id', 'nombre'],
      where: { estado: true },
      include: {
        model: Rol,
        as: 'rol',
        where: { id: 3 }, // ID del rol "Distribuidor"
        attributes: []
      }
    });

    res.render('distribuidores/distribuidoresAgregar', {
      layout: 'layouts/layout',
      usuarios
    });
  } catch (error) {
    console.error('Error al cargar la vista de agregar distribuidor:', error);
    res.status(500).send('Error al cargar la vista');
  }
};

//Metodo para obtener los distribuidores almacenados y cargar las direcciones para el select


const getDistribuidor = async (req, res) => {
  try {
    const { id, rol } = req.usuario;
    if (rol != 1) return res.redirect('/')
    const modalEstado = req.query.modalEstado === 'true';
    const distribuidorAgregado = req.query.distribuidorAgregado === 'true';
    const distribuidorEditado = req.query.distribuidorEditado === 'true';

    const distribuidores = await Distribuidores.findAll();

    // Obtener pedidos pendientes
    const pedidos = await Pedidos.findAll({
      where: { estadodeentrega: 'no entregado' },
      raw: true
    });

    const pedidosPendientesMap = {};
    pedidos.forEach(p => {
      const id = p.distribuidorId;
      pedidosPendientesMap[id] = (pedidosPendientesMap[id] || 0) + 1;
    });

    // Obtener direcciones únicas (opcional)
    const direcciones = [...new Set(
      distribuidores
        .map(d => d.direccion?.trim())
        .filter(d => d && d !== '')
    )];


    res.render('distribuidores/distribuidores', {
      layout: 'layouts/layout',
      distribuidores,
      direcciones,
      filtroDireccion: "",
      mensaje: null,
      distribuidorAgregado,
      distribuidorEditado,
      modalEstado,
      pedidosPendientesMap
    });

  } catch (error) {
    console.error('Error al cargar distribuidores:', error);
    res.status(500).render('distribuidores/distribuidores', {
      layout: 'layouts/layout',
      distribuidores: [],
      direcciones: [],
      filtroDireccion: "",
      mensaje: 'Error al cargar distribuidores',
      distribuidorAgregado: false,
      distribuidorEditado: false,
      modalEstado: false,
      pedidosPendientesMap: {}
    });
  }
};



//Metodo para actualizar los datos de un distribuidor
const updateDistribuidor = async (req, res) => {
  try {
    const { usuario_id, empresa, telefono, direccion, zona_cobertura } = req.body;
    const { id } = req.params;

    if (!id || !usuario_id || !empresa) {
      return res.status(400).json({ message: "ID, Usuario ID y Empresa son obligatorios" });
    }

    const distribuidor = await Distribuidores.findByPk(id);
    if (!distribuidor) {
      return res.status(404).json({ message: "Distribuidor no encontrado" });
    }

    await distribuidor.update({
      usuario_id,
      empresa,
      telefono,
      direccion,
      zona_cobertura
    });

    console.log('Distribuidor actualizado con éxito');
    res.redirect('/distribuidor?distribuidorEditado=true');

  } catch (error) {
    console.error('Error al actualizar el distribuidor:', error);
    res.status(500).json({ message: "Error al actualizar distribuidor", error: error.message });
  }
};

//Metodo para renderizar la vista de actualizar los distribuidores y que carga los datos del distribuidor a actualizar
const rendUpdateDistribuidor = async (req, res) => {
  try {
    const { id } = req.body;
    console.log("ID recibido:", id);

    if (!id) {
      return res.status(400).send("No se recibió el ID del distribuidor");
    }

    const distribuidor = await Distribuidores.findByPk(id);

    if (!distribuidor) {
      console.log("Distribuidor no encontrado en la base de datos");
      return res.status(404).send("Distribuidor no encontrado");
    }

    res.render('distribuidores/distribuidoresEditar', {
      layout: 'layouts/layout',
      distribuidor
    });

  } catch (error) {
    console.error("Error al obtener el distribuidor:", error);
    res.status(500).send("Error interno del servidor");
  }
};


//Metodo para cambiar el estado de un distribuidor
const cambiarDistribuidorEstado = async (req, res) => {
  try {
    const { id } = req.params;
    const distribuidor = await Distribuidores.findByPk(id);
    if (!distribuidor) {
      return res.status(404).json({ message: "Distribuidor no encontrado" });
    }

    distribuidor.estado = !distribuidor.estado;
    await distribuidor.save();

    console.log(`Distribuidor ID ${id} -> ${distribuidor.estado ? 'Activo' : 'Inactivo'}`);
    res.redirect('/distribuidor?modalEstado=true');
  } catch (error) {
    console.error("Error al cambiar el estado del distribuidor:", error);
    res.status(500).json({ message: "Error al actualizar estado", error: error.message });
  }
};

//Metodo para filtrar los distribuidores por direccion
const filtroDireccionDistribuidores = async (req, res) => {
  try {
    const direccionesRaw = await Distribuidores.findAll({
      attributes: ['direccion'],
      group: ['direccion'],
      raw: true
    });

    const direcciones = [...new Set(
      direccionesRaw
        .map(d => d.direccion?.trim())
        .filter(d => d && d !== '')
    )];

    const filtroDireccion = req.query.direccion || "";
    const whereCondition = filtroDireccion ? { direccion: filtroDireccion } : {};

    const distribuidores = await Distribuidores.findAll({ where: whereCondition });

    // Obtener pedidos no entregados
    const pedidos = await Pedidos.findAll({
      where: { estadodeentrega: 'no entregado' },
      raw: true
    });

    const pedidosPendientesMap = {};
    pedidos.forEach(p => {
      const id = p.distribuidorId;
      pedidosPendientesMap[id] = (pedidosPendientesMap[id] || 0) + 1;
    });


    res.render('distribuidores/distribuidores', {
      layout: 'layouts/layout',
      distribuidores,
      direcciones,
      filtroDireccion,
      mensaje: distribuidores.length > 0 ? null : "No hay distribuidores con esta dirección.",
      distribuidorAgregado: false,
      distribuidorEditado: false,
      modalEstado: false,
      pedidosPendientesMap // ✅ se agrega esta línea
    });

  } catch (error) {
    console.error('Error al filtrar distribuidores:', error);
    res.render('distribuidores/distribuidores', {
      layout: 'layouts/layout',
      distribuidores: [],
      direcciones: [],
      filtroDireccion: "",
      mensaje: "Error al cargar los distribuidores.",
      distribuidorAgregado: false,
      distribuidorEditado: false,
      modalEstado: false,
      pedidosPendientesMap: {} 
    });
  }
};


const logoPath = path.join(__dirname, '..', '..', '..', 'public', 'images', 'Logo-Rellenos-El-Buen-Sabor-Version-Naranja.png');
const logoBase64 = fs.readFileSync(logoPath).toString('base64');
//Metodo para exportar un PDF con los distribuidores y clientes
const exportarPDFDist = async (req, res) => {
  try {
    const distribuidores = await Distribuidores.findAll();

    if (!distribuidores || distribuidores.length === 0) {
      return res.status(404).send("No existen distribuidores para exportar");
    }

    const pedidos = await Pedidos.findAll({
      where: { estadodeentrega: 'no entregado' },
      raw: true
    });
    
    const pedidosPendientesMap = {};
    pedidos.forEach(p => {
      const id = p.distribuidorId;
      pedidosPendientesMap[id] = (pedidosPendientesMap[id] || 0) + 1;
    });
    

    const pdfDir = path.join(__dirname, '..', 'client', 'pdf');

    if (!fs.existsSync(pdfDir)) {
      fs.mkdirSync(pdfDir, { recursive: true });
    }

    const filepath = path.join(pdfDir, 'ReporteDistribuidores.pdf');

    const tableBody = distribuidores.map(d => [
      d.id ? String(d.id) : 'Sin ID',
      d.empresa || 'Sin empresa',
      d.telefono || 'No registrado',
      pedidosPendientesMap[d.id] || 0 ,
      d.direccion || 'No registrada',
      d.zona_cobertura || 'No registrada',
      d.estado ? 'Activo' : 'Inactivo' 
    ]);

    if (tableBody.length === 0) {
      return res.status(404).send("No hay datos para exportar");
    }

    const docDefinition = {
      defaultStyle: { font: 'Helvetica' },
      content: [
        {
          image: `data:image/png;base64,${logoBase64}`,
          width: 120,
          alignment: 'left',
          margin: [0, 0, 0, 10]
        },
        { text: 'Reporte de Distribuidores', fontSize: 16, bold: true, margin: [0, 0, 0, 10] },
        {
          table: {
            headerRows: 1,
            widths: ['auto', '*', 'auto', '*', 'auto', '*', 'auto'], // Añadimos una más
            body: [
              ['ID', 'Empresa', 'Teléfono', 'Pedidos Pendientes' , 'Dirección', 'Zona de Cobertura', 'Estado'],
              ...tableBody
            ]
          }
        }
      ]
    };

    console.log("Datos a exportar en PDF:", JSON.stringify(tableBody, null, 2));

    const pdfDoc = printer.createPdfKitDocument(docDefinition);
    const stream = fs.createWriteStream(filepath);
    pdfDoc.pipe(stream);
    pdfDoc.end();

    stream.on('finish', () => {
      res.download(filepath, 'ReporteDistribuidores.pdf', () => {
        fs.unlinkSync(filepath);
      });
    });

  } catch (error) {
    console.error('Error al exportar PDF:', error);
    res.status(500).json({ message: "Error al exportar PDF", error: error.message });
  }
};

//Metodo para exportar un Excel con los distribuidores y clientes 
const exportarExcelDist = async (req, res) => {
  try {
    const distribuidores = await Distribuidores.findAll();

    if (distribuidores.length === 0) {
      return res.status(404).send("No existen distribuidores para exportar");
    }

    const pedidos = await Pedidos.findAll({
      where: { estadodeentrega: 'no entregado' },
      raw: true
    });
    
    const pedidosPendientesMap = {};
    pedidos.forEach(p => {
      const id = p.distribuidorId;
      pedidosPendientesMap[id] = (pedidosPendientesMap[id] || 0) + 1;
    });
    

    const workbook = new exceljs.Workbook();
    const worksheet = workbook.addWorksheet('Distribuidores');

    worksheet.columns = [
      { header: 'ID', key: 'id', width: 10 },
      { header: 'Empresa', key: 'empresa', width: 25 },
      { header: 'Telefono', key: 'telefono', width: 15 },
      { header: 'Pedidos Pendientes', key: 'pedidos_pendientes', width: 20 },
      { header: 'Direccion', key: 'direccion', width: 30 },
      { header: 'Zona de Cobertura', key: 'zona_cobertura', width: 20 },
      { header: 'Estado', key: 'estado', width: 15 }
    ];

    distribuidores.forEach(distribuidor => {
      worksheet.addRow({
        id: distribuidor.id,
        empresa: distribuidor.empresa,
        telefono: distribuidor.telefono,
        pedidos_pendientes: pedidosPendientesMap[distribuidor.id] || 0 ,
        direccion: distribuidor.direccion,
        zona_cobertura: distribuidor.zona_cobertura,
        estado: distribuidor.estado ? 'Activo' : 'Inactivo'
      });
    });

    //Define la ruta del archivo Excel
    const excelDir = path.join(__dirname, '..', 'client', 'excel');

    //Crea la carpeta si no existe
    if (!fs.existsSync(excelDir)) {
      fs.mkdirSync(excelDir, { recursive: true });
    }

    const excelFilePath = path.join(excelDir, 'ReporteDistribuidores.xlsx');

    // Escribe el archivo
    await workbook.xlsx.writeFile(excelFilePath);


    res.download(excelFilePath, 'ReporteDistribuidores.xlsx', () => {
      fs.unlinkSync(excelFilePath);
    });

  } catch (error) {
    console.error('Error al exportar Excel:', error);
    res.status(500).json({ message: "Error al exportar Excel", error: error.message });
  }
};




export {
  insertDistribuidor,
  getDistribuidor,
  rendInsertDistribuidor,
  updateDistribuidor,
  rendUpdateDistribuidor,
  cambiarDistribuidorEstado,
  filtroDireccionDistribuidores,
  exportarPDFDist,
  exportarExcelDist
};
