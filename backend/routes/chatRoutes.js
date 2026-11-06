const express = require('express');
const router = express.Router();
const {
  getConversations,
  getMessagesByDoctor,
  sendMessage,
} = require('../controllers/chatController');
const { protect } = require('../middleware/authMiddleware');

router.use(protect);

router.get('/conversations', getConversations);
router.get('/:doctorId/messages', getMessagesByDoctor);
router.post('/:doctorId/messages', sendMessage);

module.exports = router;

