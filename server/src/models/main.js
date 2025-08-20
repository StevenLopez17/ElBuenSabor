import fs from 'fs';
import path from 'path';
import { Sequelize } from 'sequelize';
import { fileURLToPath } from 'url';
import sequelize from '../../config/database.js';
import Clientes from './clienteModel.js';
import Distribuidores from './distribuidorModel.js';
import Formulaciones from './formulacionesModel.js';
import MateriaPrima from './materiaPrimaModel.js';
import GestionFormulaciones from './gestion_formulacionesModel.js';
import Productos from './productoModel.js';
import Pedidos from './pedidoModel.js';
import PedidoDetalle from './pedidoDetalle.js';
import Proveedores from './proveedorModel.js';
import Pagos from './pagoModel.js';
// New formula models
import Product from './productModel.js';
import InventoryItem from './inventoryItemModel.js';
import Formula from './formulaModel.js';
import FormulaItem from './formulaItemModel.js';


const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const db = {};

db.Clientes = Clientes;
db.Distribuidores = Distribuidores;
db.Formulaciones = Formulaciones;
db.MateriaPrima = MateriaPrima;
db.GestionFormulaciones = GestionFormulaciones;
db.Productos = Productos;
// New formula models
db.Product = Product;
db.InventoryItem = InventoryItem;
db.Formula = Formula;
db.FormulaItem = FormulaItem;


//Relación Many-to-Many entre Formulaciones y Materias Primas
Formulaciones.belongsToMany(MateriaPrima, {
  through: GestionFormulaciones,
  foreignKey: "formulacion_id",
  otherKey: "materia_prima_id",
  as: "MateriasPrimas"
});

MateriaPrima.belongsToMany(Formulaciones, {
  through: GestionFormulaciones,
  foreignKey: "materia_prima_id",
  otherKey: "formulacion_id",
  as: "Formulaciones"
});

//Relación entre Productos y Formulaciones
Productos.belongsTo(Formulaciones, { foreignKey: "formulaciones_id", as: "Formulacion" });
Formulaciones.hasMany(Productos, { foreignKey: "formulaciones_id", as: "Productos" });

//Relación entre Clientes y Distribuidores
Distribuidores.hasMany(Clientes, { foreignKey: "distribuidor_id", as: "Clientes" });
Clientes.belongsTo(Distribuidores, { foreignKey: "distribuidor_id", as: "Distribuidor" });

//Relación entre GestionFormulaciones y Materia Prima
GestionFormulaciones.belongsTo(MateriaPrima, { foreignKey: "materia_prima_id", as: "MateriaPrima" });
MateriaPrima.hasMany(GestionFormulaciones, { foreignKey: "materia_prima_id", as: "Gestiones" });

//Relación entre GestionFormulaciones y Formulaciones
GestionFormulaciones.belongsTo(Formulaciones, { foreignKey: "formulacion_id", as: "Formulacion" });
Formulaciones.hasMany(GestionFormulaciones, { foreignKey: "formulacion_id", as: "Gestiones" });

Pedidos.hasMany(PedidoDetalle, { foreignKey: 'pedidoid', as: 'detalles' });
PedidoDetalle.belongsTo(Pedidos, { foreignKey: 'pedidoid', as: 'pedido' });
PedidoDetalle.belongsTo(Productos, { foreignKey: 'productoId', as: 'producto' });



Pedidos.belongsTo(Distribuidores, { foreignKey: 'distribuidorId', as: 'Distribuidor' });


// Un proveedor puede tener muchos pagos
Proveedores.hasMany(Pagos, { foreignKey: 'proveedor_id', as: 'pagos' });


// Cada pago pertenece a un proveedor
Pagos.belongsTo(Proveedores, { foreignKey: 'proveedor_id', as: 'proveedor' });

// New formula relationships
Product.hasMany(Formula, { foreignKey: 'productId', as: 'formulas' });
Formula.belongsTo(Product, { foreignKey: 'productId', as: 'product' });

Formula.hasMany(FormulaItem, { foreignKey: 'formulaId', as: 'items', onDelete: 'CASCADE' });
FormulaItem.belongsTo(Formula, { foreignKey: 'formulaId', as: 'formula' });

InventoryItem.hasMany(FormulaItem, { foreignKey: 'inventoryItemId', as: 'formulaItems' });
FormulaItem.belongsTo(InventoryItem, { foreignKey: 'inventoryItemId', as: 'inventoryItem' });



Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

export default db;
