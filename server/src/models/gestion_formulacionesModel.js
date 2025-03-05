import { DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import Formulaciones from './formulacionesModel.js';
import MateriaPrima from './materiaPrimaModel.js';


const GestionFormulaciones = sequelize.define('GestionFormulaciones', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    formulacion_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    materia_prima_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    cantidad: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, {
    tableName: 'gestion_formulaciones', 
    timestamps: false 
});



export default GestionFormulaciones;