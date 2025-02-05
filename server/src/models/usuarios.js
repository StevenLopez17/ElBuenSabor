import { Sequelize, DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import bcrypt from 'bcrypt';

const Usuario = sequelize.define('Usuario', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    nombre: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    correo: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true
    },
    contrasena: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    rol: {
        type: DataTypes.STRING(50),
        allowNull: false,
        validate: {
            isIn: [['Administrador', 'Gerente de planta', 'Distribuidor', 'Colaborador de planta']]
        }
    },
    estado: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    },
    fecha_creacion: {
        type: DataTypes.DATE,
        defaultValue: Sequelize.NOW
    },
    token: DataTypes.STRING,
}, {
    tableName: 'usuarios',
    timestamps: false,
    hooks: {
        beforeCreate: async (usuario) => {
            const salt = await bcrypt.genSalt(10);
            usuario.contrasena = await bcrypt.hash(usuario.contrasena, salt);
        }
    }
});

// Método para verificar contraseña
Usuario.prototype.verificarPassword = function (password) {
    return bcrypt.compareSync(password, this.contrasena);
};

export default Usuario;
