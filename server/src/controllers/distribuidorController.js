import Distribuidores from "../models/distribuidorModel.js";
import Clientes from "../models/clienteModel.js";
import PdfPrinter from 'pdfmake';
import exceljs from 'exceljs';
import fs from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';



//Variables globales
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const printer = new PdfPrinter({
    Helvetica: { normal: 'Helvetica', bold: 'Helvetica-Bold' }
});



//Metodo para agregar un distribuidor
const insertDistribuidor = async (req, res) => {
    try {
        const { usuario_id, empresa, telefono, direccion, zona_cobertura, cliente_id } = req.body;

        if (!usuario_id || !empresa) {
            return res.status(400).json({ message: "Usuario ID y Empresa son obligatorios" });
        }

        await Distribuidores.create({
            usuario_id,
            empresa,
            telefono,
            direccion,
            zona_cobertura,
            cliente_id,
            estado: true
        });

        console.log('Distribuidor creado con éxito');
        res.redirect('/distribuidor');

    } catch (error) {
        console.error('Error al crear el distribuidor:', error);
        res.status(500).json({ message: "Error al agregar distribuidor", error: error.message });
    }
};

//Metodo para cargar la vista de insercion de distribuidores con la lista de clientes
const rendInsertDistribuidor = async (req, res) => {
    try {
        // Obtener todos los clientes registrados
        const clientes = await Clientes.findAll();

        res.render('distribuidoresAgregar', {
            layout: 'layouts/layout',
            clientes
        });

    } catch (error) {
        console.error("Error al obtener los clientes:", error);
        res.render('distribuidoresAgregar', {
            layout: 'layouts/layout',
            clientes: [],
            mensaje: "Error al cargar los clientes"
        });
    }
};

//Metodo para obtener los distribuidores almacenados y cargar las direcciones para el select

const getDistribuidor = async (req, res) => {
    try {

        const direcciones = await Distribuidores.findAll({
            attributes: ['direccion'],
            group: ['direccion'],
            raw: true
        });


        // const distribuidores = await Distribuidores.findAll();

        const distribuidores = await Distribuidores.findAll({
            include: [{
                model: Clientes,  // 🔹 Relación con Clientes
                attributes: ['nombre'],  // 🔹 Solo traer el nombre del cliente
            }]
        });

        if (distribuidores.length > 0) {
            console.log(`Se encontraron ${distribuidores.length} distribuidores.`);
            res.render('distribuidores', {
                layout: 'layouts/layout',
                distribuidores,
                direcciones,
                filtroDireccion: "",
                mensaje: null
            });
        } else {
            console.log(`No se encontraron distribuidores.`);
            res.render('distribuidores', {
                layout: 'layouts/layout',
                distribuidores: [],
                direcciones,
                filtroDireccion: "",
                mensaje: "No hay distribuidores registrados."
            });
        }

    } catch (error) {
        console.error('Error al obtener distribuidores:', error);
        res.render('distribuidores', {
            layout: 'layouts/layout',
            distribuidores: [],
            direcciones: [],
            filtroDireccion: "",
            mensaje: "Error al cargar los distribuidores."
        });
    }
};

//Metodo para actualizar los datos de un distribuidor
const updateDistribuidor = async (req, res) => {
    try {
        const { usuario_id, empresa, telefono, direccion, zona_cobertura, cliente_id } = req.body;
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
            zona_cobertura,
            id_cliente: cliente_id
        });

        console.log('Distribuidor actualizado con éxito');
        res.redirect('/distribuidor');

    } catch (error) {
        console.error('Error al actualizar el distribuidor:', error);
        res.status(500).json({ message: "Error al actualizar distribuidor", error: error.message });
    }
};

