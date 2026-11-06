const express = require('express');
const http = require('http');
const path = require('path');
const { Server } = require('socket.io');
const cors = require('cors');
const morgan = require('morgan');
require('dotenv').config();

const { notFound, errorHandler } = require('./middleware/errorMiddleware');

// Route Imports
const authRoutes = require('./routes/authRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const appointmentRoutes = require('./routes/appointmentRoutes');
const chatRoutes = require('./routes/chatRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const adminRoutes = require('./routes/adminRoutes');

// Socket setup
const initChatSocket = require('./sockets/chatSocket');

const app = express();
const server = http.createServer(app);

// Initialize Socket.IO
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

initChatSocket(io);

// Middleware
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
}));
app.options('*', cors());
// Normalize Content-Type header if mobile client sends duplicate headers (e.g. "application/json; charset=UTF-8, application/json")
app.use((req, res, next) => {
  if (req.headers['content-type']) {
    const raw = req.headers['content-type'];
    if (raw.includes(',')) {
      req.headers['content-type'] = raw.split(',')[0].trim();
    }
  }
  next();
});

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(express.text({ type: ['text/*', 'application/*'], limit: '10mb' }));

// Resilient body-parser fallback: if body was parsed as string, auto-parse JSON
app.use((req, res, next) => {
  if (typeof req.body === 'string' && req.body.trim().startsWith('{')) {
    try {
      req.body = JSON.parse(req.body);
    } catch (e) {}
  }
  next();
});

if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));
}

// Serve React Frontend (dist) as static assets
const reactDistDirectory = path.join(__dirname, '..', 'frontend', 'dist');
app.use(express.static(reactDistDirectory));
app.use('/portal', express.static(reactDistDirectory));
app.use('/admin', express.static(reactDistDirectory));

// Serve React Admin SPA for direct navigation or refreshes
app.get(['/admin', '/admin/*', '/portal', '/portal/*'], (req, res) => {
  res.sendFile(path.join(reactDistDirectory, 'index.html'));
});

// Health check / welcome route
app.get('/', (req, res) => {
  // If requested in browser, redirect to React portal
  if (req.accepts('html')) {
    return res.sendFile(path.join(reactDistDirectory, 'index.html'));
  }
  res.json({
    success: true,
    message: '🏥 MediCare Doctor Appointment API is running!',
    version: '1.0.0',
    react_portal: '/portal',
    endpoints: {
      admin: '/api/admin',
      auth: '/api/auth',
      doctors: '/api/doctors',
      appointments: '/api/appointments',
      chat: '/api/chat',
      notifications: '/api/notifications',
    },
  });
});

// API Routes
app.use('/api/admin', adminRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/notifications', notificationRoutes);

// Error Handling Middleware
app.use(notFound);
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

server.listen(PORT, () => {
  console.log(`\n======================================================`);
  console.log(`🚀 MediCare Backend running on: http://localhost:${PORT}`);
  console.log(`💻 MediCare Admin Panel:       http://localhost:${PORT}/admin`);
  console.log(`📡 Socket.IO Real-Time Chat initialized`);
  console.log(`======================================================\n`);
});
