const mysql = require('mysql2/promise');
require('dotenv').config();

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT) || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'medicare_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
};

// Cloud MySQL SSL support (automatically enabled for remote hosts like TiDB, Aiven, Railway)
if (
  process.env.DB_SSL === 'true' ||
  (process.env.DB_HOST && process.env.DB_HOST !== 'localhost' && process.env.DB_HOST !== '127.0.0.1')
) {
  dbConfig.ssl = {
    minVersion: 'TLSv1.2',
    rejectUnauthorized: true,
  };
}

const pool = mysql.createPool(dbConfig);

// Test connection on startup and auto-seed default users if empty
(async () => {
  try {
    const connection = await pool.getConnection();
    console.log(`📦 Connected to MySQL Database: ${process.env.DB_NAME || 'medicare_db'}`);
    
    // Check if users table is empty and seed demo users
    try {
      const [rows] = await connection.query('SELECT COUNT(*) AS count FROM users');
      if (rows && rows[0].count === 0) {
        console.log('🌱 Seeding initial demo patients into MySQL...');
        await connection.query(`
          INSERT INTO users (id, name, email, phone, password, city, blood_group, weight, height)
          VALUES 
          (1, 'Rahul Kumar', 'rahul@gmail.com', '+91 98765 43210', '$2a$10$su7PTbhef5DR1EorTk.HE.8esJrttKYIrquTtlDl1nTB7mvG3UBke', 'Patna', 'O+', '68 kg', "5'9\\""),
          (2, 'Sneha Singh', 'sneha@gmail.com', '+91 98112 33445', '$2a$10$su7PTbhef5DR1EorTk.HE.8esJrttKYIrquTtlDl1nTB7mvG3UBke', 'Delhi', 'A+', '54 kg', "5'4\\"")
        `);
        console.log('✅ Demo patients (rahul@gmail.com / password123) seeded in MySQL!');
      }
    } catch (seedErr) {
      // Table might not exist yet if db:init hasn't run
    }

    connection.release();
  } catch (error) {
    console.warn(`⚠️ Warning: Could not connect to MySQL database (${error.message}).`);
    console.warn(`   Run 'npm run db:init' after verifying your MySQL service & credentials in .env`);
  }
})();

module.exports = pool;

