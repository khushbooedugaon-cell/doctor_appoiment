const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/db');

const generateToken = (id, email) => {
  return jwt.sign(
    { id, email },
    process.env.JWT_SECRET || 'medicare_jwt_secret_key',
    { expiresIn: process.env.JWT_EXPIRES_IN || '30d' }
  );
};

// Resilient fallback storage if MySQL is being configured / offline
const memoryUsers = [
  {
    id: 1,
    name: 'Rahul Kumar',
    email: 'rahul@gmail.com',
    phone: '+91 98765 43210',
    passwordHash: '$2a$10$su7PTbhef5DR1EorTk.HE.8esJrttKYIrquTtlDl1nTB7mvG3UBke',
    plainPassword: 'password123',
    city: 'Patna',
    blood_group: 'O+',
    weight: '68 kg',
    height: "5'9\"",
  },
  {
    id: 2,
    name: 'Sneha Singh',
    email: 'sneha@gmail.com',
    phone: '+91 98112 33445',
    passwordHash: '$2a$10$su7PTbhef5DR1EorTk.HE.8esJrttKYIrquTtlDl1nTB7mvG3UBke',
    plainPassword: 'password123',
    city: 'Delhi',
    blood_group: 'A+',
    weight: '54 kg',
    height: "5'4\"",
  },
];

// @desc   Register a new user
// @route  POST /api/auth/register
const register = async (req, res, next) => {
  try {
    let body = req.body;
    if (typeof body === 'string') {
      try {
        body = JSON.parse(body);
      } catch (e) {}
    }

    const name = (body?.name || req.query?.name || '').toString().trim();
    const email = (body?.email || req.query?.email || '').toString().trim().toLowerCase();
    const phone = (body?.phone || req.query?.phone || '').toString().trim();
    const password = (body?.password || req.query?.password || '').toString().trim();
    const city = (body?.city || req.query?.city || 'Patna').toString().trim();

    console.log(`📝 [Register Request] Name: "${name}", Email: "${email}", Phone: "${phone}", City: "${city}"`);

    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Name, email, and password are required',
      });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // 1. Check if user already exists in MySQL
    const [existing] = await db.query('SELECT id FROM users WHERE LOWER(email) = ?', [email]);
    if (existing.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'User with this email already exists',
      });
    }

    // 2. Insert user into MySQL
    const [result] = await db.query(
      'INSERT INTO users (name, email, phone, password, city) VALUES (?, ?, ?, ?, ?)',
      [name, email, phone || '', hashedPassword, city || 'Patna']
    );

    const userId = result.insertId;
    const token = generateToken(userId, email);

    console.log(`✅ [User Registered in MySQL Database] ID: ${userId}, Email: "${email}"`);

    return res.status(201).json({
      success: true,
      message: 'User registered successfully in MySQL database',
      data: {
        id: userId,
        name,
        email,
        phone: phone || '',
        city: city || 'Patna',
        token,
      },
    });
  } catch (error) {
    console.error('❌ [Register Error]:', error.message);
    next(error);
  }
};

