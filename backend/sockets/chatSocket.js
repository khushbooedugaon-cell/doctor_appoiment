const db = require('../config/db');

module.exports = function (io) {
  io.on('connection', (socket) => {
    console.log(`🔌 New client connected: ${socket.id}`);

    // Join doctor consultation chat room
    socket.on('join_chat', ({ userId, doctorId }) => {
      const room = `chat_${userId}_${doctorId}`;
      socket.join(room);
      console.log(`👤 Client ${socket.id} joined ${room}`);
    });

    // Handle real-time message sending
    socket.on('send_message', async ({ userId, doctorId, sender, message }) => {
      try {
        if (!message || !message.trim()) return;

        // Persist message in database
        const [result] = await db.query(
          `INSERT INTO chat_messages (user_id, doctor_id, sender, message, is_read) 
           VALUES (?, ?, ?, ?, FALSE)`,
          [userId, doctorId, sender || 'user', message.trim()]
        );

        const newMsg = {
          id: result.insertId,
          user_id: userId,
          doctor_id: doctorId,
          sender: sender || 'user',
          message: message.trim(),
          is_read: false,
          created_at: new Date().toISOString(),
        };

        const room = `chat_${userId}_${doctorId}`;
        // Broadcast to everyone in room (including sender or excluding based on need)
        io.to(room).emit('receive_message', newMsg);
      } catch (err) {
        console.error('Error saving chat message:', err.message);
        socket.emit('error', { message: 'Failed to deliver message' });
      }
    });

    // Handle typing status
    socket.on('typing', ({ userId, doctorId, isTyping, sender }) => {
      const room = `chat_${userId}_${doctorId}`;
      socket.to(room).emit('user_typing', { isTyping, sender });
    });

    // Disconnect
    socket.on('disconnect', () => {
      console.log(`❌ Client disconnected: ${socket.id}`);
    });
  });
};

