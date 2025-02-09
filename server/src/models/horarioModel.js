import { Sequelize, DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import GestionColaboradores from './colaboradorModel.js';

const Horarios = sequelize.define("Horarios", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    descripcion: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
}, {
    tableName: "horarios",
    timestamps: false,
});

Horarios.associate = (models) => {
    Horarios.hasMany(models.GestionColaboradores, { foreignKey: 'horario_id' });
};

export default Horarios;
