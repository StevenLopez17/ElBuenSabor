import express from 'express';
import { mostrarInicio } from '../controllers/indexController.js';

const router = express.Router();

router.get('/', mostrarInicio);

export default router;
