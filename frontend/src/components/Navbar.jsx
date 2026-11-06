import React from 'react';
import { useApp } from '../context/AppContext';
import { Menu, Plus, CalendarPlus, RefreshCw, LogOut } from 'lucide-react';

export default function Navbar({ onMenuClick, onOpenDoctorModal, onOpenAppointmentModal }) {
  const { activeTab, isOnline, loading, refreshData, adminUser, logout } = useApp();

  const titles = {
    dashboard: { title: 'Executive Dashboard', subtitle: 'Hospital overview & consultation metrics' },
    doctors: { title: 'Doctors Directory', subtitle: 'Manage medical specialists & availability' },
    users: { title: 'Patients & Users', subtitle: 'Registered patient directory & health vitals' },
    patients: { title: 'Patients & Users', subtitle: 'Registered patient directory & health vitals' },
    appointments: { title: 'Appointments Schedule', subtitle: 'Manage in-clinic & video consultations' },
    broadcast: { title: 'Broadcast Alerts', subtitle: 'Send in-app notifications to patients' },
  };

  const current = titles[activeTab] || titles.dashboard;

  return (
    <header className="h-20 bg-white border-b border-slate-200/80 px-4 sm:px-6 flex items-center justify-between sticky top-0 z-30 shadow-sm/50">
      <div className="flex items-center space-x-3 sm:space-x-4">
        <button 
          onClick={onMenuClick}
          className="md:hidden p-2 text-slate-600 hover:bg-slate-100 rounded-xl"
        >
          <Menu className="w-5 h-5" />
        </button>
        <div>
          <h2 className="text-base sm:text-xl font-bold text-slate-900 tracking-tight">{current.title}</h2>
          <p className="text-xs text-slate-400 hidden sm:block">{current.subtitle}</p>
        </div>
      </div>

      <div className="flex items-center space-x-2 sm:space-x-3">
        {/* Status Pill */}
        <div className={`
          hidden sm:flex items-center text-xs font-semibold px-2.5 py-1 rounded-full border
          ${isOnline 
            ? 'bg-emerald-50 text-emerald-700 border-emerald-200' 
            : 'bg-amber-50 text-amber-700 border-amber-200'}
        `}>
          <span className={`h-2 w-2 rounded-full mr-2 ${isOnline ? 'bg-emerald-500 animate-pulse' : 'bg-amber-500'}`} />
          {isOnline ? 'MySQL Live' : 'Demo Mode'}
        </div>

        {/* Refresh Button */}
        <button
          onClick={refreshData}
          disabled={loading}
          title="Refresh Data"
          className="p-2 text-slate-500 hover:text-teal-600 hover:bg-slate-100 rounded-xl transition-colors"
        >
          <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin text-teal-600' : ''}`} />
        </button>

        {/* Action Buttons */}
        <button 
          onClick={onOpenDoctorModal}
          className="hidden md:inline-flex items-center space-x-1.5 px-3 py-2 rounded-xl text-xs font-bold bg-teal-50 text-teal-700 hover:bg-teal-100 border border-teal-200 transition-colors"
        >
          <Plus className="w-4 h-4" />
          <span>Add Doctor</span>
        </button>

        <button 
          onClick={onOpenAppointmentModal}
          className="inline-flex items-center space-x-1.5 px-3 py-2 rounded-xl text-xs font-bold bg-gradient-to-r from-teal-700 to-teal-500 text-white hover:opacity-95 shadow-md shadow-teal-700/20 transition-all"
        >
          <CalendarPlus className="w-4 h-4" />
          <span className="hidden sm:inline">Book Appointment</span>
        </button>

        {/* Logout */}
        <button
          onClick={logout}
          title="Sign Out"
          className="p-2 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-xl transition-colors"
        >
          <LogOut className="w-4 h-4" />
        </button>
      </div>
    </header>
  );
}
