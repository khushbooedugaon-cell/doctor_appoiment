-- ========================================================
-- MediCare Doctor Appointment Database Schema & Seed Data
-- ========================================================

CREATE DATABASE IF NOT EXISTS medicare_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE medicare_db;

-- --------------------------------------------------------
-- 1. Users Table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    city VARCHAR(80) DEFAULT 'Patna',
    blood_group VARCHAR(10) DEFAULT 'O+',
    weight VARCHAR(20) DEFAULT '68 kg',
    height VARCHAR(20) DEFAULT "5'9\"",
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 2. Doctors Table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    specialty VARCHAR(80) NOT NULL,
    hospital VARCHAR(150) NOT NULL,
    rating DECIMAL(2, 1) DEFAULT 4.8,
    experience VARCHAR(50) DEFAULT '10 yrs',
    fee VARCHAR(50) DEFAULT '₹800',
    avatar_color VARCHAR(20) DEFAULT '#0D9488',
    online BOOLEAN DEFAULT TRUE,
    about TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 3. Appointments Table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    doctor_id INT NOT NULL,
    patient_name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    type ENUM('In Clinic', 'Video Call') NOT NULL DEFAULT 'In Clinic',
    date VARCHAR(50) NOT NULL,
    time VARCHAR(50) NOT NULL,
    note TEXT,
    status ENUM('Upcoming', 'Completed', 'Cancelled') DEFAULT 'Upcoming',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- 4. Chat Messages Table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    doctor_id INT NOT NULL,
    sender ENUM('user', 'doctor') NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- 5. Notifications Table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    category ENUM('Appointments', 'Messages', 'Alerts') DEFAULT 'Alerts',
    action_type VARCHAR(50) DEFAULT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================================
-- Seed Initial Doctors
-- ========================================================
INSERT INTO doctors (id, name, specialty, hospital, rating, experience, fee, avatar_color, online, about)
VALUES 
(1, 'Dr. Ananya Sharma', 'Cardiologist', 'Apollo Hospital', 4.9, '12 yrs', '₹800', '#0D9488', TRUE, 'Senior Cardiologist specializing in preventive heart care, ECG, and non-invasive cardiovascular health.'),
(2, 'Dr. Rohan Mehta', 'Dentist', 'City Dental Care', 4.8, '8 yrs', '₹500', '#3B82F6', FALSE, 'Dental surgeon with expertise in painless root canal treatments, teeth whitening, and orthodontic alignment.'),
(3, 'Dr. Priya Verma', 'Neurologist', 'Max Super Speciality', 4.7, '10 yrs', '₹900', '#8B5CF6', TRUE, 'Experienced neurologist with deep expertise in managing migraines, chronic headaches, sleep disorders, and nerve wellness.'),
(4, 'Dr. Amit Singh', 'Orthopedic', 'Fortis Hospital', 4.6, '15 yrs', '₹700', '#F59E0B', TRUE, 'Orthopedic surgeon and joint specialist focusing on bone density, knee rehabilitation, and sports injuries.'),
(5, 'Dr. Neha Gupta', 'Dermatologist', 'Skin & Cure Clinic', 4.9, '9 yrs', '₹600', '#EC4899', FALSE, 'Cosmetic and clinical dermatologist specializing in skin allergies, acne care, and anti-aging treatments.')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- ========================================================
-- Seed Initial Demo Users (Patients)
-- ========================================================
INSERT INTO users (id, name, email, phone, password, city, blood_group, weight, height)
VALUES 
(1, 'Rahul Kumar', 'rahul@gmail.com', '+91 98765 43210', '$2a$10$su7PTbhef5DR1EorTk.HE.8esJrttKYIrquTtlDl1nTB7mvG3UBke', 'Patna', 'O+', '68 kg', "5'9\""),
(2, 'Sneha Singh', 'sneha@gmail.com', '+91 98112 33445', '$2a$10$su7PTbhef5DR1EorTk.HE.8esJrttKYIrquTtlDl1nTB7mvG3UBke', 'Delhi', 'A+', '54 kg', "5'4\"")
ON DUPLICATE KEY UPDATE name=VALUES(name);


