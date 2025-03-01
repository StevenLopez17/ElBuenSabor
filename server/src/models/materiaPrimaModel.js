import { DataTypes } from "sequelize";
import sequelize from "../../config/database.js";


const MateriaPrima = sequelize.define("MateriaPrima", {
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
    
    });


    export default MateriaPrima;

    