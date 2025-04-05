import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';

const Pagos = sequelize.define('Pagos', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'id'
  },
  proveedor_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'proveedor_id'
  },
  fecha_pago: {
    type: DataTypes.DATEONLY,
    allowNull: false,
    field: 'fecha_pago'
  },
  precio: {
    type: DataTypes.DECIMAL(10,2),
    allowNull: false,
    field: 'precio'
  },
  impuesto: {
    type: DataTypes.DECIMAL(10,2),
    allowNull: false,
    field: 'impuesto'
  },
  precio_total: {
    type: DataTypes.DECIMAL(10,2),
    allowNull: false,
    field: 'precio_total'
  },
  referencia: {
    type: DataTypes.STRING(255),
    allowNull: true,
    field: 'referencia'
  },
  notas: {
    type: DataTypes.TEXT,
    allowNull: true,
    field: 'notas'
  }
}, {
  tableName: 'pagos',
  timestamps: false
});

export default Pagos;
