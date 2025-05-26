
const mysql = require('mysql2');
const dotenv = require('dotenv');
dotenv.config();

const pool = mysql.createPool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
});

// verify the connection to the database
pool.getConnection((err, release) => {
  if (err) {
    console.log('Error de conexión a la base de datos', err.stack);
  } else {
    console.log('Conexión a la base de datos exitosa');
    release();
  }
});

module.exports = pool;