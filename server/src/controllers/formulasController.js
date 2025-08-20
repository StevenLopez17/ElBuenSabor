import Product from '../models/productModel.js';
import InventoryItem from '../models/inventoryItemModel.js';
import Formula from '../models/formulaModel.js';
import FormulaItem from '../models/formulaItemModel.js';
import sequelize from '../../config/database.js';

// GET /formulas - Listar todas las fórmulas
export const index = async (req, res) => {
    try {
        const formulas = await Formula.findAll({
            include: [
                {
                    model: Product,
                    as: 'product'
                },
                {
                    model: FormulaItem,
                    as: 'items',
                    include: [{
                        model: InventoryItem,
                        as: 'inventoryItem'
                    }]
                }
            ],
            order: [['createdAt', 'DESC']]
        });

        res.render('formulas/index', {
            layout: 'layouts/layout',
            formulas
        });
    } catch (error) {
        console.error('Error al obtener fórmulas:', error);
        res.redirect('/');
    }
};

// GET /formulas/create - Mostrar formulario de creación
export const create = async (req, res) => {
    try {
        const products = await Product.findAll({
            where: { isFinishedProduct: true },
            order: [['name', 'ASC']]
        });

        const inventoryItems = await InventoryItem.findAll({
            order: [['name', 'ASC']]
        });

        res.render('formulas/create', {
            layout: 'layouts/layout',
            products,
            inventoryItems,
            errores: [],
            success: []
        });
    } catch (error) {
        console.error('Error al cargar formulario de creación:', error);
        res.redirect('/formulas');
    }
};

// POST /formulas - Crear nueva fórmula
export const store = async (req, res) => {
    const transaction = await sequelize.transaction();
    
    try {
        const { productId, name, notes, items } = req.body;
        let errores = [];
        let success = [];

        // Validaciones
        if (!productId) errores.push({ msg: 'Debe seleccionar un producto' });
        if (!name || name.trim() === '') errores.push({ msg: 'El nombre de la fórmula es obligatorio' });
        
        // Validar items
        let formulaItems = [];
        if (Array.isArray(items) && items.length > 0) {
            for (let item of items) {
                if (item.inventoryItemId && item.quantityPerUnit > 0) {
                    formulaItems.push({
                        inventoryItemId: parseInt(item.inventoryItemId),
                        quantityPerUnit: parseFloat(item.quantityPerUnit)
                    });
                }
            }
        }

        if (formulaItems.length === 0) {
            errores.push({ msg: 'Debe agregar al menos un ingrediente con cantidad válida' });
        }

        if (errores.length > 0) {
            await transaction.rollback();
            
            const products = await Product.findAll({
                where: { isFinishedProduct: true },
                order: [['name', 'ASC']]
            });

            const inventoryItems = await InventoryItem.findAll({
                order: [['name', 'ASC']]
            });

            return res.render('formulas/create', {
                layout: 'layouts/layout',
                products,
                inventoryItems,
                errores,
                success,
                formData: req.body
            });
        }

        // Crear la fórmula
        const formula = await Formula.create({
            productId: parseInt(productId),
            name: name.trim(),
            notes: notes ? notes.trim() : null
        }, { transaction });

        // Crear los items de la fórmula
        for (let item of formulaItems) {
            await FormulaItem.create({
                formulaId: formula.id,
                inventoryItemId: item.inventoryItemId,
                quantityPerUnit: item.quantityPerUnit
            }, { transaction });
        }

        await transaction.commit();

        console.log(`Nueva fórmula creada: ${formula.name} (ID: ${formula.id})`);
        res.redirect('/formulas');

    } catch (error) {
        await transaction.rollback();
        console.error('Error al crear fórmula:', error);
        
        const products = await Product.findAll({
            where: { isFinishedProduct: true },
            order: [['name', 'ASC']]
        });

        const inventoryItems = await InventoryItem.findAll({
            order: [['name', 'ASC']]
        });

        res.render('formulas/create', {
            layout: 'layouts/layout',
            products,
            inventoryItems,
            errores: [{ msg: 'Error interno del servidor' }],
            success: [],
            formData: req.body
        });
    }
};

