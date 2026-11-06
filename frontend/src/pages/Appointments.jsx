import React, { useState } from 'react';
import {
  Calendar,
  Search,
  Plus,
  Clock,
  Video,
  Building2,
  Check,
  X,
  Trash2,
  FileText,
  Filter,
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { api } from '../services/api';

export default function Appointments({ onOpenAppointmentModal }) {
  const { appointments, setAppointments, addToast } = useApp();
  const [selectedStatus, setSelectedStatus] = useState('All');
  const [searchTerm, setSearchTerm] = useState('');

  const statuses = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  const filteredAppointments = appointments.filter((appt) => {
    const matchesStatus =
      selectedStatus === 'All' || appt.status.toLowerCase() === selectedStatus.toLowerCase();

    const term = searchTerm.toLowerCase();
    const matchesSearch =
      appt.patient_name?.toLowerCase().includes(term) ||
      appt.doctor_name?.toLowerCase().includes(term) ||
      appt.phone?.toLowerCase().includes(term) ||
      appt.specialty?.toLowerCase().includes(term);

    return matchesStatus && matchesSearch;
  });

  const handleUpdateStatus = async (id, newStatus) => {
    setAppointments((prev) =>
      prev.map((a) => (a.id === id ? { ...a, status: newStatus } : a))
    );

    try {
      await api.updateAppointmentStatus(id, newStatus);
      addToast(`Appointment updated to ${newStatus}`, 'success');
    } catch {
      addToast(`Status updated to ${newStatus} locally`, 'info');
    }
  };

  const handleDeleteAppointment = async (id) => {
    if (!window.confirm('Delete this appointment record?')) return;

    setAppointments((prev) => prev.filter((a) => a.id !== id));
    try {
      await api.deleteAppointment(id);
      addToast('Appointment deleted', 'success');
    } catch {
      addToast('Appointment deleted locally', 'info');
    }
  };

  const getStatusBadge = (status) => {
    switch (status) {
      case 'Upcoming':
        return 'bg-emerald-50 text-emerald-700 border-emerald-200';
      case 'Completed':
        return 'bg-blue-50 text-blue-700 border-blue-200';
      case 'Cancelled':
        return 'bg-rose-50 text-rose-700 border-rose-200';
      default:
        return 'bg-gray-50 text-gray-700 border-gray-200';
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-800">Appointments Management</h1>
          <p className="text-sm text-gray-500">
            Track patient bookings, schedule timings, and consultation statuses.
          </p>
        </div>
        <button
          onClick={() => onOpenAppointmentModal()}
          className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-teal-600 hover:bg-teal-700 text-white font-semibold text-sm shadow-sm transition active:scale-95"
        >
          <Plus className="w-4 h-4" />
          Book Appointment
        </button>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white rounded-2xl p-4 border border-gray-100 shadow-sm space-y-3.5">
        <div className="flex flex-col sm:flex-row items-center gap-3">
          <div className="relative flex-1 w-full">
            <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Search by patient name, phone, doctor or specialty..."
              className="w-full pl-10 pr-4 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-teal-500/20 focus:border-teal-500 transition"
            />
          </div>
          <span className="text-xs font-semibold text-gray-500 whitespace-nowrap">
            {filteredAppointments.length} bookings found
          </span>
        </div>

        {/* Status filters */}
        <div className="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-none">
          <Filter className="w-4 h-4 text-gray-400 flex-shrink-0" />
          {statuses.map((st) => (
            <button
              key={st}
              onClick={() => setSelectedStatus(st)}
              className={`px-3.5 py-1.5 rounded-xl text-xs font-semibold transition whitespace-nowrap ${
                selectedStatus === st
                  ? 'bg-teal-600 text-white shadow-sm'
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200/80'
              }`}
            >
              {st}
            </button>
          ))}
        </div>
      </div>

      {/* Appointments Table */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        {filteredAppointments.length === 0 ? (
          <div className="p-12 text-center">
            <div className="w-14 h-14 bg-teal-50 text-teal-600 rounded-2xl flex items-center justify-center mx-auto mb-3">
              <Calendar className="w-7 h-7" />
            </div>
            <h3 className="text-base font-bold text-gray-800">No appointments found</h3>
            <p className="text-xs text-gray-500 mt-1 max-w-sm mx-auto">
              No consultations match your filter criteria. Book a new appointment or change filters.
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="text-xs uppercase text-gray-400 bg-gray-50/80 border-b border-gray-100">
                <tr>
                  <th className="py-3.5 px-5 font-semibold">Patient</th>
                  <th className="py-3.5 px-4 font-semibold">Doctor & Specialty</th>
                  <th className="py-3.5 px-4 font-semibold">Schedule & Type</th>
                  <th className="py-3.5 px-4 font-semibold">Fee</th>
                  <th className="py-3.5 px-4 font-semibold">Status</th>
                  <th className="py-3.5 px-5 font-semibold text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredAppointments.map((appt) => (
                  <tr key={appt.id} className="hover:bg-gray-50/70 transition">
                    {/* Patient */}
                    <td className="py-4 px-5">
                      <div className="font-semibold text-gray-800">{appt.patient_name}</div>
                      <div className="text-xs text-gray-400">{appt.phone}</div>
                      {appt.note && (
                        <div className="flex items-center gap-1 mt-1 text-[11px] text-gray-500 italic max-w-xs truncate">
                          <FileText className="w-3 h-3 flex-shrink-0 text-gray-400" />
                          <span>"{appt.note}"</span>
                        </div>
                      )}
                    </td>

                    {/* Doctor */}
                    <td className="py-4 px-4">
                      <div className="font-semibold text-gray-800">{appt.doctor_name}</div>
                      <div className="text-xs text-teal-600 font-medium">{appt.specialty}</div>
                      {appt.hospital && (
                        <div className="flex items-center gap-1 text-[11px] text-gray-400 mt-0.5">
                          <Building2 className="w-3 h-3" />
                          <span>{appt.hospital}</span>
                        </div>
                      )}
                    </td>

                    {/* Schedule */}
                    <td className="py-4 px-4 text-xs text-gray-700 space-y-1">
                      <div className="flex items-center gap-1.5 font-semibold text-gray-800">
                        <Clock className="w-3.5 h-3.5 text-teal-600" />
                        <span>{appt.date} • {appt.time}</span>
                      </div>
                      <div className="flex items-center gap-1.5 text-gray-500">
                        {appt.type === 'Video Call' ? (
                          <Video className="w-3.5 h-3.5 text-blue-500" />
                        ) : (
                          <Building2 className="w-3.5 h-3.5 text-emerald-500" />
                        )}
                        <span>{appt.type || 'In Clinic'}</span>
                      </div>
                    </td>

                    {/* Fee */}
                    <td className="py-4 px-4">
                      <span className="font-bold text-teal-700 text-sm">
                        {appt.fee || '₹500'}
                      </span>
                    </td>

                    {/* Status */}
                    <td className="py-4 px-4">
                      <span
                        className={`inline-flex px-2.5 py-1 text-xs font-semibold rounded-full border ${getStatusBadge(
                          appt.status
                        )}`}
                      >
                        {appt.status}
                      </span>
                    </td>

                    {/* Action buttons */}
                    <td className="py-4 px-5 text-right">
                      <div className="inline-flex items-center gap-1">
                        {appt.status !== 'Completed' && (
                          <button
                            onClick={() => handleUpdateStatus(appt.id, 'Completed')}
                            className="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg transition"
                            title="Mark as Completed"
                          >
                            <Check className="w-4 h-4" />
                          </button>
                        )}
                        {appt.status !== 'Cancelled' && (
                          <button
                            onClick={() => handleUpdateStatus(appt.id, 'Cancelled')}
                            className="p-1.5 text-amber-600 hover:bg-amber-50 rounded-lg transition"
                            title="Mark as Cancelled"
                          >
                            <X className="w-4 h-4" />
                          </button>
                        )}
                        <button
                          onClick={() => handleDeleteAppointment(appt.id)}
                          className="p-1.5 text-gray-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition"
                          title="Delete Record"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

