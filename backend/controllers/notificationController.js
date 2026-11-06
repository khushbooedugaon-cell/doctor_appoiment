const db = require('../config/db');

// @desc   Get user notifications
// @route  GET /api/notifications
const getNotifications = async (req, res, next) => {
  try {
    const { category } = req.query; // 'Appointments', 'Messages', 'Alerts'
    let query = 'SELECT * FROM notifications WHERE user_id = ?';
    const params = [req.user.id];

    if (category) {
      query += ' AND category = ?';
      params.push(category);
    }

    query += ' ORDER BY id DESC';

    const [rows] = await db.query(query, params);

    res.json({
      success: true,
      count: rows.length,
      data: rows,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Mark notification(s) as read
// @route  PUT /api/notifications/read
const markAsRead = async (req, res, next) => {
  try {
    const { id } = req.body; // If id provided, mark specific; if omitted, mark all

    if (id) {
      await db.query(
        'UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?',
        [id, req.user.id]
      );
    } else {
      await db.query(
        'UPDATE notifications SET is_read = TRUE WHERE user_id = ?',
        [req.user.id]
      );
    }

    res.json({
      success: true,
      message: 'Notification(s) marked as read',
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Clear/Delete all notifications for user
// @route  DELETE /api/notifications
const clearAll = async (req, res, next) => {
  try {
    await db.query('DELETE FROM notifications WHERE user_id = ?', [req.user.id]);

    res.json({
      success: true,
      message: 'All notifications cleared',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getNotifications,
  markAsRead,
  clearAll,
};

