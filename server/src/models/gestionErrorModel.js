import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';

const GestionError = sequelize.define('GestionError', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  usuario_id: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  fechaHora: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  },
  mensaje: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  origen: {
    type: DataTypes.STRING,
    allowNull: true
  }
}, {
  tableName: 'gestion_error',
  timestamps: false
});

export default GestionError;
