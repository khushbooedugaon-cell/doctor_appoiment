// MediCare API Service
const API_BASE = (typeof window !== 'undefined' && window.location.hostname === 'localhost')
  ? 'http://localhost:5000/api'
  : '/api';

export const mockData = {
  doctors: [
    { id: 1, name: 'Dr. Ananya Sharma', specialty: 'Cardiologist', hospital: 'Apollo Hospital', rating: 4.9, experience: '12 yrs', fee: '₹800', avatar_color: '#0D9488', online: true, about: 'Senior Cardiologist specializing in preventive heart care, ECG, and non-invasive cardiovascular health.' },
    { id: 2, name: 'Dr. Rohan Mehta', specialty: 'Dentist', hospital: 'City Dental Care', rating: 4.8, experience: '8 yrs', fee: '₹500', avatar_color: '#3B82F6', online: false, about: 'Dental surgeon with expertise in painless root canal treatments and teeth alignment.' },
    { id: 3, name: 'Dr. Priya Verma', specialty: 'Neurologist', hospital: 'Max Super Speciality', rating: 4.7, experience: '10 yrs', fee: '₹900', avatar_color: '#8B5CF6', online: true, about: 'Experienced neurologist managing migraines, chronic headaches, and sleep wellness.' },
    { id: 4, name: 'Dr. Amit Singh', specialty: 'Orthopedic', hospital: 'Fortis Hospital', rating: 4.6, experience: '15 yrs', fee: '₹700', avatar_color: '#F59E0B', online: true, about: 'Orthopedic surgeon and joint specialist focusing on bone density and knee care.' },
    { id: 5, name: 'Dr. Neha Gupta', specialty: 'Dermatologist', hospital: 'Skin & Cure Clinic', rating: 4.9, experience: '9 yrs', fee: '₹600', avatar_color: '#EC4899', online: false, about: 'Cosmetic and clinical dermatologist specializing in skin allergies and clinical acne.' },
  ],
  users: [
    { id: 1, name: 'Rahul Kumar', email: 'rahul@gmail.com', phone: '+91 98765 43210', city: 'Patna', blood_group: 'O+', weight: '68 kg', height: "5'9\"", created_at: '2024-10-15', appointment_count: 2 },
    { id: 2, name: 'Sneha Singh', email: 'sneha.singh@gmail.com', phone: '+91 98112 33445', city: 'Delhi', blood_group: 'A+', weight: '54 kg', height: "5'4\"", created_at: '2024-10-20', appointment_count: 1 },
    { id: 3, name: 'Aman Verma', email: 'aman.v@outlook.com', phone: '+91 97654 32109', city: 'Mumbai', blood_group: 'B+', weight: '72 kg', height: "6'0\"", created_at: '2024-10-25', appointment_count: 1 },
    { id: 4, name: 'Pooja Sharma', email: 'pooja.s@yahoo.com', phone: '+91 99887 76655', city: 'Bangalore', blood_group: 'O-', weight: '60 kg', height: "5'5\"", created_at: '2024-11-01', appointment_count: 0 },
  ],
  appointments: [
    { id: 101, patient_name: 'Rahul Kumar', phone: '+91 98765 43210', doctor_id: 1, doctor_name: 'Dr. Ananya Sharma', specialty: 'Cardiologist', hospital: 'Apollo Hospital', fee: '₹800', type: 'In Clinic', date: 'Wed, 28 Oct', time: '04:30 PM', note: 'Mild chest tightness after exercise', status: 'Upcoming' },
    { id: 102, patient_name: 'Sneha Singh', phone: '+91 98112 33445', doctor_id: 2, doctor_name: 'Dr. Rohan Mehta', specialty: 'Dentist', hospital: 'City Dental Care', fee: '₹500', type: 'In Clinic', date: 'Thu, 29 Oct', time: '11:30 AM', note: 'Routine dental cleanup and scaling', status: 'Completed' },
    { id: 103, patient_name: 'Aman Verma', phone: '+91 97654 32109', doctor_id: 3, doctor_name: 'Dr. Priya Verma', specialty: 'Neurologist', hospital: 'Max Super Speciality', fee: '₹900', type: 'Video Call', date: 'Fri, 30 Oct', time: '01:00 PM', note: 'Persistent morning migraines', status: 'Upcoming' },
    { id: 104, patient_name: 'Vikram Patel', phone: '+91 98223 34455', doctor_id: 4, doctor_name: 'Dr. Amit Singh', specialty: 'Orthopedic', hospital: 'Fortis Hospital', fee: '₹700', type: 'In Clinic', date: 'Sat, 31 Oct', time: '10:00 AM', note: 'Left knee sprain while jogging', status: 'Cancelled' },
  ],
};

async function request(endpoint, options = {}) {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.message || 'API request failed');
    return data;
  } catch (error) {
    console.warn(`[API] Error on ${endpoint}:`, error.message);
    throw error;
  }
}

export const api = {
  // Admin Auth
  async login(email, password) {
    return request('/admin/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
  },

  // Stats
  async getStats() {
    return request('/admin/stats');
  },

  // Doctors
  async getDoctors(query = '') {
    return request(`/doctors${query ? `?search=${encodeURIComponent(query)}` : ''}`);
  },
  async createDoctor(payload) {
    return request('/doctors', {
      method: 'POST',
      body: JSON.stringify(payload),
    });
  },
  async updateDoctor(id, payload) {
    return request(`/doctors/${id}`, {
      method: 'PUT',
      body: JSON.stringify(payload),
    });
  },
  async toggleDoctorStatus(id) {
    return request(`/doctors/${id}/status`, { method: 'PATCH' });
  },
  async deleteDoctor(id) {
    return request(`/doctors/${id}`, { method: 'DELETE' });
  },

  // Patients / Users
  async getUsers(query = '') {
    return request(`/auth/users${query ? `?search=${encodeURIComponent(query)}` : ''}`);
  },
  async deleteUser(id) {
    return request(`/auth/users/${id}`, { method: 'DELETE' });
  },

  // Appointments
  async getAppointments(status = 'All', query = '') {
    let url = `/appointments/admin/all?`;
    if (status && status !== 'All') url += `status=${status}&`;
    if (query) url += `search=${encodeURIComponent(query)}&`;
    return request(url);
  },
  async createAppointment(payload) {
    return request('/appointments', {
      method: 'POST',
      body: JSON.stringify(payload),
    });
  },
  async updateAppointmentStatus(id, status) {
    return request(`/appointments/${id}/status`, {
      method: 'PUT',
      body: JSON.stringify({ status }),
    });
  },
  async deleteAppointment(id) {
    return request(`/appointments/${id}`, { method: 'DELETE' });
  },

  // Broadcast
  async sendBroadcast(payload) {
    return request('/admin/broadcast', {
      method: 'POST',
      body: JSON.stringify(payload),
    });
  },
};

