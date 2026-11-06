const db = require('../config/db');

// @desc   Get all doctors with optional search and specialty filtering
// @route  GET /api/doctors
const getAllDoctors = async (req, res, next) => {
  try {
    const { search, specialty, online } = req.query;
    let query = 'SELECT * FROM doctors WHERE 1=1';
    const params = [];

    if (search) {
      query += ' AND (name LIKE ? OR specialty LIKE ? OR hospital LIKE ?)';
      const term = `%${search}%`;
      params.push(term, term, term);
    }

    if (specialty) {
      query += ' AND specialty = ?';
      params.push(specialty);
    }

    if (online !== undefined && online !== '') {
      query += ' AND online = ?';
      params.push(online === 'true' || online === '1' || online === 1);
    }

    query += ' ORDER BY id DESC';

    const [doctors] = await db.query(query, params);

    res.json({
      success: true,
      count: doctors.length,
      data: doctors,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Get single doctor by ID
// @route  GET /api/doctors/:id
const getDoctorById = async (req, res, next) => {
  try {
    const [rows] = await db.query('SELECT * FROM doctors WHERE id = ?', [req.params.id]);

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found',
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

// @desc   Get list of distinct specialties
// @route  GET /api/doctors/specialties/list
const getSpecialties = async (req, res, next) => {
  try {
    const [rows] = await db.query(
      'SELECT DISTINCT specialty FROM doctors ORDER BY specialty ASC'
    );

    res.json({
      success: true,
      data: rows.map((r) => r.specialty),
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Create new doctor (Admin)
// @route  POST /api/doctors
const createDoctor = async (req, res, next) => {
  try {
    const {
      name,
      specialty,
      hospital,
      rating = 4.8,
      experience = '5 yrs',
      fee = '₹500',
      avatar_color = '#0D9488',
      online = true,
      about = '',
    } = req.body;

    if (!name || !specialty || !hospital) {
      return res.status(400).json({
        success: false,
        message: 'Name, specialty, and hospital are required fields',
      });
    }

    const [result] = await db.query(
      `INSERT INTO doctors 
       (name, specialty, hospital, rating, experience, fee, avatar_color, online, about)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name,
        specialty,
        hospital,
        Number(rating) || 4.8,
        experience,
        fee.startsWith('₹') ? fee : `₹${fee}`,
        avatar_color,
        online ? 1 : 0,
        about,
      ]
    );

    const [newDoc] = await db.query('SELECT * FROM doctors WHERE id = ?', [result.insertId]);

    res.status(201).json({
      success: true,
      message: 'Doctor created successfully',
      data: newDoc[0],
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Update doctor details (Admin)
// @route  PUT /api/doctors/:id
const updateDoctor = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name, specialty, hospital, rating, experience, fee, avatar_color, online, about } =
      req.body;

    const [existing] = await db.query('SELECT id FROM doctors WHERE id = ?', [id]);
    if (existing.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found',
      });
    }

    await db.query(
      `UPDATE doctors 
       SET name = COALESCE(?, name),
           specialty = COALESCE(?, specialty),
           hospital = COALESCE(?, hospital),
           rating = COALESCE(?, rating),
           experience = COALESCE(?, experience),
           fee = COALESCE(?, fee),
           avatar_color = COALESCE(?, avatar_color),
           online = COALESCE(?, online),
           about = COALESCE(?, about)
       WHERE id = ?`,
      [
        name,
        specialty,
        hospital,
        rating !== undefined ? Number(rating) : null,
        experience,
        fee !== undefined ? (fee.startsWith('₹') ? fee : `₹${fee}`) : null,
        avatar_color,
        online !== undefined ? (online ? 1 : 0) : null,
        about,
        id,
      ]
    );

    const [updated] = await db.query('SELECT * FROM doctors WHERE id = ?', [id]);

    res.json({
      success: true,
      message: 'Doctor updated successfully',
      data: updated[0],
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Toggle doctor online/offline status (Admin)
// @route  PATCH /api/doctors/:id/status
const toggleDoctorStatus = async (req, res, next) => {
  try {
    const { id } = req.params;

    const [existing] = await db.query('SELECT online FROM doctors WHERE id = ?', [id]);
    if (existing.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found',
      });
    }

    const newStatus = !existing[0].online;
    await db.query('UPDATE doctors SET online = ? WHERE id = ?', [newStatus ? 1 : 0, id]);

    res.json({
      success: true,
      message: `Doctor status updated to ${newStatus ? 'Online' : 'Offline'}`,
      online: newStatus,
    });
  } catch (error) {
    next(error);
  }
};

// @desc   Delete doctor (Admin)
// @route  DELETE /api/doctors/:id
const deleteDoctor = async (req, res, next) => {
  try {
    const { id } = req.params;

    const [result] = await db.query('DELETE FROM doctors WHERE id = ?', [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found',
      });
    }

    res.json({
      success: true,
      message: 'Doctor deleted successfully',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllDoctors,
  getDoctorById,
  getSpecialties,
  createDoctor,
  updateDoctor,
  toggleDoctorStatus,
  deleteDoctor,
};
