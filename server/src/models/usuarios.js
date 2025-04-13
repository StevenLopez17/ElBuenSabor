import { Sequelize, DataTypes } from 'sequelize';
import sequelize from '../../config/database.js';
import bcrypt from 'bcrypt';
import Rol from './rol.js'

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
    estado: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    },
    fecha_creacion: {
        type: DataTypes.DATE,
        defaultValue: Sequelize.NOW
    },
    token: DataTypes.STRING,
    imagen_url: {
        type: DataTypes.TEXT,
        allowNull: true
      },
}, {
    tableName: 'usuarios',
    timestamps: false,
    hooks: {
        beforeCreate: async (usuario) => {
            const salt = await bcrypt.genSalt(10);
            usuario.contrasena = await bcrypt.hash(usuario.contrasena, salt);
        }
    },
    // Scopes: excluir contraseña y token al realizar consultas
    scopes: {
        eliminarPassword: {
            attributes: {
                exclude: ['contrasena', 'token']
            }
        }
    }
});

// Método para verificar contraseña
Usuario.prototype.verificarPassword = function (password) {
    return bcrypt.compareSync(password, this.contrasena);
};

// Definir la relación con la tabla Rol
Usuario.belongsTo(Rol, { foreignKey: 'rol_id', as: 'rol' });

export default Usuario;
