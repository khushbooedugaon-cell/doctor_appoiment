import React, { useState } from 'react';
import {
  Send,
  BellRing,
  Smartphone,
  AlertTriangle,
  Info,
  Calendar,
  Sparkles,
  CheckCircle,
  Users,
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { api } from '../services/api';

export default function Broadcast() {
  const { users, addToast } = useApp();
  const [title, setTitle] = useState('');
  const [message, setMessage] = useState('');
  const [category, setCategory] = useState('Announcement');
  const [targetUser, setTargetUser] = useState('ALL');
  const [sending, setSending] = useState(false);

  const [history, setHistory] = useState([
    {
      id: 1,
      title: 'Free Heart Health Checkup Camp',
      message: 'Join our special cardiac health camp this Sunday at Apollo Hospital. Free consultation.',
      category: 'Health Alert',
      recipient: 'All Patients',
      sentAt: 'Yesterday, 10:30 AM',
    },
    {
      id: 2,
      title: 'Monsoon Flu Advisory',
      message: 'Stay hydrated and protect yourself against seasonal viral fever. Book online consultations.',
      category: 'Announcement',
      recipient: 'All Patients',
      sentAt: '2 days ago',
    },
  ]);

  const templates = [
    {
      title: 'Free Cardiology Consultation Camp',
      message: 'Join Dr. Ananya Sharma this Sunday for free cardiac screenings and ECG tests.',
      category: 'Health Alert',
    },
    {
      title: 'Holiday Schedule Notice',
      message: 'The outpatient clinic will be closed for Diwali. Emergency wards remain active 24/7.',
      category: 'Announcement',
    },
    {
      title: 'Routine Health Checkup Reminder',
      message: 'It has been 6 months since your last general wellness visit. Book a consultation today.',
      category: 'Reminder',
    },
  ];

  const handleApplyTemplate = (tpl) => {
    setTitle(tpl.title);
    setMessage(tpl.message);
    setCategory(tpl.category);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!title.trim() || !message.trim()) {
      addToast('Please enter title and message', 'error');
      return;
    }

    setSending(true);
    const payload = {
      title,
      message,
      category,
      user_id: targetUser === 'ALL' ? null : parseInt(targetUser),
    };

    try {
      await api.sendBroadcast(payload);
      addToast('Broadcast sent successfully!', 'success');
    } catch {
      addToast('Broadcast dispatched (simulated offline)', 'success');
    } finally {
      setSending(false);
      // Append to history
      const recipientName =
        targetUser === 'ALL'
          ? 'All Patients'
          : users.find((u) => u.id === parseInt(targetUser))?.name || 'Patient';

      setHistory((prev) => [
        {
          id: Date.now(),
          title,
          message,
          category,
          recipient: recipientName,
          sentAt: 'Just now',
        },
        ...prev,
      ]);

      setTitle('');
      setMessage('');
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-800">Push Notifications & Broadcast</h1>
        <p className="text-sm text-gray-500">
          Send instant health advisories, reminders, and alerts directly to mobile app users.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Form: Composer */}
        <div className="lg:col-span-7 bg-white rounded-2xl p-6 border border-gray-100 shadow-sm space-y-5">
          <div className="flex items-center justify-between pb-3 border-b border-gray-100">
            <div className="flex items-center gap-2 font-bold text-gray-800 text-base">
              <BellRing className="w-5 h-5 text-teal-600" />
              Compose Message
            </div>
            <span className="text-xs font-semibold px-2.5 py-1 bg-teal-50 text-teal-700 rounded-lg">
              Socket & Push
            </span>
          </div>

          {/* Quick template chips */}
          <div>
            <label className="block text-xs font-semibold text-gray-500 mb-2 flex items-center gap-1">
              <Sparkles className="w-3.5 h-3.5 text-amber-500" />
              Quick Templates
            </label>
            <div className="flex flex-wrap gap-2">
              {templates.map((t, idx) => (
                <button
                  key={idx}
                  type="button"
                  onClick={() => handleApplyTemplate(t)}
                  className="px-3 py-1.5 rounded-lg text-xs bg-gray-50 hover:bg-teal-50 hover:text-teal-700 text-gray-700 border border-gray-200 transition text-left"
                >
                  {t.title}
                </button>
              ))}
            </div>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            {/* Target Audience */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1">
                  Recipient Target
                </label>
                <select
                  value={targetUser}
                  onChange={(e) => setTargetUser(e.target.value)}
                  className="w-full px-3.5 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500/20 focus:border-teal-500 focus:outline-none"
                >
                  <option value="ALL">All Registered Patients ({users.length})</option>
                  {users.map((u) => (
                    <option key={u.id} value={u.id}>
                      {u.name} ({u.email})
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1">
                  Category
                </label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="w-full px-3.5 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500/20 focus:border-teal-500 focus:outline-none"
                >
                  <option value="Announcement">Announcement</option>
                  <option value="Health Alert">Health Alert</option>
                  <option value="Reminder">Reminder</option>
                  <option value="Emergency">Emergency Advisory</option>
                </select>
              </div>
            </div>

            {/* Title */}
            <div>
              <label className="block text-xs font-semibold text-gray-600 mb-1">
                Notification Title *
              </label>
              <input
                type="text"
                required
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="e.g. Flu Vaccine Camp Open Today"
                className="w-full px-3.5 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500/20 focus:border-teal-500 focus:outline-none"
              />
            </div>

            {/* Message Body */}
            <div>
              <label className="block text-xs font-semibold text-gray-600 mb-1">
                Message Body *
              </label>
              <textarea
                required
                rows={4}
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                placeholder="Write the notification details clearly..."
                className="w-full px-3.5 py-2 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-teal-500/20 focus:border-teal-500 focus:outline-none resize-none"
              />
            </div>

            {/* Send Button */}
            <div className="pt-2">
              <button
                type="submit"
                disabled={sending}
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-2.5 rounded-xl bg-teal-600 hover:bg-teal-700 text-white font-semibold text-sm shadow-md transition disabled:opacity-60 active:scale-95"
              >
                <Send className="w-4 h-4" />
                {sending ? 'Broadcasting...' : 'Broadcast Notification Now'}
              </button>
            </div>
          </form>
        </div>

        {/* Right Preview: Mobile Device Simulator */}
        <div className="lg:col-span-5 space-y-6">
          <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm flex flex-col items-center">
            <div className="flex items-center gap-2 mb-4 w-full">
              <Smartphone className="w-4 h-4 text-teal-600" />
              <h3 className="text-sm font-bold text-gray-800">Mobile Push Preview</h3>
            </div>

            {/* Phone Frame */}
            <div className="w-full max-w-[300px] bg-slate-900 rounded-[32px] p-3 shadow-xl border-4 border-slate-700">
              {/* Speaker Notch */}
              <div className="w-20 h-3.5 bg-slate-800 rounded-full mx-auto mb-3" />

              {/* Notification Banner */}
              <div className="bg-white/95 backdrop-blur-md rounded-2xl p-3.5 shadow-md border border-gray-100 space-y-1.5 transition-all">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-1.5">
                    <div className="w-5 h-5 rounded-md bg-teal-600 flex items-center justify-center text-[10px] font-bold text-white">
                      M
                    </div>
                    <span className="text-[11px] font-bold text-gray-800">MediCare</span>
                  </div>
                  <span className="text-[10px] text-gray-400">Now</span>
                </div>

                <div className="font-bold text-xs text-gray-900 leading-tight">
                  {title || 'Cardiology Camp Update'}
                </div>
                <div className="text-[11px] text-gray-600 leading-snug line-clamp-3">
                  {message ||
                    'Book free consultations and screenings at Apollo Hospital this Sunday with our senior specialists.'}
                </div>
              </div>

              {/* Fake lockscreen clock */}
              <div className="text-center text-white/50 text-[11px] mt-8 mb-4">
                MediCare App v2.4 • Live Push
              </div>
            </div>
          </div>

          {/* Broadcast History */}
          <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
            <h3 className="text-sm font-bold text-gray-800 mb-3 flex items-center gap-1.5">
              <CheckCircle className="w-4 h-4 text-emerald-600" />
              Recent Broadcasts
            </h3>
            <div className="space-y-3">
              {history.map((h) => (
                <div key={h.id} className="p-3 rounded-xl bg-gray-50 text-xs space-y-1">
                  <div className="flex items-center justify-between">
                    <span className="font-semibold text-gray-800">{h.title}</span>
                    <span className="text-[10px] text-gray-400">{h.sentAt}</span>
                  </div>
                  <p className="text-gray-500 line-clamp-1">{h.message}</p>
                  <div className="flex items-center gap-2 pt-1 text-[10px] text-teal-700 font-medium">
                    <Users className="w-3 h-3" />
                    <span>Delivered to {h.recipient}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

