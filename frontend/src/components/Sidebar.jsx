import React from 'react';
import { useApp } from '../context/AppContext';
import { 
  LayoutDashboard, 
  UserCheck, 
  Users, 
  CalendarDays, 
  Megaphone, 
  Building2,
  ShieldCheck,
  LogOut
} from 'lucide-react';

export default function Sidebar({ isOpen, onClose }) {
  const { activeTab, setActiveTab, adminUser, logout } = useApp();

  const navItems = [
    { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
    { id: 'doctors', label: 'Doctors Directory', icon: UserCheck },
    { id: 'users', label: 'Patients & Users', icon: Users },
    { id: 'appointments', label: 'Appointments', icon: CalendarDays },
    { id: 'broadcast', label: 'Broadcast Alerts', icon: Megaphone },
  ];

  return (
    <>
      {/* Mobile backdrop */}
      {isOpen && (
        <div 
          onClick={onClose}
          className="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-40 md:hidden"
        />
      )}

      <aside className={`
        fixed md:sticky top-0 left-0 z-50 h-screen w-64 bg-white border-r border-slate-200/80
        flex flex-col justify-between transition-transform duration-300 shadow-sm
        ${isOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'}
      `}>
        <div>
          {/* Brand Header */}
          <div className="h-20 flex items-center px-6 border-b border-slate-100">
            <div className="h-10 w-10 rounded-xl bg-gradient-to-tr from-teal-700 to-teal-500 flex items-center justify-center text-white shadow-md shadow-teal-700/20 mr-3">
              <Building2 className="w-5 h-5" />
            </div>
            <div>
              <h1 className="font-extrabold text-lg text-slate-900 tracking-tight">MediCare</h1>
              <span className="text-[11px] font-bold text-teal-600 uppercase tracking-wider">Admin Portal</span>
            </div>
          </div>

          {/* Navigation Links */}
          <nav className="p-4 space-y-1.5">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = activeTab === item.id;

              return (
                <button
                  key={item.id}
                  onClick={() => {
                    setActiveTab(item.id);
                    if (onClose) onClose();
                  }}
                  className={`
                    w-full flex items-center space-x-3 px-4 py-3 rounded-xl text-sm font-semibold transition-all
                    ${isActive 
                      ? 'bg-gradient-to-r from-teal-700 to-teal-500 text-white shadow-md shadow-teal-700/25' 
                      : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}
                  `}
                >
                  <Icon className={`w-5 h-5 ${isActive ? 'text-white' : 'text-slate-400'}`} />
                  <span>{item.label}</span>
                </button>
              );
            })}
          </nav>
        </div>

        {/* Footer Admin Tag & Logout */}
        <div className="p-4 border-t border-slate-100 space-y-2">
          <div className="flex items-center space-x-3 p-2.5 rounded-xl bg-slate-50 border border-slate-100">
            <div className="h-9 w-9 rounded-lg bg-teal-600 text-white font-bold flex items-center justify-center text-sm shadow-sm">
              <ShieldCheck className="w-4 h-4" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="text-xs font-bold text-slate-800 truncate">
                {adminUser?.name || 'Administrator'}
              </div>
              <div className="text-[11px] text-teal-600 font-medium truncate">
                {adminUser?.email || 'admin@medicare.com'}
              </div>
            </div>
          </div>

          <button
            onClick={logout}
            className="w-full flex items-center justify-center gap-2 py-2 px-3 rounded-xl text-xs font-semibold text-rose-600 hover:bg-rose-50 border border-transparent hover:border-rose-100 transition"
          >
            <LogOut className="w-3.5 h-3.5" />
            <span>Sign Out</span>
          </button>
        </div>
      </aside>
    </>
  );
}
