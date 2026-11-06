const db = require('../config/db');

// @desc   Get list of active conversations for logged in user
// @route  GET /api/chat/conversations
const getConversations = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // Get all doctors with latest message and unread count
    const [doctors] = await db.query('SELECT * FROM doctors ORDER BY id ASC');

    const conversations = await Promise.all(
      doctors.map(async (doc) => {
        // Last message
        const [lastMsg] = await db.query(
          `SELECT message, sender, created_at FROM chat_messages 
           WHERE user_id = ? AND doctor_id = ? 
           ORDER BY id DESC LIMIT 1`,
          [userId, doc.id]
        );

        // Unread count
        const [unread] = await db.query(
          `SELECT COUNT(*) AS count FROM chat_messages 
           WHERE user_id = ? AND doctor_id = ? AND sender = 'doctor' AND is_read = FALSE`,
          [userId, doc.id]
        );

        return {
          doctor_id: doc.id,
          doctor_name: doc.name,
          specialty: doc.specialty,
          hospital: doc.hospital,
          avatar_color: doc.avatar_color,
          online: Boolean(doc.online),
          last_message: lastMsg.length > 0 ? lastMsg[0].message : 'Available for consultation',
          last_message_time: lastMsg.length > 0 ? lastMsg[0].created_at : null,
          unread_count: unread[0].count,
        };
      })
    );

    res.json({
      success: true,
      data: conversations,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Get all messages between user and a doctor
// @route  GET /api/chat/:doctorId/messages
const getMessagesByDoctor = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const doctorId = req.params.doctorId;

    // Mark messages from doctor as read
    await db.query(
      `UPDATE chat_messages SET is_read = TRUE 
       WHERE user_id = ? AND doctor_id = ? AND sender = 'doctor'`,
      [userId, doctorId]
    );

    // Fetch messages
    const [messages] = await db.query(
      `SELECT id, user_id, doctor_id, sender, message, is_read, created_at 
       FROM chat_messages 
       WHERE user_id = ? AND doctor_id = ? 
       ORDER BY id ASC`,
      [userId, doctorId]
    );

    // Fetch doctor info
    const [doctor] = await db.query('SELECT * FROM doctors WHERE id = ?', [doctorId]);

    res.json({
      success: true,
      doctor: doctor.length > 0 ? doctor[0] : null,
      data: messages,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Send a message (HTTP fallback when not using WebSockets)
// @route  POST /api/chat/:doctorId/messages
const sendMessage = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const doctorId = req.params.doctorId;
    const { message, sender = 'user' } = req.body;

    if (!message || !message.trim()) {
      return res.status(400).json({
        success: false,
        message: 'Message cannot be empty',
      });
    }

    const [result] = await db.query(
      `INSERT INTO chat_messages (user_id, doctor_id, sender, message, is_read) 
       VALUES (?, ?, ?, ?, FALSE)`,
      [userId, doctorId, sender, message.trim()]
    );

    res.status(201).json({
      success: true,
      data: {
        id: result.insertId,
        user_id: userId,
        doctor_id: Number(doctorId),
        sender,
        message: message.trim(),
        is_read: false,
        created_at: new Date(),
      },
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getConversations,
  getMessagesByDoctor,
  sendMessage,
};