//Metodo para renderizar la vista de actualizar los distribuidores y que carga los datos del distribuidor a actualizar
const rendUpdateDistribuidor = async (req, res) => {
    try {
        console.log("ID recibido:", req.params.id);

        const distribuidor = await Distribuidores.findByPk(req.params.id, {
            include: [{ model: Clientes, attributes: ['id', 'nombre'] }] // 🔹 Traer el cliente asignado
        });

        if (!distribuidor) {
            console.log("Distribuidor no encontrado en la base de datos");
            return res.status(404).send("Distribuidor no encontrado");
        }

        console.log("Distribuidor seleccionado:", JSON.stringify(distribuidor, null, 2));

        const clientes = await Clientes.findAll({ attributes: ['id', 'nombre'] });

        res.render('distribuidoresEditar', {
            distribuidor: distribuidor,
            clientes
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

        console.log(`El distribuidor de ID ${id} está ${distribuidor.estado ? 'Activo' : 'Inactivo'}`);

        res.redirect('/distribuidor');

    } catch (error) {
        console.error("Error al cambiar el estado del distribuidor:", error);
        res.status(500).json({ message: "Error al actualizar estado", error: error.message });
    }
};

//Metodo para filtrar los distribuidores por direccion
const filtroDireccionDistribuidores = async (req, res) => {
    try {
        // Obtener todas las direcciones únicas para el filtro
        const direcciones = await Distribuidores.findAll({
            attributes: ['direccion'],
            group: ['direccion'],
            raw: true
        });

        const filtroDireccion = req.query.direccion || "";
        const whereCondition = filtroDireccion ? { direccion: filtroDireccion } : {};


        const distribuidores = await Distribuidores.findAll({
            where: whereCondition,
            include: [
                {
                    model: Clientes,
                    attributes: ['id', 'nombre'],
                }
            ]
        });

        console.log(`Se encontraron ${distribuidores.length} distribuidores con dirección ${filtroDireccion}.`);

        res.render('distribuidores', {
            layout: 'layouts/layout',
            distribuidores,
            direcciones,
            filtroDireccion,
            mensaje: distribuidores.length > 0 ? null : "No hay distribuidores con esta dirección."
        });

    } catch (error) {
        console.error('Error al filtrar distribuidores:', error);
        res.render('distribuidores', {
            layout: 'layouts/layout',
            distribuidores: [],
            direcciones: [],
            filtroDireccion: "",
            mensaje: "Error al cargar los distribuidores."
        });
    }
};

//Metodo para exportar un PDF con los distribuidores y clientes
const exportarPDFDist = async (req, res) => {
    try {
        const distribuidores = await Distribuidores.findAll({
            include: [{ model: Clientes, attributes: ['id', 'nombre'] }]
        });

        if (!distribuidores || distribuidores.length === 0) {
            return res.status(404).send("No existen distribuidores para exportar");
        }

        const pdfDir = path.join(__dirname, '..', 'client', 'pdf');

        if (!fs.existsSync(pdfDir)) {
            fs.mkdirSync(pdfDir, { recursive: true });
        }

        const filepath = path.join(pdfDir, 'ReporteDistribuidores.pdf');

        //Se carga el cuerpo de la tabla con los valores desde antes
        const tableBody = distribuidores.map(d => [
            d.id || '',
            d.empresa || 'Sin empresa',
            d.Cliente ? d.Cliente.nombre : 'No asignado',
            d.telefono || 'No registrado',
            d.direccion || 'No registrada',
            d.zona_cobertura || 'No registrada',
            d.estado ? 'Activo' : 'Inactivo',

        ]);

        if (tableBody.length === 0) {
            return res.status(404).send("No hay datos para exportar");
        }

        const docDefinition = {
            defaultStyle: { font: 'Helvetica' },
            content: [
                { text: 'Reporte de Distribuidores y Clientes', fontSize: 16, bold: true, margin: [0, 0, 0, 10] },
                {
                    table: {
                        headerRows: 1,
                        widths: ['auto', '*', 'auto', '*', 'auto', 'auto', '*'],
                        body: [
                            ['ID', 'Empresa', 'Cliente Asignado', 'Teléfono', 'Dirección', 'Zona de Cobertura', 'Estado'],
                            ...tableBody // Aca nada mas se asigna el cuerpo de la tabla que se creo antes
                        ]
                    }
                }
            ]
        };

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
        const distribuidores = await Distribuidores.findAll({
            include: [{ model: Clientes, attributes: ['id', 'nombre'] }] // 🔹 Incluir cliente
        });

        if (distribuidores.length === 0) {
            return res.status(404).send("No existen distribuidores para exportar");
        }

        const workbook = new exceljs.Workbook();
        const worksheet = workbook.addWorksheet('Distribuidores');

        worksheet.columns = [
            { header: 'ID', key: 'id', width: 10 },
            { header: 'Empresa', key: 'empresa', width: 25 },
            { header: 'Cliente Asignado', key: 'cliente', width: 25 },
            { header: 'Telefono', key: 'telefono', width: 15 },
            { header: 'Direccion', key: 'direccion', width: 30 },
            { header: 'Zona de Cobertura', key: 'zona_cobertura', width: 20 },
            { header: 'Estado', key: 'estado', width: 15 }
        ];

        distribuidores.forEach(distribuidor => {
            worksheet.addRow({
                id: distribuidor.id,
                empresa: distribuidor.empresa,
                cliente: distribuidor.Cliente ? distribuidor.Cliente.nombre : 'No Asignado',
                telefono: distribuidor.telefono,
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
    rendInsertDistribuidor,
    getDistribuidor,
    updateDistribuidor,
    rendUpdateDistribuidor,
    cambiarDistribuidorEstado,
    filtroDireccionDistribuidores,
    exportarPDFDist,
    exportarExcelDist
};