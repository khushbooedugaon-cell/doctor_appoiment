const db = require('../config/db');

// @desc   Get comprehensive stats for Admin Dashboard
// @route  GET /api/admin/stats
const getDashboardStats = async (req, res, next) => {
  try {
    // 1. Doctor counts
    const [docCount] = await db.query('SELECT COUNT(*) AS total, SUM(CASE WHEN online = 1 THEN 1 ELSE 0 END) AS online_count FROM doctors');
    
    // 2. User counts
    const [userCount] = await db.query('SELECT COUNT(*) AS total FROM users');

    // 3. Appointment counts
    const [apptCounts] = await db.query(`
      SELECT 
        COUNT(*) AS total,
        SUM(CASE WHEN status = 'Upcoming' THEN 1 ELSE 0 END) AS upcoming,
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed,
        SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled
      FROM appointments
    `);

    // 4. Calculate approximate revenue from completed bookings
    const [revenueRows] = await db.query(`
      SELECT COALESCE(SUM(CAST(REPLACE(REPLACE(d.fee, '₹', ''), ',', '') AS UNSIGNED)), 0) AS total_revenue
      FROM appointments a
      JOIN doctors d ON a.doctor_id = d.id
      WHERE a.status = 'Completed'
    `);

    // 5. Recent 6 appointments
    const [recentAppointments] = await db.query(`
      SELECT 
        a.id, a.patient_name, a.phone, a.type, a.date, a.time, a.status, a.created_at,
        d.name AS doctor_name, d.specialty, d.hospital, d.fee, d.avatar_color
      FROM appointments a
      LEFT JOIN doctors d ON a.doctor_id = d.id
      ORDER BY a.id DESC
      LIMIT 6
    `);

    // 6. Specialty distribution
    const [specialtyCounts] = await db.query(`
      SELECT specialty, COUNT(*) AS count 
      FROM doctors 
      GROUP BY specialty 
      ORDER BY count DESC
    `);

    res.json({
      success: true,
      data: {
        doctors: {
          total: docCount[0].total || 0,
          online: docCount[0].online_count || 0,
        },
        users: {
          total: userCount[0].total || 0,
        },
        appointments: {
          total: apptCounts[0].total || 0,
          upcoming: apptCounts[0].upcoming || 0,
          completed: apptCounts[0].completed || 0,
          cancelled: apptCounts[0].cancelled || 0,
        },
        revenue: {
          total: Number(revenueRows[0].total_revenue) || 0,
          currency: '₹',
        },
        recent_appointments: recentAppointments,
        specialties: specialtyCounts,
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Broadcast a notification to all users or a specific user (Admin)
// @route  POST /api/admin/broadcast
const broadcastNotification = async (req, res, next) => {
  try {
    const { title, message, category = 'Alerts', user_id } = req.body;

    if (!title || !message) {
      return res.status(400).json({
        success: false,
        message: 'Title and message are required',
      });
    }

    if (user_id) {
      await db.query(
        'INSERT INTO notifications (user_id, title, message, category) VALUES (?, ?, ?, ?)',
        [user_id, title, message, category]
      );
    } else {
      // Broadcast to all users
      const [allUsers] = await db.query('SELECT id FROM users');
      if (allUsers.length > 0) {
        const values = allUsers.map((u) => [u.id, title, message, category]);
        await db.query(
          'INSERT INTO notifications (user_id, title, message, category) VALUES ?',
          [values]
        );
      }
    }

    res.json({
      success: true,
      message: user_id ? 'Notification sent to user' : 'Broadcast sent to all users',
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Admin Login
// @route  POST /api/admin/login
const adminLogin = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const adminEmail = process.env.ADMIN_EMAIL || 'admin@medicare.com';
    const adminPassword = process.env.ADMIN_PASSWORD || 'admin123';

    if ((email === adminEmail || email === 'admin') && password === adminPassword) {
      return res.json({
        success: true,
        message: 'Admin authenticated successfully',
        data: {
          id: 1,
          name: 'Chief Medical Administrator',
          email: adminEmail,
          role: 'Super Admin',
          token: 'medicare_admin_token_' + Date.now(),
        },
      });
    }

    return res.status(401).json({
      success: false,
      message: 'Invalid credentials. Default admin: admin@medicare.com / admin123',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getDashboardStats,
  broadcastNotification,
  adminLogin,
};

