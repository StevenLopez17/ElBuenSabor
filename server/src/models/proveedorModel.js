import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';

const Proveedores = sequelize.define('Proveedores', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'id'
  },
  nombre: {
    type: DataTypes.STRING(100),
    allowNull: false,
    field: 'nombre'
  },
  contacto: {
    type: DataTypes.STRING(100),
    allowNull: true,
    field: 'contacto'
  },
  telefono: {
    type: DataTypes.STRING(50),
    allowNull: true,
    field: 'telefono'
  },
  correo: {
    type: DataTypes.STRING(100),
    allowNull: true,
    field: 'correo'
  },
  direccion: {
    type: DataTypes.TEXT,
    allowNull: true,
    field: 'direccion'
  },
  estado: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true,
    field: 'estado'
  }
}, {
  tableName: 'proveedores',
  timestamps: false
});

export default Proveedores;
