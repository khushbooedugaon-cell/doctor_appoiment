import React from 'react';

export default function StatCard({ label, value, subtext, icon: Icon, colorClass, bgClass }) {
  return (
    <div className="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-card flex items-center justify-between">
      <div>
        <span className="text-xs font-bold uppercase tracking-wider text-slate-400">{label}</span>
        <div className="text-2xl font-extrabold text-slate-900 mt-1">{value}</div>
        {subtext && <div className="text-xs font-semibold text-teal-600 mt-1">{subtext}</div>}
      </div>
      <div className={`h-12 w-12 rounded-2xl ${bgClass} ${colorClass} flex items-center justify-center text-xl`}>
        <Icon className="w-6 h-6" />
      </div>
    </div>
  );
}

