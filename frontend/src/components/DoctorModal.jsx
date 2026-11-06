import React, { useState, useEffect } from 'react';
import { useApp } from '../context/AppContext';
import { api } from '../services/api';
import { X } from 'lucide-react';

export default function DoctorModal({ isOpen, onClose, editingDoctor }) {
  const { isOnline, setDoctors, refreshData, addToast } = useApp();

  const [formData, setFormData] = useState({
    name: '',
    specialty: '',
    hospital: '',
    fee: '800',
    experience: '10 yrs',
    rating: '4.8',
    avatar_color: '#0D9488',
    about: '',
  });

  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (editingDoctor) {
      setFormData({
        name: editingDoctor.name || '',
        specialty: editingDoctor.specialty || '',
        hospital: editingDoctor.hospital || '',
        fee: (editingDoctor.fee || '').replace(/[^\d]/g, '') || '800',
        experience: editingDoctor.experience || '10 yrs',
        rating: editingDoctor.rating || '4.8',
        avatar_color: editingDoctor.avatar_color || '#0D9488',
        about: editingDoctor.about || '',
      });
    } else {
      setFormData({
        name: '',
        specialty: '',
        hospital: '',
        fee: '800',
        experience: '10 yrs',
        rating: '4.8',
        avatar_color: '#0D9488',
        about: '',
      });
    }
  }, [editingDoctor, isOpen]);

  if (!isOpen) return null;

  async function handleSubmit(e) {
    e.preventDefault();
    setSubmitting(true);

    const payload = {
      ...formData,
      fee: `₹${formData.fee}`,
      rating: parseFloat(formData.rating) || 4.8,
      online: true,
    };

    try {
      if (isOnline) {
        if (editingDoctor) {
          await api.updateDoctor(editingDoctor.id, payload);
          addToast('Doctor profile updated successfully!', 'success');
        } else {
          await api.createDoctor(payload);
          addToast('New doctor added successfully!', 'success');
        }
        await refreshData();
      } else {
        // Local mode update
        if (editingDoctor) {
          setDoctors((prev) =>
            prev.map((d) => (d.id === editingDoctor.id ? { ...d, ...payload } : d))
          );
          addToast('Doctor updated (Local Mode)', 'success');
        } else {
          setDoctors((prev) => [{ id: Date.now(), ...payload }, ...prev]);
          addToast('Doctor added (Local Mode)', 'success');
        }
      }
      onClose();
    } catch (err) {
      addToast(err.message || 'Failed to save doctor', 'error');
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
      <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-slate-100 max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between pb-4 border-b border-slate-100">
          <h3 className="font-bold text-slate-900 text-lg">
            {editingDoctor ? 'Edit Doctor Profile' : 'Add New Healthcare Specialist'}
          </h3>
          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 p-1">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="mt-4 space-y-4">
          <div>
            <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Doctor Name</label>
            <input
              type="text"
              required
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              placeholder="Dr. Firstname Lastname"
              className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
            />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Specialty</label>
              <input
                type="text"
                required
                value={formData.specialty}
                onChange={(e) => setFormData({ ...formData, specialty: e.target.value })}
                placeholder="e.g. Cardiologist"
                className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
              />
            </div>
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Consultation Fee (₹)</label>
              <input
                type="number"
                required
                value={formData.fee}
                onChange={(e) => setFormData({ ...formData, fee: e.target.value })}
                placeholder="800"
                className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Hospital / Clinic</label>
            <input
              type="text"
              required
              value={formData.hospital}
              onChange={(e) => setFormData({ ...formData, hospital: e.target.value })}
              placeholder="e.g. Apollo Hospital"
              className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
            />
          </div>

          <div className="grid grid-cols-3 gap-3">
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Experience</label>
              <input
                type="text"
                value={formData.experience}
                onChange={(e) => setFormData({ ...formData, experience: e.target.value })}
                placeholder="10 yrs"
                className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
              />
            </div>
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Rating (1-5)</label>
              <input
                type="number"
                step="0.1"
                max="5"
                value={formData.rating}
                onChange={(e) => setFormData({ ...formData, rating: e.target.value })}
                className="w-full py-2 px-3 text-sm rounded-xl border border-slate-200 focus:border-teal-500 focus:outline-none"
              />
            </div>
            <div>
              <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Avatar Color</label>
              <input
                type="color"
                value={formData.avatar_color}
                onChange={(e) => setFormData({ ...formData, avatar_color: e.target.value })}
                className="h-9 w-full p-0.5 rounded-xl border border-slate-200 cursor-pointer"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Biography / About</label>
            <textarea
              rows="3"
              value={formData.about}
              onChange={(e) => setFormData({ ...formData, about: e.target.value })}
              placeholder="Doctor's credentials and medical background..."
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
              {submitting ? 'Saving...' : editingDoctor ? 'Update Doctor' : 'Save Doctor'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

