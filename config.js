require('dotenv').config();
const fs = require('fs');

// Conexión a PostgreSQL
function connectionData()
{
    const conn = {
        user: process.env.DB_USER,
        host: process.env.DB_HOST,
        database: process.env.DB_NAME,
        password: process.env.DB_PASS,
        port: process.env.DB_PORT,
        ssl: {
            rejectUnauthorized : false,
            ca   : fs.readFileSync("certificado-db/ca-certificate.crt").toString()
        }
    }

    return conn;
}

module.exports = { connectionData };