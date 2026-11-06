const db = require('../config/db');

// @desc   Create new appointment booking
// @route  POST /api/appointments
const createAppointment = async (req, res, next) => {
  try {
    const { doctor_id, patient_name, phone, type, date, time, note } = req.body;
    const userId = req.user ? req.user.id : (req.body.user_id || 1);

    if (!doctor_id || !patient_name || !phone || !date || !time) {
      return res.status(400).json({
        success: false,
        message: 'doctor_id, patient_name, phone, date, and time are required',
      });
    }

    // Verify doctor exists
    const [doctors] = await db.query('SELECT name FROM doctors WHERE id = ?', [doctor_id]);
    if (doctors.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found',
      });
    }

    const doctorName = doctors[0].name;

    // Insert appointment
    const [result] = await db.query(
      `INSERT INTO appointments 
       (user_id, doctor_id, patient_name, phone, type, date, time, note, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Upcoming')`,
      [userId, doctor_id, patient_name, phone, type || 'In Clinic', date, time, note || '']
    );

    // Auto-create confirmation notification for user
    await db.query(
      `INSERT INTO notifications (user_id, title, message, category, action_type)
       VALUES (?, ?, ?, 'Appointments', 'view_appointment')`,
      [
        userId,
        'Booking Confirmed!',
        `Your consultation with ${doctorName} on ${date} at ${time} has been scheduled.`,
      ]
    );

    res.status(201).json({
      success: true,
      message: 'Appointment booked successfully',
      data: {
        id: result.insertId,
        user_id: userId,
        doctor_id,
        doctor_name: doctorName,
        patient_name,
        phone,
        type: type || 'In Clinic',
        date,
        time,
        note,
        status: 'Upcoming',
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Get logged-in user's appointments (supports status filter)
// @route  GET /api/appointments
const getUserAppointments = async (req, res, next) => {
  try {
    const { status } = req.query; // 'Upcoming', 'Completed', 'Cancelled'
    let query = `
      SELECT 
        a.id, a.user_id, a.doctor_id, a.patient_name, a.phone, 
        a.type, a.date, a.time, a.note, a.status, a.created_at,
        d.name AS doctor_name, d.specialty, d.hospital, d.fee, d.avatar_color
      FROM appointments a
      JOIN doctors d ON a.doctor_id = d.id
      WHERE a.user_id = ?
    `;
    const params = [req.user.id];

    if (status) {
      query += ' AND a.status = ?';
      params.push(status);
    }

    query += ' ORDER BY a.id DESC';

    const [appointments] = await db.query(query, params);

    res.json({
      success: true,
      count: appointments.length,
      data: appointments,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Get all appointments across all users (Admin)
// @route  GET /api/appointments/admin/all
const getAllAppointmentsAdmin = async (req, res, next) => {
  try {
    const { status, search } = req.query;
    let query = `
      SELECT 
        a.id, a.user_id, a.doctor_id, a.patient_name, a.phone, 
        a.type, a.date, a.time, a.note, a.status, a.created_at,
        d.name AS doctor_name, d.specialty, d.hospital, d.fee, d.avatar_color,
        u.name AS account_name, u.email AS account_email
      FROM appointments a
      LEFT JOIN doctors d ON a.doctor_id = d.id
      LEFT JOIN users u ON a.user_id = u.id
      WHERE 1=1
    `;
    const params = [];

    if (status && status !== 'All') {
      query += ' AND a.status = ?';
      params.push(status);
    }

    if (search) {
      query += ' AND (a.patient_name LIKE ? OR d.name LIKE ? OR a.phone LIKE ? OR d.specialty LIKE ?)';
      const term = `%${search}%`;
      params.push(term, term, term, term);
    }

    query += ' ORDER BY a.id DESC';

    const [appointments] = await db.query(query, params);

    res.json({
      success: true,
      count: appointments.length,
      data: appointments,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Get single appointment by ID
// @route  GET /api/appointments/:id
const getAppointmentById = async (req, res, next) => {
  try {
    const [rows] = await db.query(
      `SELECT 
         a.*, d.name AS doctor_name, d.specialty, d.hospital, d.fee, d.avatar_color
       FROM appointments a
       JOIN doctors d ON a.doctor_id = d.id
       WHERE a.id = ?`,
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found',
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Cancel an appointment (User or Admin)
// @route  PUT /api/appointments/:id/cancel
const cancelAppointment = async (req, res, next) => {
  try {
    const [rows] = await db.query(
      'SELECT a.*, d.name AS doctor_name FROM appointments a JOIN doctors d ON a.doctor_id = d.id WHERE a.id = ?',
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found',
      });
    }

    const appt = rows[0];

    if (appt.status === 'Cancelled') {
      return res.status(400).json({
        success: false,
        message: 'Appointment is already cancelled',
      });
    }

    await db.query('UPDATE appointments SET status = "Cancelled" WHERE id = ?', [
      req.params.id,
    ]);

    // Create cancellation notification
    await db.query(
      `INSERT INTO notifications (user_id, title, message, category)
       VALUES (?, ?, ?, 'Appointments')`,
      [
        appt.user_id,
        'Appointment Cancelled',
        `Your appointment with ${appt.doctor_name} on ${appt.date} has been cancelled.`,
      ]
    );

    res.json({
      success: true,
      message: 'Appointment cancelled successfully',
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Update appointment status (Admin: Upcoming, Completed, Cancelled)
// @route  PUT /api/appointments/:id/status
const updateAppointmentStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const { id } = req.params;

    if (!['Upcoming', 'Completed', 'Cancelled'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Status must be Upcoming, Completed, or Cancelled',
      });
    }

    const [rows] = await db.query(
      'SELECT a.*, d.name AS doctor_name FROM appointments a JOIN doctors d ON a.doctor_id = d.id WHERE a.id = ?',
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found',
      });
    }

    await db.query('UPDATE appointments SET status = ? WHERE id = ?', [status, id]);

    // Notify user
    await db.query(
      `INSERT INTO notifications (user_id, title, message, category)
       VALUES (?, ?, ?, 'Appointments')`,
      [
        rows[0].user_id,
        `Appointment ${status}`,
        `Your appointment with ${rows[0].doctor_name} status has been updated to "${status}".`,
      ]
    );

    res.json({
      success: true,
      message: `Appointment status updated to ${status}`,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Delete appointment permanently (Admin)
// @route  DELETE /api/appointments/:id
const deleteAppointment = async (req, res, next) => {
  try {
    const { id } = req.params;

    const [result] = await db.query('DELETE FROM appointments WHERE id = ?', [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found',
      });
    }

    res.json({
      success: true,
      message: 'Appointment deleted successfully',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createAppointment,
  getUserAppointments,
  getAllAppointmentsAdmin,
  getAppointmentById,
  cancelAppointment,
  updateAppointmentStatus,
  deleteAppointment,
};
