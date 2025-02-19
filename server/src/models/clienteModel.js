import { DataTypes } from "sequelize";
import sequelize from "../../config/database.js";

const Clientes = sequelize.define(
  "Clientes",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    nombre: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    representante: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },
    numero: {
      type: DataTypes.STRING(20),
      allowNull: false,
    },
    correo: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    direccion: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    estado: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  },
  {
    tableName: "clientes", // Ensure the table name is in lowercase
    timestamps: false, // Disable timestamps
  }
);

export default Clientes;
