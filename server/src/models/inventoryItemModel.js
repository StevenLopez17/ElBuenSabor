import { DataTypes } from "sequelize";
import sequelize from "../../config/database.js";

const InventoryItem = sequelize.define("InventoryItem", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  name: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
  sku: {
    type: DataTypes.STRING(50),
    allowNull: false,
    unique: true,
  },
  unit: {
    type: DataTypes.STRING(20),
    allowNull: false,
    defaultValue: 'KG'
  },
  unitCost: {
    type: DataTypes.FLOAT,
    allowNull: false,
    field: 'unit_cost'
  },
  quantityOnHand: {
    type: DataTypes.FLOAT,
    allowNull: false,
    defaultValue: 0,
    field: 'quantity_on_hand'
  },
  rowVersion: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 1,
    field: 'row_version'
  }
}, {
  tableName: 'inventory_items', 
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  version: 'rowVersion'
});

export default InventoryItem;
