const express = require('express');
const router = express.Router();
const {
  createAppointment,
  getUserAppointments,
  getAllAppointmentsAdmin,
  getAppointmentById,
  cancelAppointment,
  updateAppointmentStatus,
  deleteAppointment,
} = require('../controllers/appointmentController');
const { protect } = require('../middleware/authMiddleware');

// Public/Admin accessible endpoints (without strict bearer token or with optional token)
router.get('/admin/all', getAllAppointmentsAdmin);
router.put('/:id/status', updateAppointmentStatus);
router.delete('/:id', deleteAppointment);

// User-protected appointment endpoints
router.post('/', (req, res, next) => {
  // Allow admin portal or authenticated user to book
  if (req.headers.authorization) {
    return protect(req, res, next);
  }
  next();
}, createAppointment);

router.get('/', protect, getUserAppointments);
router.get('/:id', getAppointmentById);
router.put('/:id/cancel', cancelAppointment);

module.exports = router;
