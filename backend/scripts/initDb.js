const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

async function initDatabase() {
  console.log('🔄 Initializing MediCare MySQL Database...');

  const config = {
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: (process.env.DB_HOST && process.env.DB_HOST.includes('tidbcloud')) ? 'sys' : undefined,
    multipleStatements: true,
  };

  if (
    process.env.DB_SSL === 'true' ||
    (process.env.DB_HOST && process.env.DB_HOST !== 'localhost' && process.env.DB_HOST !== '127.0.0.1')
  ) {
    config.ssl = { minVersion: 'TLSv1.2', rejectUnauthorized: true };
  }

  try {
    const connection = await mysql.createConnection(config);
    console.log('✅ Connected to MySQL server successfully.');

    const sqlFilePath = path.join(__dirname, '..', 'models', 'schema.sql');
    const sqlQueries = fs.readFileSync(sqlFilePath, 'utf8');

    console.log('⚙️ Executing schema.sql script...');
    await connection.query(sqlQueries);

    console.log('🎉 Database and tables initialized successfully!');
    await connection.end();
    process.exit(0);
  } catch (err) {
    console.error('❌ Failed to initialize database:');
    console.error(err.message);
    console.log('\n💡 Tip: Please make sure your MySQL service is running and check DB credentials in backend/.env');
    process.exit(1);
  }
}

initDatabase();

