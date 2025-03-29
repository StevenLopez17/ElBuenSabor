import PdfPrinter from 'pdfmake';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import PedidoDetalle from '../models/pedidoDetalle.js';
import Producto from '../models/productoModel.js';
import { fn, col } from 'sequelize';

// Rutas absolutas
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


// Muestra en pantalla
const getReportePedidosPorProducto = async (req, res) => {
    try {
      const resultados = await PedidoDetalle.findAll({
        attributes: [
          [col('producto.nombre'), 'producto'],
          [fn('SUM', col('cantidad')), 'totalCantidad']
        ],
        include: [{
          model: Producto,
          as: 'producto',
          attributes: []
        }],
        group: ['producto.nombre'],
        order: [[fn('SUM', col('cantidad')), 'DESC']],
        raw: true
      });
  
      res.render('reportes/reportes', {
        layout: 'layouts/layout',
        pedidosPorProducto: resultados,
        mensaje: resultados.length === 0 ? 'No hay datos de pedidos por producto.' : null
      });
    } catch (error) {
      console.error('Error generando el reporte:', error);
      res.status(500).render('reportes/reportes', {
        layout: 'layouts/layout',
        pedidosPorProducto: [],
        mensaje: 'Error al generar el reporte'
      });
    }
  };


// Config PDF
// Config PDF con fuente integrada
const printer = new PdfPrinter({
    Helvetica: {
      normal: 'Helvetica',
      bold: 'Helvetica-Bold'
    }
  });
  
  // Exportar PDF del reporte
  const exportarPDFPedidosPorProducto = async (req, res) => {
    try {
      const resultados = await PedidoDetalle.findAll({
        attributes: [
          [col('producto.nombre'), 'producto'],
          [fn('SUM', col('cantidad')), 'totalCantidad']
        ],
        include: [{
          model: Producto,
          as: 'producto',
          attributes: []
        }],
        group: ['producto.nombre'],
        order: [[fn('SUM', col('cantidad')), 'DESC']],
        raw: true
      });
  
      const body = resultados.map(r => [r.producto, `${r.totalCantidad} kg`]);
  
      const docDefinition = {
        defaultStyle: { font: 'Helvetica' },
        content: [
          { text: 'Reporte de Pedidos por Producto', style: 'header' },
          {
            table: {
              headerRows: 1,
              widths: ['*', 'auto'],
              body: [['Producto', 'Cantidad Total'], ...body]
            }
          }
        ],
        styles: {
          header: { fontSize: 16, bold: true, margin: [0, 0, 0, 10] }
        }
      };
  
      const outputDir = path.join(__dirname, '..', 'client', 'pdf');
      if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
      }
  
      const filePath = path.join(outputDir, 'ReportePedidosPorProducto.pdf');
      const pdfDoc = printer.createPdfKitDocument(docDefinition);
      const stream = fs.createWriteStream(filePath);
      pdfDoc.pipe(stream);
      pdfDoc.end();
  
      stream.on('finish', () => {
        res.download(filePath, 'ReportePedidosPorProducto.pdf', () => {
          fs.unlinkSync(filePath);
        });
      });
  
    } catch (error) {
      console.error("Error al generar PDF:", error);
      res.status(500).json({ mensaje: "Error al generar el PDF", error: error.message });
    }
  };


  export {
    getReportePedidosPorProducto,
    exportarPDFPedidosPorProducto
};
