import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import Clientes from './clienteModel.js';

const Distribuidores = sequelize.define('Distribuidores', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    usuario_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    empresa: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    telefono: {
        type: DataTypes.STRING(20),
        allowNull: false
    },
    direccion: {
        type: DataTypes.TEXT,
        allowNull: false
    },
    zona_cobertura: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    fecha_registro: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    estado: { 
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: true 
    }
}, {
    tableName: 'distribuidores', 
    timestamps: false 
});




export default Distribuidores;


