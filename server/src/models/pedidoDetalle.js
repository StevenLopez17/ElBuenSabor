import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';

const PedidoDetalle = sequelize.define('PedidoDetalle', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'id'
  },
  pedidoId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'pedidoid' // Columna real en la BD
  },
  productoId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'productoid' // Columna real en la BD
  },
  cantidad: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'cantidad' // Columna real en la BD
  },
  precioUnitario: {
    type: DataTypes.FLOAT, // O DataTypes.DECIMAL(10,2) si prefieres mayor exactitud
    allowNull: false,
    field: 'preciounitario' // Columna real en la BD
  },
  subtotal: {
    type: DataTypes.FLOAT, // Igual, puedes usar DECIMAL(10,2)
    allowNull: false,
    field: 'subtotal' // Columna real en la BD
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
  tableName: 'pedido_detalles',
  timestamps: false // Si quieres usar createdAt/updatedAt automáticos, setea true y ajusta "field" en "underscored" o similar
});

export default PedidoDetalle;
