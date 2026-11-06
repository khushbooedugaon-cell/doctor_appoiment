import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { api, mockData } from '../services/api';

const AppContext = createContext();

export function AppProvider({ children }) {
  const [activeTab, setActiveTab] = useState('dashboard');
  const [doctors, setDoctors] = useState(mockData.doctors);
  const [users, setUsers] = useState(mockData.users);
  const [appointments, setAppointments] = useState(mockData.appointments);
  const [stats, setStats] = useState(null);
  const [isOnline, setIsOnline] = useState(false);
  const [loading, setLoading] = useState(false);
  const [toasts, setToasts] = useState([]);

  // Admin authentication state
  const [adminUser, setAdminUser] = useState(() => {
    try {
      const saved = localStorage.getItem('medicare_admin');
      return saved ? JSON.parse(saved) : null;
    } catch {
      return null;
    }
  });

  // Toast Notification handler
  const addToast = useCallback((message, type = 'info') => {
    const id = Date.now() + Math.random();
    setToasts((prev) => [...prev, { id, message, type }]);
    setTimeout(() => {
      setToasts((prev) => prev.filter((t) => t.id !== id));
    }, 3500);
  }, []);

  const removeToast = useCallback((id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  // Login handler
  const login = async (email, password) => {
    try {
      const res = await api.login(email, password);
      if (res?.success) {
        setAdminUser(res.data);
        localStorage.setItem('medicare_admin', JSON.stringify(res.data));
        addToast(`Welcome back, ${res.data.name}!`, 'success');
        return true;
      }
      throw new Error(res?.message || 'Login failed');
    } catch (err) {
      // Offline fallback: validate default admin credentials
      if (
        (email.trim().toLowerCase() === 'admin@medicare.com' || email.trim().toLowerCase() === 'admin') &&
        password.trim() === 'admin123'
      ) {
        const dummyAdmin = {
          id: 1,
          name: 'Chief Medical Administrator',
          email: 'admin@medicare.com',
          role: 'Super Admin',
          token: 'medicare_demo_token',
        };
        setAdminUser(dummyAdmin);
        localStorage.setItem('medicare_admin', JSON.stringify(dummyAdmin));
        addToast('Signed in successfully (Admin Session)', 'success');
        return true;
      }
      throw new Error(err.message || 'Invalid email or password. Use: admin@medicare.com / admin123');
    }
  };

  // Logout handler
  const logout = () => {
    setAdminUser(null);
    localStorage.removeItem('medicare_admin');
    addToast('Signed out of admin portal', 'info');
  };

  // Compute fallback stats from local state
  const computeStats = useCallback((currentDocs, currentAppts, currentUsers) => {
    const totalDocs = currentDocs.length;
    const onlineDocs = currentDocs.filter((d) => d.online).length;
    const totalAppts = currentAppts.length;
    const upcoming = currentAppts.filter((a) => a.status === 'Upcoming').length;
    const completed = currentAppts.filter((a) => a.status === 'Completed').length;
    const cancelled = currentAppts.filter((a) => a.status === 'Cancelled').length;

    const rev = currentAppts
      .filter((a) => a.status === 'Completed')
      .reduce((sum, a) => sum + (parseInt(a.fee ? a.fee.replace(/[^\d]/g, '') : '500') || 500), 0);

    return {
      doctors: { total: totalDocs, online: onlineDocs },
      users: { total: currentUsers.length },
      appointments: { total: totalAppts, upcoming, completed, cancelled },
      revenue: { total: rev, currency: '₹' },
      recent_appointments: currentAppts.slice(0, 6),
    };
  }, []);

  // Refresh all state from API (or fallback)
  const refreshData = useCallback(async () => {
    setLoading(true);
    try {
      const [statsRes, docsRes, apptsRes, usersRes] = await Promise.all([
        api.getStats().catch(() => null),
        api.getDoctors().catch(() => null),
        api.getAppointments().catch(() => null),
        api.getUsers().catch(() => null),
      ]);

      if (docsRes?.success) {
        setDoctors(docsRes.data);
        setIsOnline(true);
      }
      if (apptsRes?.success) setAppointments(apptsRes.data);
      if (usersRes?.success) setUsers(usersRes.data);

      if (statsRes?.success) {
        setStats(statsRes.data);
      } else {
        setStats(computeStats(docsRes?.data || doctors, apptsRes?.data || appointments, usersRes?.data || users));
      }
    } catch {
      setIsOnline(false);
      setStats(computeStats(doctors, appointments, users));
    } finally {
      setLoading(false);
    }
  }, [computeStats, doctors, appointments, users]);

  useEffect(() => {
    if (adminUser) {
      refreshData();
    }
  }, [adminUser]);

  return (
    <AppContext.Provider
      value={{
        activeTab,
        setActiveTab,
        adminUser,
        login,
        logout,
        doctors,
        setDoctors,
        users,
        setUsers,
        appointments,
        setAppointments,
        stats,
        setStats,
        isOnline,
        loading,
        refreshData,
        toasts,
        addToast,
        removeToast,
      }}
    >
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const context = useContext(AppContext);
  if (!context) throw new Error('useApp must be used within AppProvider');
  return context;
}
