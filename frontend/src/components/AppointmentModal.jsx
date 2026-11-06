import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { api } from '../services/api';
import { X } from 'lucide-react';

export default function AppointmentModal({ isOpen, onClose }) {
  const { doctors, isOnline, setAppointments, refreshData, addToast } = useApp();

  const [formData, setFormData] = useState({
    patient_name: '',
    phone: '',
    doctor_id: doctors[0]?.id || '1',
    type: 'In Clinic',
    date: 'Today, 04:30 PM',
    time: '04:30 PM',
    note: '',
  });

  const [submitting, setSubmitting] = useState(false);

  if (!isOpen) return null;

  async function handleSubmit(e) {
    e.preventDefault();
    setSubmitting(true);

    const doc = doctors.find((d) => d.id == formData.doctor_id);

    const payload = {
      ...formData,
      doctor_name: doc?.name || 'Specialist',
      specialty: doc?.specialty || 'General',
      hospital: doc?.hospital || 'Hospital',
      fee: doc?.fee || '₹500',
      user_id: 1,
    };

    try {
      if (isOnline) {
        await api.createAppointment(payload);
        addToast('Appointment scheduled successfully!', 'success');
        await refreshData();
      } else {
        setAppointments((prev) => [
          {
            id: Date.now() % 10000,
            ...payload,
            status: 'Upcoming',
          },
          ...prev,
        ]);
        addToast('Appointment scheduled (Local Mode)', 'success');
      }
      onClose();
    } catch (err) {
      addToast(err.message || 'Failed to schedule appointment', 'error');
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
      <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-slate-100 max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between pb-4 border-b border-slate-100">
          <h3 className="font-bold text-slate-900 text-lg">Schedule New Appointment</h3>
          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 p-1">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="mt-4 space-y-4">
          <div>
            <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Patient Name</label>
            <input
              type="text"
              required
              value={formData.patient_name}
              onChange={(e) => setFormData({ ...formData, patient_name: e.target.value })}
              placeholder="Full Name"
              className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Phone Number</label>
            <input
              type="tel"
              required
              value={formData.phone}
              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              placeholder="+91 98765 43210"
              className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Select Doctor</label>
            <select
              value={formData.doctor_id}
              onChange={(e) => setFormData({ ...formData, doctor_id: e.target.value })}
              className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 bg-white"
            >
              {doctors.map((d) => (
                <option key={d.id} value={d.id}>
                  {d.name} ({d.specialty} • {d.fee})
                </option>
              ))}
            </select>
          </div>

          <div className="grid grid-cols-3 gap-3">
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Mode</label>
              <select
                value={formData.type}
                onChange={(e) => setFormData({ ...formData, type: e.target.value })}
                className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 bg-white"
              >
                <option value="In Clinic">In Clinic</option>
                <option value="Video Call">Video Call</option>
              </select>
            </div>
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Date</label>
              <input
                type="text"
                required
                value={formData.date}
                onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                placeholder="e.g. Wed, 28 Oct"
                className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
              />
            </div>
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Time Slot</label>
              <input
                type="text"
                required
                value={formData.time}
                onChange={(e) => setFormData({ ...formData, time: e.target.value })}
                placeholder="e.g. 10:00 AM"
                className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Medical Symptoms / Note</label>
            <textarea
              rows="2"
              value={formData.note}
              onChange={(e) => setFormData({ ...formData, note: e.target.value })}
              placeholder="Brief note about the condition..."
              className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
            />
          </div>

          <div className="pt-2 flex items-center justify-end space-x-2">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={submitting}
              className="px-5 py-2 text-xs font-bold bg-teal-600 text-white hover:bg-teal-700 rounded-xl shadow-sm disabled:opacity-50"
            >
              {submitting ? 'Booking...' : 'Confirm Booking'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

