import PdfPrinter from 'pdfmake';
import dayjs from 'dayjs';
import 'dayjs/locale/es.js';
dayjs.locale('es'); 
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import PedidoDetalle from '../models/pedidoDetalle.js';
import Pedido from '../models/pedidoModel.js';
import Distribuidor from '../models/distribuidorModel.js';
import Producto from '../models/productoModel.js';
import Pago from '../models/pagoModel.js';
import { fn, col, Op } from 'sequelize';

// Rutas absolutas
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


// Muestra en pantalla
const getReportePedidosPorProducto = async (req, res) => {
  try {
    // 1. Pedidos por producto
    const pedidosPorProducto = await PedidoDetalle.findAll({
      attributes: [
        [col('producto.nombre'), 'producto'],
        [fn('SUM', col('cantidad')), 'totalCantidad']
      ],
      include: [{ model: Producto, as: 'producto', attributes: [] }],
      group: ['producto.nombre'],
      order: [[fn('SUM', col('cantidad')), 'DESC']],
      raw: true
    });

    // 2. Pedidos por distribuidor
    const pedidosPorDistribuidor = await Pedido.findAll({
      attributes: [
        [col('Distribuidor.empresa'), 'empresa'],
        [fn('COUNT', col('id')), 'totalPedidos']
      ],
      include: [{
        model: Distribuidor,
        as: 'Distribuidor',
        attributes: []
      }],
      group: ['Distribuidor.empresa'],
      raw: true
    });

    // 3. Total de pagos del mes actual
    const inicioMes = dayjs().startOf('month').toDate();
    const finMes = dayjs().endOf('month').toDate();

    const pagosDelMes = await Pago.findAll({
      attributes: [[fn('SUM', col('precio_total')), 'totalPagado']],
      where: {
        fecha_pago: {
          [Op.between]: [inicioMes, finMes]
        }
      },
      raw: true
    });

    const totalPagadoMes = pagosDelMes[0]?.totalPagado || 0;

    const mesActual = dayjs().format('MMMM YYYY'); 

    res.render('reportes/reportes', {
      layout: 'layouts/layout',
      pedidosPorProducto,
      pedidosPorDistribuidor,
      totalPagadoMes,
      mesActual, 
      mensaje: pedidosPorProducto.length === 0 ? 'No hay datos de pedidos por producto.' : null
    });

  } catch (error) {
    console.error('Error generando el reporte:', error);
    res.status(500).render('reportes/reportes', {
      layout: 'layouts/layout',
      pedidosPorProducto: [],
      pedidosPorDistribuidor: [],
      totalPagadoMes: 0,
      mesActual: '',
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
  
  const logoPath = path.join(__dirname, '..', '..', '..', 'public', 'images', 'Logo-Rellenos-El-Buen-Sabor-Version-Naranja.png');
  const logoBase64 = fs.readFileSync(logoPath).toString('base64');
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
          {
            image: `data:image/png;base64,${logoBase64}`,
            width: 120,
            alignment: 'left',
            margin: [0, 0, 0, 10]
          },
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
