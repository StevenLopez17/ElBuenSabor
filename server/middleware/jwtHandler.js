import jwt from 'jsonwebtoken'
import { StatusCodes } from 'http-status-codes';
import { v4 as uuidv4 } from 'uuid';
import { config } from 'dotenv';
import { getUsuario, createUsuario } from '../controllers/usuariosController.js';
import { postToken } from '../controllers/tokensController.js';

config();

const JWT_SECRET_KEY = process.env.JWT_SECRET_KEY;

const getToken = async (username, password) => {
    if (!username || !password) {
        const error = new Error('Username and password are required');
        error.statusCode = StatusCodes.BAD_REQUEST;
        throw error;
    }

    const error = new Error('Authentication failed');
    error.statusCode = StatusCodes.UNAUTHORIZED;

    //const hashedPassword = crypto.MD5(password).toString();
    // Validate credentials
    const result = await getUsuario(username, password);

    if (!result) {
        throw error;
    }

    const hours = 12;
    // const id = uuidv4();
    const id = result._id;
    const token = {
        id,
        username,
        creationDate: new Date(Date.now()),
        expirationDate: new Date(Date.now() + (hours * 60 * 60 * 1000))
    };

    if (!await postToken(token)) {
        throw error;
    }

    const jwtToken = jwt.sign({ id }, JWT_SECRET_KEY,
        { expiresIn: hours.toString() + 'h' })
    return jwtToken;
};


const verifyToken = (token) => {
    if (!token) {
        const error = new Error('Token is missing or not provided.');
        error.statusCode = StatusCodes.BAD_REQUEST;
        throw error;
    }
    token = token.split(' ')[1];
    try {
        const payload = jwt.verify(token, JWT_SECRET_KEY);
        return payload.id;
    } catch (error) {
        error.statusCode = StatusCodes.FORBIDDEN;
        throw error;
    }
};


export const validateCredentials = async (req, res, next) => {
    try {
        const username = req.body.username;
        const password = req.body.password;
        const token = await getToken(username, password);
        res.status(StatusCodes.OK).json({ success: true, data: { token } })
    } catch (error) {
        next(error);
    }
}

export const validateToken = (req, res, next) => {
    try {
        const token = req.headers.authorization;
        const id = verifyToken(token);
        req.id = id;
        next();
    } catch (error) {
        next(error);
    }
}

export const createCredentials = async (req, res, next) => {
    try {
        const username = req.body.username;
        const password = req.body.password;

        if (!username || !password || username.trim().length === 0 || password.trim().length === 0) {
            const error = new Error('Username and password are required');
            error.statusCode = StatusCodes.UNPROCESSABLE_ENTITY;
            throw error;
        }

        const result = await createUsuario(username, password);
        const token = await getToken(username, password);
        res.status(StatusCodes.OK).json({ success: true, data: { token } })
    } catch (error) {
        next(error);
    }
}