// GET /formulas/:id - Mostrar detalles de una fórmula
export const show = async (req, res) => {
    try {
        const formula = await Formula.findByPk(req.params.id, {
            include: [
                {
                    model: Product,
                    as: 'product'
                },
                {
                    model: FormulaItem,
                    as: 'items',
                    include: [{
                        model: InventoryItem,
                        as: 'inventoryItem'
                    }]
                }
            ]
        });

        if (!formula) {
            return res.redirect('/formulas');
        }

        res.render('formulas/details', {
            layout: 'layouts/layout',
            formula
        });
    } catch (error) {
        console.error('Error al obtener fórmula:', error);
        res.redirect('/formulas');
    }
};

// GET /formulas/:id/edit - Mostrar formulario de edición
export const edit = async (req, res) => {
    try {
        const formula = await Formula.findByPk(req.params.id, {
            include: [
                {
                    model: Product,
                    as: 'product'
                },
                {
                    model: FormulaItem,
                    as: 'items',
                    include: [{
                        model: InventoryItem,
                        as: 'inventoryItem'
                    }]
                }
            ]
        });

        if (!formula) {
            return res.redirect('/formulas');
        }

        const products = await Product.findAll({
            where: { isFinishedProduct: true },
            order: [['name', 'ASC']]
        });

        const inventoryItems = await InventoryItem.findAll({
            order: [['name', 'ASC']]
        });

        res.render('formulas/edit', {
            layout: 'layouts/layout',
            formula,
            products,
            inventoryItems,
            errores: [],
            success: []
        });
    } catch (error) {
        console.error('Error al cargar formulario de edición:', error);
        res.redirect('/formulas');
    }
};

// PUT /formulas/:id - Actualizar fórmula
export const update = async (req, res) => {
    const transaction = await sequelize.transaction();
    
    try {
        const { productId, name, notes, items } = req.body;
        let errores = [];
        let success = [];

        const formula = await Formula.findByPk(req.params.id);
        if (!formula) {
            return res.redirect('/formulas');
        }

        // Validaciones
        if (!productId) errores.push({ msg: 'Debe seleccionar un producto' });
        if (!name || name.trim() === '') errores.push({ msg: 'El nombre de la fórmula es obligatorio' });
        
        // Validar items
        let formulaItems = [];
        if (Array.isArray(items) && items.length > 0) {
            for (let item of items) {
                if (item.inventoryItemId && item.quantityPerUnit > 0) {
                    formulaItems.push({
                        inventoryItemId: parseInt(item.inventoryItemId),
                        quantityPerUnit: parseFloat(item.quantityPerUnit)
                    });
                }
            }
        }

        if (formulaItems.length === 0) {
            errores.push({ msg: 'Debe agregar al menos un ingrediente con cantidad válida' });
        }

        if (errores.length > 0) {
            await transaction.rollback();
            
            const products = await Product.findAll({
                where: { isFinishedProduct: true },
                order: [['name', 'ASC']]
            });

            const inventoryItems = await InventoryItem.findAll({
                order: [['name', 'ASC']]
            });

            return res.render('formulas/edit', {
                layout: 'layouts/layout',
                formula,
                products,
                inventoryItems,
                errores,
                success
            });
        }

        // Actualizar la fórmula
        await formula.update({
            productId: parseInt(productId),
            name: name.trim(),
            notes: notes ? notes.trim() : null
        }, { transaction });

        // Eliminar items existentes
        await FormulaItem.destroy({
            where: { formulaId: formula.id },
            transaction
        });

        // Crear nuevos items
        for (let item of formulaItems) {
            await FormulaItem.create({
                formulaId: formula.id,
                inventoryItemId: item.inventoryItemId,
                quantityPerUnit: item.quantityPerUnit
            }, { transaction });
        }

        await transaction.commit();

        console.log(`Fórmula actualizada: ${formula.name} (ID: ${formula.id})`);
        res.redirect('/formulas');

    } catch (error) {
        await transaction.rollback();
        console.error('Error al actualizar fórmula:', error);
        res.redirect('/formulas');
    }
};

// DELETE /formulas/:id - Eliminar fórmula
export const destroy = async (req, res) => {
    try {
        const formula = await Formula.findByPk(req.params.id);
        
        if (!formula) {
            return res.redirect('/formulas');
        }

        await formula.destroy();
        console.log(`Fórmula eliminada: ${formula.name} (ID: ${formula.id})`);
        res.redirect('/formulas');

    } catch (error) {
        console.error('Error al eliminar fórmula:', error);
        res.redirect('/formulas');
    }
};
