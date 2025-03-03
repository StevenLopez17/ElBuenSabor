import { DataTypes } from "sequelize";
import sequelize from "../../config/database.js";

const Productos = sequelize.define("Productos", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  nombre: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
  precio: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  stock: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
}, {
  tableName: 'productos', // Specify the correct table name here
  timestamps: false // Disable timestamps
});

export default Productos;

