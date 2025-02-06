import express from 'express'
import { insertDistribuidor, getDistribuidor, updateDistribuidor, rendUpdateDistribuidor,cambiarDistribuidorEstado } from '../controllers/distribuidorController.js'

const router = express.Router()

//Ruta para visualizar los distribuidores
router.get('/distribuidor', getDistribuidor)

//Ruta para agregar un distribuidor
router.post('/agregar', insertDistribuidor)

//Ruta para renderizar la vista de agregar un distribuidor
router.get('/distAgregar', (req, res) => {
    res.render('distribuidoresAgregar', { layout: 'layouts/layout' });
});

//Ruta para renderizar la vista de actualizar los distribuidores y que carga los datos del distribuidor a actualizar
router.get('/distEditar/:id', rendUpdateDistribuidor);

//Ruta para actualizar un distribuidor
router.post('/actualizar/:id', updateDistribuidor)

//Ruta para cambiar el estado de un distribuidor
router.post('/eliminar/:id', cambiarDistribuidorEstado);



export default router;