# MediCare React Admin & Management Portal 🏥

A modern, responsive React + Tailwind CSS admin portal for managing doctors, patient directories, consultations, appointments, and push notifications.

---

## 🔐 Admin Authentication

The admin panel requires authentication before accessing the dashboard:

- **Default Admin Email:** `admin@medicare.com` (or `admin`)
- **Default Password:** `admin123`
- **Auto Fill:** The login screen provides a one-click **"Auto Fill"** button for quick access during testing.
- **Session:** Admin sessions are remembered on the device; clicking **"Sign Out"** in the sidebar or navbar returns to the login screen.

---

## 🚀 Features

- **Executive Dashboard**:
  - Live metric KPI cards (Total Doctors, Active Patients, Appointments, Revenue).
  - Weekly consultation trends (Chart.js interactive line chart).
  - Specialty distribution doughnut chart.
  - Recent appointment feed with quick status badges.
  - Featured doctor specialists widget.

- **Doctors Directory**:
  - Instant search by doctor name, specialty, or hospital.
  - Specialty filter pills (Cardiologist, Dentist, Neurologist, etc.).
  - Real-time online/offline toggle switch for doctor availability.
  - Full CRUD: Add doctor, Edit doctor details (fee, experience, hospital, avatar), and Delete doctor.

- **Patients Directory**:
  - Patient search by name, email, phone, or city.
  - Health vitals badges (Blood Group, Weight, Height).
  - Total appointment count pill.
  - Remove / delete patient records.

- **Appointments Management**:
  - Filter by status (`All`, `Upcoming`, `Completed`, `Cancelled`).
  - Search by patient, doctor, phone, or consultation note.
  - Quick actions to mark appointments as **Completed** or **Cancelled**.
  - Direct appointment booking modal with doctor selector, date, and consultation type (In Clinic / Video Call).

- **Broadcast & Push Notifications**:
  - Compose push notifications with live mobile phone preview simulator.
  - Target audience selector (All patients or specific individual patient).
  - Categories: Announcements, Health Alerts, Reminders, Emergency Notices.
  - One-click templates (Health Camp, Holiday Notices, Flu Advisory).
  - History of recent broadcasts.

- **Resilient Fallback Mode**:
  - Works seamlessly with the live Node.js + MySQL backend on `http://localhost:5000`.
  - Automatic fallback to interactive mock data if the backend server is offline or being migrated.

---

## 🛠️ Tech Stack

- **React 18** + **Vite 6**
- **Tailwind CSS 3** (Custom Medical Teal palette `#0D9488`, `#0F766E`)
- **Lucide React** (Modern clean medical & UI iconography)
- **Chart.js** & **react-chartjs-2** (Interactive data visualization)
- **Context API** (Centralized state management & toast notifications)

---

## 💻 Quick Start

### 1. Development Mode (with hot-reload)
```bash
cd frontend
npm run dev
```
The app will open at: **`http://localhost:3000`**

### 2. Production Build
```bash
cd frontend
npm run build
```
The compiled files are stored in `frontend/dist/`.

### 3. Integrated Backend Access
When the Node.js backend is running (`node server.js` in `backend/`):
- React Portal is directly served at: **`http://localhost:5000/portal`**
- REST API is available at: **`http://localhost:5000/api`**

