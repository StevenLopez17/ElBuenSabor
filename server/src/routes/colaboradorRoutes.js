import express from 'express'
import { insertColaborador, getColaboradores, agregarVista, rendUpdateColaborador, updateColaborador, cambiarColaboradorEstado } from '../controllers/colaboradorController.js'

const router = express.Router()

//Ruta para visualizar los colaboradores
router.get('/colaboradores', getColaboradores);

//Ruta para agregar un colaborador
router.post('/insertColaborador', insertColaborador);

//Ruta para renderizar la vista de agregar un colaborador
router.get('/colabAgregar', agregarVista);

//Ruta para renderizar la vista de actualizar los colaboradores y que carga los datos del distribuidor a actualizar
router.get('/colabEditar/:id', rendUpdateColaborador);

//Ruta para actualizar un colaborador
router.post('/colabActualizar/:id', updateColaborador)

//Ruta para cambiar el estado de un colaborador
router.post('/estadoColaborador/:id', cambiarColaboradorEstado);



export default router;