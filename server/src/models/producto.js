import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';

const Producto = sequelize.define('Producto', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: 'id'
    },
    nombre: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'nombre'
    },
    // Add other fields as necessary
}, {
    tableName: 'productos',
    timestamps: false
});

export default Producto;
