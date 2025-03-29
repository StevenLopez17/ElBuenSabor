import { Sequelize, DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import Usuario from './usuarios.js';

const SolicitudesVacaciones = sequelize.define('SolicitudesVacaciones', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    usuario_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    fecha_inicio: {
        type: DataTypes.DATEONLY,
        allowNull: false
    },
    fecha_fin: {
        type: DataTypes.DATEONLY,
        allowNull: false
    },
    estado: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: "Pendiente"
    },
    fecha_solicitud: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
}, {
    tableName: 'solicitudes_vacaciones',
    timestamps: false
});

SolicitudesVacaciones.belongsTo(Usuario, { foreignKey: 'usuario_id', as: 'usuario' });

export default SolicitudesVacaciones;
