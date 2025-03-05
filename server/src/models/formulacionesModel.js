import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import GestionFormulaciones from './gestion_formulacionesModel.js';

const Formulaciones = sequelize.define('Formulaciones', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    total_producir: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    precio_total: {
        type: DataTypes.FLOAT,
        allowNull: false
    }
}, {
    tableName: 'formulaciones', 
    timestamps: false 
});

export default Formulaciones;


