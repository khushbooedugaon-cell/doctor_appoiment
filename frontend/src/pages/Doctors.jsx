import React, { useState } from 'react';
import {
  Search,
  Plus,
  Star,
  Building,
  Briefcase,
  DollarSign,
  Edit2,
  Trash2,
  CheckCircle2,
  XCircle,
  Stethoscope,
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { api } from '../services/api';

export default function Doctors({ onOpenDoctorModal }) {
  const { doctors, setDoctors, addToast } = useApp();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedSpecialty, setSelectedSpecialty] = useState('All');

  // Specialties
  const specialties = [
    'All',
    'Cardiologist',
    'Dentist',
    'Neurologist',
    'Orthopedic',
    'Dermatologist',
    'General Physician',
    'Pediatrician',
  ];

  // Filtered doctors
  const filteredDoctors = doctors.filter((doc) => {
    const matchesSearch =
      doc.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      doc.specialty.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (doc.hospital && doc.hospital.toLowerCase().includes(searchTerm.toLowerCase()));

    const matchesSpecialty =
      selectedSpecialty === 'All' ||
      doc.specialty.toLowerCase() === selectedSpecialty.toLowerCase();

    return matchesSearch && matchesSpecialty;
  });

  // Toggle online status
  const handleToggleOnline = async (id, currentStatus) => {
    // Optimistic UI update
    setDoctors((prev) =>
      prev.map((doc) => (doc.id === id ? { ...doc, online: !currentStatus } : doc))
    );

    try {
      await api.toggleDoctorStatus(id);
      addToast(
        `Doctor is now ${!currentStatus ? 'Online' : 'Offline'}`,
        'success'
      );
    } catch {
      addToast('Status updated locally (Backend offline fallback)', 'info');
    }
  };

  // Delete doctor
  const handleDeleteDoctor = async (id, name) => {
    if (!window.confirm(`Are you sure you want to remove ${name}?`)) return;

    setDoctors((prev) => prev.filter((d) => d.id !== id));
    try {
      await api.deleteDoctor(id);
      addToast(`${name} removed successfully`, 'success');
    } catch {
      addToast(`${name} removed locally`, 'info');
    }
  };

  return (
    <div className="space-y-6">
      {/* Header bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-800">Doctors Directory</h1>
          <p className="text-sm text-gray-500">
            Manage medical specialists, consultation fees, and online availability.
          </p>
        </div>
        <button
          onClick={() => onOpenDoctorModal()}
          className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-teal-600 hover:bg-teal-700 text-white font-semibold text-sm shadow-sm transition active:scale-95"
        >
          <Plus className="w-4 h-4" />
          Add New Doctor
        </button>
      </div>

      {/* Filter and Search controls */}
      <div className="bg-white rounded-2xl p-4 border border-gray-100 shadow-sm space-y-3.5">
        <div className="flex flex-col sm:flex-row items-center gap-3">
          <div className="relative flex-1 w-full">
            <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Search by doctor name, specialty, or hospital..."
              className="w-full pl-10 pr-4 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-teal-500/20 focus:border-teal-500 transition"
            />
          </div>
          <span className="text-xs font-semibold text-gray-500 whitespace-nowrap">
            {filteredDoctors.length} {filteredDoctors.length === 1 ? 'doctor' : 'doctors'} found
          </span>
        </div>

        {/* Specialty filter pills */}
        <div className="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-none">
          {specialties.map((spec) => (
            <button
              key={spec}
              onClick={() => setSelectedSpecialty(spec)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold transition whitespace-nowrap ${
                selectedSpecialty === spec
                  ? 'bg-teal-600 text-white shadow-sm'
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200/80'
              }`}
            >
              {spec}
            </button>
          ))}
        </div>
      </div>

      {/* Doctors Grid */}
      {filteredDoctors.length === 0 ? (
        <div className="bg-white rounded-2xl p-12 text-center border border-gray-100 shadow-sm">
          <div className="w-14 h-14 bg-teal-50 text-teal-600 rounded-2xl flex items-center justify-center mx-auto mb-3">
            <Stethoscope className="w-7 h-7" />
          </div>
          <h3 className="text-base font-bold text-gray-800">No doctors found</h3>
          <p className="text-xs text-gray-500 mt-1 max-w-sm mx-auto">
            Try adjusting your search query or specialty filter, or add a new doctor.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
          {filteredDoctors.map((doc) => (
            <div
              key={doc.id}
              className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm hover:shadow-md transition flex flex-col justify-between"
            >
              <div>
                {/* Top card row: Avatar, Info, Online status */}
                <div className="flex items-start justify-between gap-3 mb-4">
                  <div className="flex items-center gap-3">
                    <div
                      className="w-12 h-12 rounded-2xl flex items-center justify-center font-bold text-white text-base shadow-sm flex-shrink-0"
                      style={{ backgroundColor: doc.avatar_color || '#0D9488' }}
                    >
                      {doc.name.replace('Dr. ', '').charAt(0)}
                    </div>
                    <div>
                      <h3 className="font-bold text-gray-800 text-base leading-tight">
                        {doc.name}
                      </h3>
                      <span className="inline-block mt-0.5 text-xs font-semibold text-teal-600 bg-teal-50 px-2 py-0.5 rounded-md">
                        {doc.specialty}
                      </span>
                    </div>
                  </div>

                  {/* Online switch badge */}
                  <button
                    onClick={() => handleToggleOnline(doc.id, doc.online)}
                    title={`Click to toggle ${doc.online ? 'Offline' : 'Online'}`}
                    className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold transition border ${
                      doc.online
                        ? 'bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-100'
                        : 'bg-gray-100 text-gray-500 border-gray-200 hover:bg-gray-200'
                    }`}
                  >
                    <span
                      className={`w-2 h-2 rounded-full ${
                        doc.online ? 'bg-emerald-500 animate-pulse' : 'bg-gray-400'
                      }`}
                    />
                    {doc.online ? 'Online' : 'Offline'}
                  </button>
                </div>

                {/* About description if present */}
                {doc.about && (
                  <p className="text-xs text-gray-500 mb-4 line-clamp-2 leading-relaxed">
                    {doc.about}
                  </p>
                )}

                {/* Details list */}
                <div className="space-y-2 py-3 border-y border-gray-50 text-xs text-gray-600">
                  <div className="flex items-center justify-between">
                    <span className="flex items-center gap-1.5 text-gray-400">
                      <Building className="w-3.5 h-3.5" /> Hospital:
                    </span>
                    <span className="font-medium text-gray-800">{doc.hospital || 'MediCare Central'}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="flex items-center gap-1.5 text-gray-400">
                      <Briefcase className="w-3.5 h-3.5" /> Experience:
                    </span>
                    <span className="font-medium text-gray-800">{doc.experience || '5+ yrs'}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="flex items-center gap-1.5 text-gray-400">
                      <DollarSign className="w-3.5 h-3.5" /> Consultation Fee:
                    </span>
                    <span className="font-bold text-teal-700">{doc.fee || '₹500'}</span>
                  </div>
                </div>
              </div>

              {/* Bottom footer: Rating & Edit/Delete actions */}
              <div className="mt-4 pt-2 flex items-center justify-between">
                <div className="flex items-center gap-1 text-xs font-bold text-amber-600 bg-amber-50 px-2.5 py-1 rounded-lg">
                  <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                  <span>{doc.rating || '4.8'}</span>
                  <span className="text-gray-400 font-normal">/ 5.0</span>
                </div>

                <div className="flex items-center gap-1.5">
                  <button
                    onClick={() => onOpenDoctorModal(doc)}
                    className="p-2 text-gray-500 hover:text-teal-700 hover:bg-teal-50 rounded-lg transition"
                    title="Edit Doctor"
                  >
                    <Edit2 className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => handleDeleteDoctor(doc.id, doc.name)}
                    className="p-2 text-gray-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition"
                    title="Delete Doctor"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

