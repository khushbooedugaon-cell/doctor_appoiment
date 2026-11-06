import React, { useState } from 'react';
import {
  Search,
  User,
  Mail,
  Phone,
  MapPin,
  HeartPulse,
  Calendar,
  Trash2,
  Users,
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { api } from '../services/api';

export default function Patients() {
  const { users, setUsers, setActiveTab, addToast } = useApp();
  const [searchTerm, setSearchTerm] = useState('');

  const filteredUsers = users.filter((u) => {
    const term = searchTerm.toLowerCase();
    return (
      u.name?.toLowerCase().includes(term) ||
      u.email?.toLowerCase().includes(term) ||
      u.phone?.toLowerCase().includes(term) ||
      u.city?.toLowerCase().includes(term)
    );
  });

  const handleDeleteUser = async (id, name) => {
    if (!window.confirm(`Are you sure you want to delete patient ${name}?`)) return;

    setUsers((prev) => prev.filter((u) => u.id !== id));
    try {
      await api.deleteUser(id);
      addToast(`Patient ${name} removed`, 'success');
    } catch {
      addToast(`Patient ${name} removed locally`, 'info');
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-800">Patients Directory</h1>
          <p className="text-sm text-gray-500">
            Registered patients, health vitals, contact records, and consultation history.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <span className="px-3.5 py-1.5 rounded-xl bg-teal-50 text-teal-800 border border-teal-200 text-xs font-bold">
            Total Patients: {users.length}
          </span>
        </div>
      </div>

      {/* Search Input */}
      <div className="bg-white rounded-2xl p-4 border border-gray-100 shadow-sm">
        <div className="relative">
          <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder="Search patients by name, email, phone number, or city..."
            className="w-full pl-10 pr-4 py-2.5 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-teal-500/20 focus:border-teal-500 transition"
          />
        </div>
      </div>

      {/* Patients Table Card */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        {filteredUsers.length === 0 ? (
          <div className="p-12 text-center">
            <div className="w-14 h-14 bg-teal-50 text-teal-600 rounded-2xl flex items-center justify-center mx-auto mb-3">
              <Users className="w-7 h-7" />
            </div>
            <h3 className="text-base font-bold text-gray-800">No patients found</h3>
            <p className="text-xs text-gray-500 mt-1 max-w-sm mx-auto">
              No matching records for "{searchTerm}". Check spelling or clear search filter.
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="text-xs uppercase text-gray-400 bg-gray-50/80 border-b border-gray-100">
                <tr>
                  <th className="py-3.5 px-5 font-semibold">Patient Profile</th>
                  <th className="py-3.5 px-4 font-semibold">Contact Details</th>
                  <th className="py-3.5 px-4 font-semibold">Location</th>
                  <th className="py-3.5 px-4 font-semibold">Health Vitals</th>
                  <th className="py-3.5 px-4 font-semibold text-center">Appointments</th>
                  <th className="py-3.5 px-5 font-semibold text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredUsers.map((u) => (
                  <tr key={u.id} className="hover:bg-gray-50/70 transition">
                    {/* Patient Profile */}
                    <td className="py-4 px-5">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-teal-100 text-teal-800 font-bold flex items-center justify-center text-sm flex-shrink-0">
                          {u.name?.charAt(0).toUpperCase() || 'P'}
                        </div>
                        <div>
                          <div className="font-semibold text-gray-800">{u.name}</div>
                          <div className="text-xs text-gray-400">
                            Joined {u.created_at ? new Date(u.created_at).toLocaleDateString() : 'Recent'}
                          </div>
                        </div>
                      </div>
                    </td>

                    {/* Contact */}
                    <td className="py-4 px-4 text-xs text-gray-600 space-y-1">
                      <div className="flex items-center gap-1.5 text-gray-700">
                        <Mail className="w-3.5 h-3.5 text-gray-400 flex-shrink-0" />
                        <span>{u.email}</span>
                      </div>
                      <div className="flex items-center gap-1.5 text-gray-500">
                        <Phone className="w-3.5 h-3.5 text-gray-400 flex-shrink-0" />
                        <span>{u.phone || 'N/A'}</span>
                      </div>
                    </td>

                    {/* Location */}
                    <td className="py-4 px-4 text-xs text-gray-700">
                      <div className="flex items-center gap-1.5">
                        <MapPin className="w-3.5 h-3.5 text-gray-400" />
                        <span className="font-medium">{u.city || 'Not specified'}</span>
                      </div>
                    </td>

                    {/* Vitals */}
                    <td className="py-4 px-4">
                      <div className="flex flex-wrap items-center gap-1.5">
                        {u.blood_group && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-rose-50 text-rose-700 border border-rose-200 text-xs font-semibold">
                            <HeartPulse className="w-3 h-3 text-rose-500" />
                            {u.blood_group}
                          </span>
                        )}
                        {u.weight && (
                          <span className="px-2 py-0.5 rounded-md bg-gray-100 text-gray-700 text-xs font-medium">
                            {u.weight}
                          </span>
                        )}
                        {u.height && (
                          <span className="px-2 py-0.5 rounded-md bg-gray-100 text-gray-700 text-xs font-medium">
                            {u.height}
                          </span>
                        )}
                        {!u.blood_group && !u.weight && !u.height && (
                          <span className="text-xs text-gray-400">No vitals logged</span>
                        )}
                      </div>
                    </td>

                    {/* Booking count */}
                    <td className="py-4 px-4 text-center">
                      <button
                        onClick={() => setActiveTab('appointments')}
                        className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-teal-50 text-teal-800 hover:bg-teal-100 text-xs font-bold transition"
                        title="View user appointments"
                      >
                        <Calendar className="w-3 h-3 text-teal-600" />
                        <span>{u.appointment_count ?? 1}</span>
                      </button>
                    </td>

                    {/* Actions */}
                    <td className="py-4 px-5 text-right">
                      <button
                        onClick={() => handleDeleteUser(u.id, u.name)}
                        className="p-1.5 text-gray-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition"
                        title="Remove patient"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
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

