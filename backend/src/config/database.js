const mysql = require('mysql2');
require('dotenv').config();

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '1234root',
    database: process.env.DB_NAME || 'accountingapp',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// 使用 Promise 版本
const promisePool = pool.promise();

// 测试连接
pool.getConnection((err, connection) => {
    if (err) {
        console.error('MySQL 连接失败:', err.message);
        return;
    }
    console.log('MySQL 连接成功');
    connection.release();
});

module.exports = { pool, promisePool };