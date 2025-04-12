import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import Distribuidores from '../models/Distribuidor.js';

const Pedido = sequelize.define('Pedido', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'id'
  },
  fecha: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'fecha'
  },
  distribuidorId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'distribuidorid'
  },
  precioTotal: {
    type: DataTypes.FLOAT,
    allowNull: false,
    field: 'preciototal'
  },
  estadoDePago: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'estadodepago'
  },
  estadoDeEntrega: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'estadodeentrega'
  },
  comprobanteDePago: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'comprobantedepago'
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
    field: 'created_at'
  },
  updatedAt: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
    field: 'updated_at'
  }
}, {
  tableName: 'pedidos',
  timestamps: false
});

Pedido.associate = (models) => {
  Pedido.hasMany(models.PedidoDetalle, {
    foreignKey: 'pedidoId',
    as: 'detalles'
  });

  Pedido.belongsTo(models.Distribuidores, {
    foreignKey: 'distribuidorid',
    as: 'Distribuidor'
  });
};

export default Pedido;