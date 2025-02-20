import fs from 'fs';
import path from 'path';
import { Sequelize } from 'sequelize';
import { fileURLToPath } from 'url';
import sequelize from '../../config/database.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const db = {};


// Importar modelos manualmente si es necesario
import Distribuidores from './distribuidorModel.js'; 
db.Distribuidores = Distribuidores;

// Cargar automáticamente otros modelos en la carpeta models/
fs.readdirSync(__dirname)
  .filter(file => file.endsWith('.js') && file !== 'main.js')
  .forEach(async (file) => {
    const module = await import(`file://${path.join(__dirname, file)}`);
    const model = module.default;
    db[model.name] = model;
  });


  Object.keys(db).forEach(modelName => {
    if (db[modelName].associate) {
      db[modelName].associate(db);
    }
  });




db.sequelize = sequelize;
db.Sequelize = Sequelize;

export default db;
