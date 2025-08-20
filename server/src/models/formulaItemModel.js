import { DataTypes } from "sequelize";
import sequelize from "../../config/database.js";

const FormulaItem = sequelize.define("FormulaItem", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  formulaId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'formula_id',
    references: {
      model: 'formulas',
      key: 'id'
    }
  },
  inventoryItemId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'inventory_item_id',
    references: {
      model: 'inventory_items',
      key: 'id'
    }
  },
  quantityPerUnit: {
    type: DataTypes.FLOAT,
    allowNull: false,
    field: 'quantity_per_unit'
  }
}, {
  tableName: 'formula_items', 
  timestamps: false
});

export default FormulaItem;
