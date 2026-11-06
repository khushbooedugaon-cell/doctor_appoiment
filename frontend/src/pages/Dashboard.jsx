import React from 'react';
import {
  Users,
  UserCheck,
  CalendarCheck,
  TrendingUp,
  Clock,
  ArrowRight,
  Star,
  Activity,
  PlusCircle,
  BellRing,
} from 'lucide-react';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler,
} from 'chart.js';
import { Line, Doughnut } from 'react-chartjs-2';
import StatCard from '../components/StatCard';
import { useApp } from '../context/AppContext';

// Register ChartJS modules
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
);

export default function Dashboard({ onOpenDoctorModal, onOpenAppointmentModal }) {
  const { stats, doctors, appointments, users, setActiveTab } = useApp();

  const totalRevenue = stats?.revenue?.total ?? 14200;
  const totalDoctors = doctors.length;
  const onlineDoctors = doctors.filter((d) => d.online).length;
  const totalUsers = users.length;
  const totalAppointments = appointments.length;
  const upcomingCount = appointments.filter((a) => a.status === 'Upcoming').length;

  // Specialty counts for Doughnut chart
  const specialtyCounts = doctors.reduce((acc, doc) => {
    acc[doc.specialty] = (acc[doc.specialty] || 0) + 1;
    return acc;
  }, {});

  const doughnutData = {
    labels: Object.keys(specialtyCounts),
    datasets: [
      {
        data: Object.values(specialtyCounts),
        backgroundColor: [
          '#0D9488', // Teal
          '#14B8A6', // Teal light
          '#3B82F6', // Blue
          '#8B5CF6', // Purple
          '#F59E0B', // Amber
          '#EC4899', // Pink
          '#10B981', // Emerald
        ],
        borderWidth: 2,
        borderColor: '#ffffff',
      },
    ],
  };

  const doughnutOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
        labels: { boxWidth: 12, font: { size: 12, family: 'Inter' }, padding: 12 },
      },
    },
    cutout: '70%',
  };

  // Trend data for Line chart
  const lineData = {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    datasets: [
      {
        label: 'Completed Consultations',
        data: [12, 19, 15, 25, 22, 30, 28],
        borderColor: '#0D9488',
        backgroundColor: 'rgba(13, 148, 136, 0.12)',
        tension: 0.4,
        fill: true,
        pointBackgroundColor: '#0D9488',
        pointBorderColor: '#ffffff',
        pointBorderWidth: 2,
        pointRadius: 4,
      },
      {
        label: 'New Bookings',
        data: [8, 14, 18, 20, 16, 24, 22],
        borderColor: '#3B82F6',
        backgroundColor: 'rgba(59, 130, 246, 0.05)',
        tension: 0.4,
        fill: true,
        borderDash: [4, 4],
        pointBackgroundColor: '#3B82F6',
        pointBorderColor: '#ffffff',
        pointBorderWidth: 2,
        pointRadius: 4,
      },
    ],
  };

  const lineOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'top',
        align: 'end',
        labels: { boxWidth: 12, font: { size: 12, family: 'Inter' } },
      },
      tooltip: {
        backgroundColor: '#0F172A',
        padding: 10,
        titleFont: { size: 13, weight: 'bold' },
        bodyFont: { size: 12 },
        cornerRadius: 8,
      },
    },
    scales: {
      x: { grid: { display: false }, ticks: { font: { size: 11, family: 'Inter' } } },
      y: {
        grid: { color: '#F1F5F9' },
        ticks: { font: { size: 11, family: 'Inter' }, stepSize: 10 },
      },
    },
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
      {/* Top Banner / Welcome */}
      <div className="relative overflow-hidden bg-gradient-to-r from-teal-700 via-teal-600 to-emerald-600 rounded-3xl p-6 md:p-8 text-white shadow-xl shadow-teal-700/10">
        <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div className="space-y-2">
            <div className="inline-flex items-center gap-2 px-3 py-1 bg-white/15 backdrop-blur-md rounded-full text-xs font-semibold uppercase tracking-wider text-teal-100">
              <Activity className="w-3.5 h-3.5 animate-pulse text-teal-200" />
              Hospital Management Suite
            </div>
            <h1 className="text-2xl md:text-3xl font-extrabold tracking-tight">
              MediCare Command Center
            </h1>
            <p className="text-teal-100 text-sm max-w-xl leading-relaxed">
              Real-time monitoring of doctors, patient appointments, consultations, and medical notifications.
            </p>
          </div>

          {/* Quick Action Buttons */}
          <div className="flex flex-wrap items-center gap-3">
            <button
              onClick={() => onOpenAppointmentModal()}
              className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-white text-teal-800 font-semibold text-sm shadow-md hover:bg-teal-50 transition active:scale-95"
            >
              <PlusCircle className="w-4 h-4 text-teal-600" />
              Book Appointment
            </button>
            <button
              onClick={() => onOpenDoctorModal()}
              className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-teal-800/80 hover:bg-teal-900 text-white font-semibold text-sm border border-teal-500/30 transition active:scale-95"
            >
              <UserCheck className="w-4 h-4 text-teal-300" />
              Add Doctor
            </button>
          </div>
        </div>

        {/* Decorative background circle */}
        <div className="absolute -right-12 -bottom-12 w-64 h-64 rounded-full bg-white/10 blur-2xl pointer-events-none" />
      </div>

      {/* Metrics Row */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
        <StatCard
          title="Total Doctors"
          value={totalDoctors}
          subtitle={`${onlineDoctors} currently available online`}
          icon={Users}
          color="teal"
          trend="+2 this month"
          onClick={() => setActiveTab('doctors')}
        />
        <StatCard
          title="Registered Patients"
          value={totalUsers}
          subtitle="Active patient accounts"
          icon={UserCheck}
          color="blue"
          trend="+18% growth"
          onClick={() => setActiveTab('patients')}
        />
        <StatCard
          title="Total Consultations"
          value={totalAppointments}
          subtitle={`${upcomingCount} upcoming appointments`}
          icon={CalendarCheck}
          color="emerald"
          trend="+12% today"
          onClick={() => setActiveTab('appointments')}
        />
        <StatCard
          title="Estimated Revenue"
          value={`₹${totalRevenue.toLocaleString()}`}
          subtitle="From completed bookings"
          icon={TrendingUp}
          color="amber"
          trend="+24.5%"
        />
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Trend Line Chart */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-base font-bold text-gray-800">Consultation & Appointment Activity</h2>
              <p className="text-xs text-gray-500">Weekly patient turnout and completed sessions</p>
            </div>
            <span className="px-2.5 py-1 text-xs font-semibold text-teal-700 bg-teal-50 rounded-lg">
              Live Updates
            </span>
          </div>
          <div className="h-72 w-full">
            <Line data={lineData} options={lineOptions} />
          </div>
        </div>

        {/* Specialty Distribution Doughnut */}
        <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-2">
              <h2 className="text-base font-bold text-gray-800">Specialty Mix</h2>
              <span className="text-xs text-gray-400 font-medium">{doctors.length} Doctors</span>
            </div>
            <p className="text-xs text-gray-500 mb-4">Distribution by medical department</p>
          </div>
          <div className="h-60 w-full relative">
            <Doughnut data={doughnutData} options={doughnutOptions} />
          </div>
        </div>
      </div>

      {/* Two Column Layout: Recent Appointments & Top Doctors */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Recent Appointments */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
          <div className="flex items-center justify-between mb-5">
            <div>
              <h2 className="text-base font-bold text-gray-800">Recent Appointments</h2>
              <p className="text-xs text-gray-500">Latest scheduled patient visits</p>
            </div>
            <button
              onClick={() => setActiveTab('appointments')}
              className="inline-flex items-center gap-1.5 text-xs font-semibold text-teal-700 hover:text-teal-800 hover:underline"
            >
              View all ({appointments.length})
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="text-xs uppercase text-gray-400 border-b border-gray-100">
                <tr>
                  <th className="pb-3 font-semibold">Patient</th>
                  <th className="pb-3 font-semibold">Doctor</th>
                  <th className="pb-3 font-semibold">Schedule</th>
                  <th className="pb-3 font-semibold">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {appointments.slice(0, 5).map((appt) => (
                  <tr key={appt.id} className="hover:bg-gray-50/70 transition">
                    <td className="py-3.5">
                      <div className="font-semibold text-gray-800">{appt.patient_name}</div>
                      <div className="text-xs text-gray-400">{appt.phone}</div>
                    </td>
                    <td className="py-3.5">
                      <div className="font-medium text-gray-800">{appt.doctor_name}</div>
                      <div className="text-xs text-teal-600">{appt.specialty}</div>
                    </td>
                    <td className="py-3.5">
                      <div className="flex items-center gap-1.5 text-gray-700 text-xs">
                        <Clock className="w-3.5 h-3.5 text-gray-400" />
                        <span>{appt.date} • {appt.time}</span>
                      </div>
                    </td>
                    <td className="py-3.5">
                      <span
                        className={`inline-flex px-2.5 py-1 text-xs font-semibold rounded-full border ${getStatusBadge(
                          appt.status
                        )}`}
                      >
                        {appt.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Top Doctors Widget */}
        <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-4">
              <div>
                <h2 className="text-base font-bold text-gray-800">Featured Specialists</h2>
                <p className="text-xs text-gray-500">Highest rated medical officers</p>
              </div>
              <button
                onClick={() => setActiveTab('doctors')}
                className="text-xs text-teal-600 hover:underline font-semibold"
              >
                Manage
              </button>
            </div>

            <div className="space-y-3.5">
              {doctors.slice(0, 4).map((doc) => (
                <div
                  key={doc.id}
                  className="flex items-center justify-between p-3 rounded-xl bg-gray-50/60 hover:bg-gray-100/70 transition"
                >
                  <div className="flex items-center gap-3">
                    <div
                      className="w-10 h-10 rounded-xl flex items-center justify-center font-bold text-white text-sm shadow-sm"
                      style={{ backgroundColor: doc.avatar_color || '#0D9488' }}
                    >
                      {doc.name.replace('Dr. ', '').charAt(0)}
                    </div>
                    <div>
                      <h4 className="text-sm font-semibold text-gray-800 leading-tight">
                        {doc.name}
                      </h4>
                      <p className="text-xs text-teal-600">{doc.specialty}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-1 bg-amber-50 px-2 py-1 rounded-lg border border-amber-100 text-amber-700 text-xs font-bold">
                    <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                    {doc.rating || '4.8'}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Broadcast Card shortcut */}
          <div className="mt-6 pt-5 border-t border-gray-100">
            <div className="p-4 rounded-xl bg-teal-50 border border-teal-100 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-lg bg-teal-600 text-white flex items-center justify-center shadow-sm">
                  <BellRing className="w-4 h-4" />
                </div>
                <div>
                  <h4 className="text-xs font-bold text-teal-900">Push Broadcast</h4>
                  <p className="text-[11px] text-teal-700">Send alerts to all patients</p>
                </div>
              </div>
              <button
                onClick={() => setActiveTab('broadcast')}
                className="px-3 py-1.5 rounded-lg bg-teal-600 hover:bg-teal-700 text-white text-xs font-semibold shadow-sm transition"
              >
                Notify
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

