# 🏥 MediCare - Node.js, MySQL Backend & Admin Portal

Complete Backend REST API, Real-Time Socket.IO messaging server, and **Web Admin Dashboard Panel** for the **MediCare Doctor Appointment Booking** platform.

---

## 🛠️ Tech Stack
* **Backend:** Node.js (v18+) with Express.js
* **Database:** MySQL 8.0 / MariaDB with `mysql2` connection pooling
* **Real-time Messaging:** Socket.IO
* **Admin Frontend:** Modern Single Page App (Tailwind CSS, FontAwesome 6, Chart.js, HTML5, Vanilla ES6+)
* **Authentication:** JWT (JSON Web Tokens) & bcryptjs

---

## 📁 Project Structure
```
doctor_appoinment/
├── admin/                         # 💻 Web Admin Portal Frontend
│   ├── index.html                 # Admin Dashboard UI
│   ├── style.css                  # Custom styling & animations
│   └── app.js                     # State management, API sync & charts
├── backend/                       # ⚙️ Node.js + Express Backend
│   ├── config/
│   │   └── db.js                  # MySQL connection pool
│   ├── controllers/
│   │   ├── adminController.js     # Dashboard metrics & broadcasts
│   │   ├── authController.js      # Auth & patient user management
│   │   ├── doctorController.js    # Doctor CRUD & online toggling
│   │   ├── appointmentController.js # Appointment scheduling & status
│   │   ├── chatController.js      # Chat history & conversations
│   │   └── notificationController.js # In-app patient notifications
│   ├── middleware/
│   │   ├── authMiddleware.js      # JWT token guard
│   │   └── errorMiddleware.js     # 404 & error handlers
│   ├── models/
│   │   └── schema.sql             # MySQL schema & seed data
│   ├── routes/
│   │   ├── adminRoutes.js         # /api/admin/*
│   │   ├── authRoutes.js          # /api/auth/*
│   │   ├── doctorRoutes.js        # /api/doctors/*
│   │   ├── appointmentRoutes.js   # /api/appointments/*
│   │   ├── chatRoutes.js          # /api/chat/*
│   │   └── notificationRoutes.js  # /api/notifications/*
│   ├── scripts/
│   │   └── initDb.js              # One-command DB init & migration
│   ├── sockets/
│   │   └── chatSocket.js          # Live doctor-patient chat
│   ├── .env                       # Local DB & JWT config
│   ├── package.json
│   └── server.js                  # Main server & static admin serve
└── lib/                           # 📱 Flutter Mobile Application
```

---

## 🚀 Quick Start Guide

### 1. Configure MySQL Database
Check `backend/.env` file with your MySQL credentials:
```env
PORT=5000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=medicare_db
```

### 2. Initialize Database & Seed Tables (One-Time)
Make sure your MySQL service / XAMPP is running, then run:
```bash
cd backend
npm run db:init
```

### 3. Start Backend Server & Admin Panel
```bash
cd backend
npm run dev
```

* **API Server:** `http://localhost:5000`
* **Admin Portal UI:** `http://localhost:5000/admin` *(or open `admin/index.html` in browser)*

---

## 💻 Admin Panel Features (`/admin`)

1. **Executive Dashboard**:
   * **Key Metrics:** Total Doctors, Active Online Doctors, Total Patients, Appointments Count, and Total Consultation Fees.
   * **Visual Charts (Chart.js):**
     * Monthly Appointment Trends (Interactive Line Chart)
     * Department / Specialty Distribution (Doughnut Chart)
   * **Live Consultations Feed:** Recent appointments table with instant `Complete (✓)` or `Cancel (✕)` actions.
   * **Top Specialists Widget:** Rating leaderboard.

2. **Doctors Management (`/doctors`)**:
   * Search by name, specialty, or hospital.
   * Filter by Department (Cardiology, Dentist, Neurology, Orthopedic, etc.).
   * Doctor Cards with rating, fee, hospital, and experience.
   * **Real-time Online/Offline toggle switch**.
   * **Add New Doctor Modal & Edit Doctor Modal**.
   * Delete Doctor with confirmation.

3. **Patients & Users (`/users`)**:
   * Search patients by name, email, phone number, city.
   * View patient vitals (Blood group, weight, height).
   * Total appointment booking count badge per patient.
   * Direct 1-click notification sender to individual patients.
   * Delete user records.

4. **Appointments Management (`/appointments`)**:
   * Status filter pills: `All`, `Upcoming`, `Completed`, `Cancelled`.
   * Search by patient name or doctor.
   * Quick status change (`Upcoming` ➔ `Completed` / `Cancelled`).
   * **Schedule New Appointment Modal** (Admin manual booking).
   * Delete appointment records.

5. **Broadcast & Notification Center (`/broadcast`)**:
   * Send alerts to **All Patients (Global)** or a **Specific Patient**.
   * Notification categories: General Alert, Appointment Update, Consultation Message.

---

## 📡 Complete REST API Reference

### Admin (`/api/admin`)
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/admin/stats` | Dashboard counts, charts data & recent bookings |
| `POST` | `/api/admin/broadcast` | Send global or single-patient notification |

### Doctors (`/api/doctors`)
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/doctors` | List doctors (with `?search=`, `?specialty=`, `?online=`) |
| `GET` | `/api/doctors/specialties/list` | Distinct medical departments |
| `GET` | `/api/doctors/:id` | Single doctor details |
| `POST` | `/api/doctors` | Create new doctor |
| `PUT` | `/api/doctors/:id` | Update doctor profile |
| `PATCH` | `/api/doctors/:id/status` | Toggle online/offline status |
| `DELETE` | `/api/doctors/:id` | Delete doctor record |

### Patients & Auth (`/api/auth`)
| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/auth/register` | Patient registration |
| `POST` | `/api/auth/login` | Patient login (returns JWT) |
| `GET` | `/api/auth/profile` | Logged-in profile |
| `PUT` | `/api/auth/profile` | Update profile vitals |
| `GET` | `/api/auth/users` | List all registered patients (Admin) |
| `DELETE` | `/api/auth/users/:id` | Delete patient record (Admin) |

### Appointments (`/api/appointments`)
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/appointments/admin/all` | All bookings with doctor & patient details |
| `POST` | `/api/appointments` | Book new appointment |
| `GET` | `/api/appointments` | User appointments (supports `?status=`) |
| `GET` | `/api/appointments/:id` | Booking details |
| `PUT` | `/api/appointments/:id/status` | Update status (`Upcoming`, `Completed`, `Cancelled`) |
| `PUT` | `/api/appointments/:id/cancel` | Cancel booking |
| `DELETE` | `/api/appointments/:id` | Delete booking record |
