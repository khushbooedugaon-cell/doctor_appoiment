import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/user_model.dart';
import '../modle/doctor_model.dart';
import '../modle/appointment_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static final GetConnect _connect = GetConnect(
    timeout: const Duration(seconds: 15),
  );

  /// Current logged-in user session (null by default until login or signup)
  static UserModel? currentUser;

  /// Set to true to switch the entire mobile app to your live production cloud backend
  static bool useLiveBackend = false;

  /// Paste your Render.com live URL here (e.g. 'https://medicare-backend-xyz.onrender.com/api')
  static String liveBaseUrl = 'https://medicare-backend.onrender.com/api';

  /// Optional custom override (e.g. 'http://192.168.1.5:5000/api' for physical device testing)
  static String? customBaseUrl;

  /// Base URL configured according to platform
  /// - Live Cloud Backend: liveBaseUrl (if useLiveBackend = true)
  /// - Web / Windows: http://localhost:5000/api
  /// - Android Emulator: http://10.0.2.2:5000/api
  /// - Physical Phone: replace with your local WiFi IP (e.g. http://192.168.1.5:5000/api)
  static String get baseUrl {
    if (useLiveBackend && liveBaseUrl.isNotEmpty) {
      return liveBaseUrl;
    }
    if (customBaseUrl != null && customBaseUrl!.isNotEmpty) {
      return customBaseUrl!;
    }
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }

  static Map<String, String> get _authHeaders {
    final headers = {
      'Accept': 'application/json',
    };
    if (currentUser?.token != null && currentUser!.token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${currentUser!.token}';
    }
    return headers;
  }

  // ==========================================
  // 1. Authentication APIs
  // ==========================================

  /// User Login API
  /// POST /api/auth/login
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPass = password.trim();
    final url = '$baseUrl/auth/login';

    try {
      final response = await _connect.post(
        url,
        {
          'email': cleanEmail,
          'password': cleanPass,
        },
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['success'] == true) {
          final user = UserModel.fromJson(body['data']);
          currentUser = user;
          return user;
        }
      }

      // If backend responded with an error (400, 401, 404, etc.)
      if (response.body is Map && response.body['message'] != null) {
        throw Exception(response.body['message']);
      }

      if (response.statusCode == 401) {
        throw Exception('Invalid email or password. Please verify credentials.');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      debugPrint('❌ [ApiService] Backend connection failed: $e');
      throw Exception('Cannot connect to backend server ($baseUrl). Make sure backend is running.');
    }

    throw Exception('Invalid email or password');
  }

  /// User Registration / Sign Up API
  /// POST /api/auth/register
  static Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String city = 'Patna',
    String? bloodGroup,
    String? weight,
    String? height,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phone.trim();
    final cleanPass = password.trim();
    final cleanCity = city.trim().isNotEmpty ? city.trim() : 'Patna';
    final url = '$baseUrl/auth/register';

    try {
      final response = await _connect.post(
        url,
        {
          'name': cleanName,
          'email': cleanEmail,
          'phone': cleanPhone,
          'password': cleanPass,
          'city': cleanCity,
        },
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['success'] == true) {
          final user = UserModel.fromJson(body['data']);
          currentUser = user;
          return user;
        }
      }

      // If server returned an error (e.g. 400 user already exists)
      if (response.body is Map && response.body['message'] != null) {
        throw Exception(response.body['message']);
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      debugPrint('❌ [ApiService] Register connection failed: $e');
      throw Exception('Cannot connect to backend server ($baseUrl). Make sure backend is running.');
    }

    throw Exception('Registration failed. Please try again.');
  }

  // ==========================================
  // 2. Doctors Directory APIs
  // ==========================================

  /// Fetch all doctors with optional search / filter
  /// GET /api/doctors
  static Future<List<DoctorModel>> getDoctors({String? search}) async {
    String url = '$baseUrl/doctors';
    if (search != null && search.trim().isNotEmpty) {
      url += '?search=${Uri.encodeComponent(search.trim())}';
    }

    try {
      final response = await _connect.get(url, headers: _authHeaders);
      if (response.statusCode == 200 && response.body is Map && response.body['success'] == true) {
        final list = response.body['data'] as List?;
        if (list != null) {
          return list.map((item) => DoctorModel.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint('ℹ️ [ApiService] Failed to fetch live doctors ($e), using fallback.');
    }

    // Default Doctors Fallback
    return [
      DoctorModel(
        id: 1,
        name: 'Dr. Ananya Sharma',
        specialty: 'Cardiologist',
        hospital: 'Apollo Hospital',
        rating: 4.9,
        experience: '12 yrs',
        fee: '₹800',
        avatarColor: const Color(0xFF0D9488),
        online: true,
        about: 'Senior Cardiologist specializing in preventive heart care, ECG, and non-invasive cardiovascular health.',
      ),
      DoctorModel(
        id: 2,
        name: 'Dr. Rohan Mehta',
        specialty: 'Dentist',
        hospital: 'City Dental Care',
        rating: 4.8,
        experience: '8 yrs',
        fee: '₹500',
        avatarColor: const Color(0xFF3B82F6),
        online: false,
        about: 'Dental surgeon with expertise in painless root canal treatments, teeth whitening, and orthodontic alignment.',
      ),
      DoctorModel(
        id: 3,
        name: 'Dr. Priya Verma',
        specialty: 'Neurologist',
        hospital: 'Max Super Speciality',
        rating: 4.7,
        experience: '10 yrs',
        fee: '₹900',
        avatarColor: const Color(0xFF8B5CF6),
        online: true,
        about: 'Experienced neurologist with deep expertise in managing migraines, chronic headaches, sleep disorders, and nerve wellness.',
      ),
      DoctorModel(
        id: 4,
        name: 'Dr. Amit Singh',
        specialty: 'Orthopedic',
        hospital: 'Fortis Hospital',
        rating: 4.6,
        experience: '15 yrs',
        fee: '₹700',
        avatarColor: const Color(0xFFF59E0B),
        online: true,
        about: 'Orthopedic surgeon and joint specialist focusing on bone density, knee rehabilitation, and sports injuries.',
      ),
      DoctorModel(
        id: 5,
        name: 'Dr. Neha Gupta',
        specialty: 'Dermatologist',
        hospital: 'Skin & Cure Clinic',
        rating: 4.9,
        experience: '9 yrs',
        fee: '₹600',
        avatarColor: const Color(0xFFEC4899),
        online: false,
        about: 'Cosmetic and clinical dermatologist specializing in skin allergies, acne care, and anti-aging treatments.',
      ),
    ];
  }

  // ==========================================
  // 3. Appointments APIs
  // ==========================================

  /// Book an appointment
  /// POST /api/appointments
  static Future<AppointmentModel> bookAppointment({
    required int doctorId,
    required String doctorName,
    required String specialty,
    required String hospital,
    required String fee,
    required String patientName,
    required String phone,
    required String date,
    required String time,
    required String type,
    String note = '',
  }) async {
    final url = '$baseUrl/appointments';

    try {
      final response = await _connect.post(
        url,
        {
          'doctor_id': doctorId,
          'patient_name': patientName.trim(),
          'phone': phone.trim(),
          'date': date,
          'time': time,
          'type': type,
          'note': note.trim(),
          'user_id': currentUser?.id ?? 1,
        },
        contentType: 'application/json',
        headers: _authHeaders,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['success'] == true) {
          return AppointmentModel.fromJson(body['data']);
        }
      }
    } catch (e) {
      debugPrint('ℹ️ [ApiService] Failed to book via API: $e');
    }

    return AppointmentModel(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      hospital: hospital,
      date: date,
      time: time,
      type: type,
      status: 'upcoming',
      fee: fee,
      patientName: patientName,
      phone: phone,
      note: note,
    );
  }

  /// Get user appointments
  /// GET /api/appointments/admin/all or /api/appointments
  static Future<List<AppointmentModel>> getMyAppointments() async {
    final url = '$baseUrl/appointments/admin/all';

    try {
      final response = await _connect.get(url, headers: _authHeaders);
      if (response.statusCode == 200 && response.body is Map && response.body['success'] == true) {
        final list = response.body['data'] as List?;
        if (list != null && list.isNotEmpty) {
          return list.map((item) => AppointmentModel.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint('ℹ️ [ApiService] Failed to fetch appointments: $e');
    }

    return [
      AppointmentModel(
        id: '1',
        doctorId: 1,
        doctorName: 'Dr. Ananya Sharma',
        specialty: 'Cardiologist',
        hospital: 'Apollo Hospital',
        date: 'Wed, 28 Oct',
        time: '04:30 PM',
        type: 'Video Call',
        status: 'upcoming',
        fee: '₹800',
        patientName: currentUser?.name ?? 'Rahul Kumar',
        phone: currentUser?.phone ?? '+91 98765 43210',
      ),
      AppointmentModel(
        id: '2',
        doctorId: 2,
        doctorName: 'Dr. Rohan Mehta',
        specialty: 'Dentist',
        hospital: 'City Dental Care',
        date: 'Fri, 30 Oct',
        time: '11:30 AM',
        type: 'In Clinic',
        status: 'upcoming',
        fee: '₹500',
        patientName: currentUser?.name ?? 'Rahul Kumar',
        phone: currentUser?.phone ?? '+91 98765 43210',
      ),
    ];
  }

  /// Cancel appointment
  /// PUT /api/appointments/:id/cancel
  static Future<bool> cancelAppointment(String id) async {
    final url = '$baseUrl/appointments/$id/cancel';

    try {
      final response = await _connect.put(url, {}, headers: _authHeaders);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('ℹ️ [ApiService] Cancel API error: $e');
    }
    return true;
  }

  // ==========================================
  // 4. Profile APIs
  // ==========================================

  /// Update user profile
  /// PUT /api/auth/profile
  static Future<UserModel> updateProfile({
    required String name,
    required String phone,
    required String city,
    String? bloodGroup,
    String? weight,
    String? height,
  }) async {
    final url = '$baseUrl/auth/profile';

    try {
      final response = await _connect.put(
        url,
        {
          'name': name.trim(),
          'phone': phone.trim(),
          'city': city.trim(),
          'blood_group': bloodGroup,
          'weight': weight,
          'height': height,
        },
        contentType: 'application/json',
        headers: _authHeaders,
      );

      if (response.statusCode == 200 && response.body is Map && response.body['success'] == true) {
        final user = UserModel.fromJson(response.body['data']);
        currentUser = user;
        return user;
      }
    } catch (e) {
      debugPrint('ℹ️ [ApiService] Update profile error: $e');
    }

    final updated = UserModel(
      id: currentUser?.id ?? 1,
      name: name.trim(),
      email: currentUser?.email ?? 'rahul@gmail.com',
      phone: phone.trim(),
      city: city.trim(),
      bloodGroup: bloodGroup ?? currentUser?.bloodGroup ?? 'O+',
      weight: weight ?? currentUser?.weight ?? '68 kg',
      height: height ?? currentUser?.height ?? "5'9\"",
      token: currentUser?.token,
    );
    currentUser = updated;
    return updated;
  }

  // ==========================================
  // 5. Notifications API
  // ==========================================

  /// Get notifications for user
  /// GET /api/notifications
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final url = '$baseUrl/notifications';

    try {
      final response = await _connect.get(url, headers: _authHeaders);
      if (response.statusCode == 200 && response.body is Map && response.body['success'] == true) {
        final list = response.body['data'] as List?;
        if (list != null && list.isNotEmpty) {
          return list.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      debugPrint('ℹ️ [ApiService] Notifications API offline: $e');
    }

    return [
      {
        'id': '1',
        'title': 'Upcoming Appointment Today',
        'message': 'Your consultation with Dr. Ananya Sharma (Cardiology) is scheduled today at 4:30 PM.',
        'time': '15m ago',
        'category': 'Appointments',
        'is_read': false,
      },
      {
        'id': '2',
        'title': 'New Message from Dr. Rohan',
        'message': 'Your dental X-ray reports look completely normal. Continue prescribed care.',
        'time': '2h ago',
        'category': 'Messages',
        'is_read': false,
      },
      {
        'id': '3',
        'title': 'Annual Cardiac Health Camp',
        'message': 'Free heart checkups and ECG screening at Apollo Hospital this Sunday.',
        'time': '1d ago',
        'category': 'Alerts',
        'is_read': true,
      },
    ];
  }
}
