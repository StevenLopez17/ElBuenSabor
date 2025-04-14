import Clientes from '../models/clienteModel.js';
import Distribuidores from '../models/distribuidorModel.js';
import Pedidos from '../models/pedidoModel.js';
import Rol from '../models/rol.js';
import { Op } from 'sequelize';

export const mostrarInicio = async (req, res) => {
    try {
      if (!req.usuario) {
        return res.redirect('/login');
      }
  
      const clientes = await Clientes.findAll();
      const distribuidores = await Distribuidores.findAll({
        attributes: ['id', 'empresa'],
        order: [['fecha_registro', 'DESC']],
        limit: 3
      });
  
      const pedidos = await Pedidos.findAll({
        where: { estadodeentrega: 'no entregado' },
        raw: true
      });
  
      const pedidosPendientesMap = {};
      pedidos.forEach(p => {
        const id = p.distribuidorId;
        pedidosPendientesMap[id] = (pedidosPendientesMap[id] || 0) + 1;
      });
  
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);
  
      const pedidosDelDia = await Pedidos.findAll({
        where: {
          fecha: {
            [Op.between]: [today, tomorrow]
          }
        },
        include: [{
          model: Distribuidores,
          as: 'Distribuidor',
          attributes: ['empresa']
        }]
      });
  
      const rolDb = await Rol.findOne({ where: { id: req.usuario.rol } });
      const rol_name = rolDb?.nombre || 'Desconocido';
  
      res.render('index', {
        clientes,
        distribuidores,
        pedidosPendientesMap,
        pedidosDelDia,
        usuario: req.usuario,
        rol_name
      });
  
    } catch (error) {
      console.error('Error cargando datos:', error);
      res.render('index', {
        clientes: [],
        distribuidores: [],
        pedidosPendientesMap: {},
        pedidosDelDia: [],
        usuario: req.usuario || {},
        rol_name: '',
        mensaje: 'Error cargando información'
      });
    }
  };
  
