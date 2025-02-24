import InventarioMateriasPrimas from "../models/materiaPrimaModel.js";

const getMateriaPrima = async (req, res) => {


    const materiaPrima = await InventarioMateriasPrimas.findAll();


    res.render('materiaPrima', {
        layout: 'layouts/layout',
        materiaPrima
    }
    )

}

const insertarMateriaPrimaView = async (req, res) => {
    res.render('insertarMateriaPrima', {
        layout: 'layouts/layout'
    });
}

const insertarMateriaPrima = async (req, res) => {

    const { id, producto_id, fecha } = req.body;

    await InventarioMateriasPrimas.create({
        nombre,
        cantidad,
        precio
    });

    console.log('Materia Prima insertada correctamente');
    res.redirect('/materiaPrima');

}

export {
    getMateriaPrima,
    insertarMateriaPrima,
    insertarMateriaPrimaView
}