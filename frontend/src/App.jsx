import React, { useState } from 'react';
import { useApp } from './context/AppContext';
import Sidebar from './components/Sidebar';
import Navbar from './components/Navbar';
import Toast from './components/Toast';
import DoctorModal from './components/DoctorModal';
import AppointmentModal from './components/AppointmentModal';

import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Doctors from './pages/Doctors';
import Patients from './pages/Patients';
import Appointments from './pages/Appointments';
import Broadcast from './pages/Broadcast';

export default function App() {
  const { activeTab, adminUser } = useApp();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [doctorModalOpen, setDoctorModalOpen] = useState(false);
  const [editingDoctor, setEditingDoctor] = useState(null);
  const [appointmentModalOpen, setAppointmentModalOpen] = useState(false);

  // If not logged in as Admin, show the Login screen first
  if (!adminUser) {
    return (
      <div className="min-h-screen bg-slate-900 font-sans text-slate-100 antialiased selection:bg-teal-500 selection:text-white">
        <Login />
        <Toast />
      </div>
    );
  }

  const handleOpenDoctorModal = (doctor = null) => {
    setEditingDoctor(doctor);
    setDoctorModalOpen(true);
  };

  const handleCloseDoctorModal = () => {
    setDoctorModalOpen(false);
    setEditingDoctor(null);
  };

  const handleOpenAppointmentModal = () => {
    setAppointmentModalOpen(true);
  };

  const handleCloseAppointmentModal = () => {
    setAppointmentModalOpen(false);
  };

  const renderActiveTab = () => {
    switch (activeTab) {
      case 'dashboard':
        return (
          <Dashboard
            onOpenDoctorModal={() => handleOpenDoctorModal()}
            onOpenAppointmentModal={handleOpenAppointmentModal}
          />
        );
      case 'doctors':
        return <Doctors onOpenDoctorModal={handleOpenDoctorModal} />;
      case 'users':
      case 'patients':
        return <Patients />;
      case 'appointments':
        return <Appointments onOpenAppointmentModal={handleOpenAppointmentModal} />;
      case 'broadcast':
        return <Broadcast />;
      default:
        return (
          <Dashboard
            onOpenDoctorModal={() => handleOpenDoctorModal()}
            onOpenAppointmentModal={handleOpenAppointmentModal}
          />
        );
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 flex font-sans text-slate-800 antialiased selection:bg-teal-500 selection:text-white">
      {/* Sidebar Navigation */}
      <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0">
        <Navbar
          onMenuClick={() => setSidebarOpen(true)}
          onOpenDoctorModal={() => handleOpenDoctorModal()}
          onOpenAppointmentModal={handleOpenAppointmentModal}
        />

        <main className="flex-1 p-4 sm:p-6 lg:p-8 max-w-7xl w-full mx-auto">
          {renderActiveTab()}
        </main>
      </div>

      {/* Global Modals */}
      <DoctorModal
        isOpen={doctorModalOpen}
        onClose={handleCloseDoctorModal}
        editingDoctor={editingDoctor}
      />
      <AppointmentModal
        isOpen={appointmentModalOpen}
        onClose={handleCloseAppointmentModal}
      />

      {/* Floating Notifications */}
      <Toast />
    </div>
  );
}
