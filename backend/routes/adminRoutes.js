const express = require('express');
const router = express.Router();
const {
  getDashboardStats,
  broadcastNotification,
  adminLogin,
} = require('../controllers/adminController');

router.post('/login', adminLogin);
router.get('/stats', getDashboardStats);
router.post('/broadcast', broadcastNotification);

module.exports = router;

