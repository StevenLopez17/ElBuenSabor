import express from 'express';
import { publicHome } from '../controllers/homeController.js';

const router = express.Router();

// GET / - Página de inicio pública (landing) - [AllowAnonymous]
router.get('/', publicHome);

export default router;
