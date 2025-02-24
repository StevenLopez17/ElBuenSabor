import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';

const InventarioMateriasPrimas = sequelize.define('InventarioMateriasPrimas', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
  },
  producto_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
  cantidad_disponible: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
  },
  fecha_actualizacion: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'inventario_materias_primas',
  timestamps: false,
});

export default InventarioMateriasPrimas;
