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
      allowNull: true,
    },

    correo: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },

    direccion: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    estado: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  },
  
);

export default Clientes;
