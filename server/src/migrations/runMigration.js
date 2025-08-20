import sequelize from '../../config/database.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function runMigration() {
    try {
        console.log('🚀 Iniciando migración: AddFormulaModelsAndNavUpdate...');
        
        // Leer el archivo SQL
        const sqlPath = path.join(__dirname, '../../config/AddFormulaModelsAndNavUpdate.sql');
        const sql = fs.readFileSync(sqlPath, 'utf8');
        
        // Ejecutar la migración
        await sequelize.query(sql);
        
        console.log('✅ Migración completada exitosamente');
        console.log('📋 Se crearon las siguientes tablas:');
        console.log('   - products');
        console.log('   - inventory_items');
        console.log('   - formulas');
        console.log('   - formula_items');
        console.log('🌱 Se insertaron datos de prueba');
        
    } catch (error) {
        console.error('❌ Error ejecutando migración:', error);
    } finally {
        await sequelize.close();
    }
}

// Ejecutar si se llama directamente
if (import.meta.url === `file://${process.argv[1]}`) {
    runMigration();
}

export default runMigration;
