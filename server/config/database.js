import { Sequelize, Op } from 'sequelize';
import dotenv from 'dotenv';

//ACA SE CARGAN LAS VARIABLES DE ENTORNO DE .env
dotenv.config();

const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASS,
    {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        dialect: process.env.DB_DIALECT,
        logging: false
    }
);

export { Op };
export default sequelize;
