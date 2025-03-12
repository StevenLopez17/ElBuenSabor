import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';


const Pedidos = sequelize.define('Pedidos', {
  idpedido: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  fecha: {
    type: DataTypes.DATEONLY,
    allowNull: false
  },
  distribuidorId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  precioTotal: {
    type: DataTypes.FLOAT,
    allowNull: false,
    defaultValue: 0
  },
  estadoDePago: {
    type: DataTypes.ENUM('pendiente', 'en revision', 'aprobado'),
    allowNull: false,
    defaultValue: 'pendiente'
  },
  estadoDeEntrega: {
    type: DataTypes.ENUM('entregado', 'no entregado'),
    allowNull: false,
    defaultValue: 'no entregado'
  },
  comprobanteDePago: {
    type: DataTypes.STRING(255),
    allowNull: true
  },
  created_at: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  },
  updated_at: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'pedidos',
  timestamps: false
});



export default Pedidos;