// @desc   Login user
// @route  POST /api/auth/login
const login = async (req, res, next) => {
  try {
    let body = req.body;
    if (typeof body === 'string') {
      try {
        body = JSON.parse(body);
      } catch (e) {}
    }

    const email = (body?.email || body?.username || req.query?.email || '').toString().trim().toLowerCase();
    const password = (body?.password || req.query?.password || '').toString().trim();

    console.log(`🔑 [Login Request] Email: "${email}"`);

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide email and password',
      });
    }

    try {
      // 1. Try MySQL Database
      const [rows] = await db.query('SELECT * FROM users WHERE LOWER(email) = LOWER(?)', [email]);
      if (rows.length > 0) {
        const user = rows[0];
        let isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch && user.password === password) {
          isMatch = true;
        }

        if (!isMatch) {
          return res.status(401).json({
            success: false,
            message: 'Invalid email or password',
          });
        }

        const token = generateToken(user.id, user.email);
        return res.json({
          success: true,
          message: 'Login successful',
          data: {
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            city: user.city,
            blood_group: user.blood_group,
            weight: user.weight,
            height: user.height,
            token,
          },
        });
      }
    } catch (dbError) {
      console.warn('⚠️ [DB Warning] MySQL login check failed, using fallback:', dbError.message);
    }

    // 2. Fallback check memory users
    const memUser = memoryUsers.find(
      (u) => u.email.toLowerCase() === email.toLowerCase()
    );
    if (memUser) {
      let isMatch = false;
      if (memUser.passwordHash) {
        isMatch = await bcrypt.compare(password, memUser.passwordHash);
      }
      if (!isMatch && memUser.plainPassword) {
        isMatch = password === memUser.plainPassword;
      }

      if (isMatch) {
        const token = generateToken(memUser.id, memUser.email);
        return res.json({
          success: true,
          message: 'Login successful',
          data: {
            id: memUser.id,
            name: memUser.name,
            email: memUser.email,
            phone: memUser.phone,
            city: memUser.city,
            blood_group: memUser.blood_group,
            weight: memUser.weight,
            height: memUser.height,
            token,
          },
        });
      }
    }

    return res.status(401).json({
      success: false,
      message: 'Invalid email or password',
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Get user profile
// @route  GET /api/auth/profile
const getProfile = async (req, res, next) => {
  try {
    try {
      const [rows] = await db.query(
        'SELECT id, name, email, phone, city, blood_group, weight, height, created_at FROM users WHERE id = ?',
        [req.user.id]
      );
      if (rows.length > 0) {
        return res.json({ success: true, data: rows[0] });
      }
    } catch (dbErr) {
      console.warn('⚠️ [getAllUsers] MySQL query failed, falling back:', dbErr.message);
    }

    const memUser = memoryUsers.find((u) => u.id === req.user.id);
    if (memUser) {
      return res.json({ success: true, data: memUser });
    }

    return res.status(404).json({ success: false, message: 'User not found' });
  } catch (error) {
    next(error);
  }
};

// @desc   Update user profile
// @route  PUT /api/auth/profile
const updateProfile = async (req, res, next) => {
  try {
    const { name, phone, city, blood_group, weight, height } = req.body;

    try {
      await db.query(
        `UPDATE users 
         SET name = COALESCE(?, name),
             phone = COALESCE(?, phone),
             city = COALESCE(?, city),
             blood_group = COALESCE(?, blood_group),
             weight = COALESCE(?, weight),
             height = COALESCE(?, height)
         WHERE id = ?`,
        [name, phone, city, blood_group, weight, height, req.user.id]
      );

      const [updated] = await db.query(
        'SELECT id, name, email, phone, city, blood_group, weight, height FROM users WHERE id = ?',
        [req.user.id]
      );

      if (updated.length > 0) {
        return res.json({
          success: true,
          message: 'Profile updated successfully',
          data: updated[0],
        });
      }
    } catch (dbErr) {
      console.warn('⚠️ [getAllUsers] MySQL query failed, falling back:', dbErr.message);
    }

    const memUser = memoryUsers.find((u) => u.id === req.user.id);
    if (memUser) {
      if (name) memUser.name = name;
      if (phone) memUser.phone = phone;
      if (city) memUser.city = city;
      if (blood_group) memUser.blood_group = blood_group;
      if (weight) memUser.weight = weight;
      if (height) memUser.height = height;

      return res.json({
        success: true,
        message: 'Profile updated successfully',
        data: memUser,
      });
    }

    return res.status(404).json({ success: false, message: 'User not found' });
  } catch (error) {
    next(error);
  }
};

// @desc   Get all registered users / patients (Admin)
// @route  GET /api/auth/users
const getAllUsers = async (req, res, next) => {
  try {
    const { search } = req.query;
    try {
      let query = `
        SELECT u.id, u.name, u.email, u.phone, u.city, u.blood_group, u.weight, u.height, u.created_at,
               COUNT(a.id) AS appointment_count
        FROM users u
        LEFT JOIN appointments a ON u.id = a.user_id
        WHERE 1=1
      `;
      const params = [];

      if (search) {
        query += ' AND (u.name LIKE ? OR u.email LIKE ? OR u.phone LIKE ? OR u.city LIKE ?)';
        const term = `%${search}%`;
        params.push(term, term, term, term);
      }

      query += ' GROUP BY u.id ORDER BY u.id DESC';

      const [users] = await db.query(query, params);
      return res.json({
        success: true,
        count: users.length,
        data: users,
      });
    } catch (dbErr) {
      console.warn('⚠️ [getAllUsers] MySQL query failed, falling back:', dbErr.message);
    }

    let filtered = memoryUsers;
    if (search) {
      const term = search.toLowerCase();
      filtered = memoryUsers.filter(
        (u) =>
          u.name.toLowerCase().includes(term) ||
          u.email.toLowerCase().includes(term) ||
          u.phone.includes(term) ||
          u.city.toLowerCase().includes(term)
      );
    }

    return res.json({
      success: true,
      count: filtered.length,
      data: filtered,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Delete a user (Admin)
// @route  DELETE /api/auth/users/:id
const deleteUser = async (req, res, next) => {
  try {
    const { id } = req.params;
    try {
      const [result] = await db.query('DELETE FROM users WHERE id = ?', [id]);
      if (result.affectedRows > 0) {
        return res.json({ success: true, message: 'User deleted successfully' });
      }
    } catch (dbErr) {
      console.warn('⚠️ [getAllUsers] MySQL query failed, falling back:', dbErr.message);
    }

    const idx = memoryUsers.findIndex((u) => u.id === parseInt(id));
    if (idx !== -1) {
      memoryUsers.splice(idx, 1);
      return res.json({ success: true, message: 'User deleted successfully' });
    }

    return res.status(404).json({ success: false, message: 'User not found' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  getProfile,
  updateProfile,
  getAllUsers,
  deleteUser,
};
