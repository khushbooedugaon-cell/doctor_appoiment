const express = require('express');
const router = express.Router();
const {
  getAllDoctors,
  getDoctorById,
  getSpecialties,
  createDoctor,
  updateDoctor,
  toggleDoctorStatus,
  deleteDoctor,
} = require('../controllers/doctorController');

router.get('/', getAllDoctors);
router.post('/', createDoctor);
router.get('/specialties/list', getSpecialties);
router.get('/:id', getDoctorById);
router.put('/:id', updateDoctor);
router.patch('/:id/status', toggleDoctorStatus);
router.delete('/:id', deleteDoctor);

module.exports = router;
