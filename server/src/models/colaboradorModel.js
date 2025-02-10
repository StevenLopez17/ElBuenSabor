import { Sequelize, DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import Horarios from './horarioModel.js';

const GestionColaboradores = sequelize.define("GestionColaboradores", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    usuario_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
    },
    cargo: {
        type: DataTypes.STRING(100),
        allowNull: false,
    },
    estado: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: true
    },
    horario_id: {
        type: DataTypes.INTEGER,
        references: {
            model: 'horarios',
            key: 'id',
        },
        allowNull: true,
    },
    fecha_ingreso: {
        type: DataTypes.DATEONLY,
        allowNull: false,
    },
}, {
    tableName: "gestion_colaboradores",
    timestamps: false,
});

GestionColaboradores.belongsTo(Horarios, { foreignKey: 'horario_id' });

export default GestionColaboradores;
