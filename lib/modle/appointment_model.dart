class AppointmentModel {
  final String id;
  final int? doctorId;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String date;
  final String time;
  final String type;
  final String status; // upcoming | completed | cancelled
  final String fee;
  final String? patientName;
  final String? phone;
  final String? note;

  AppointmentModel({
    required this.id,
    this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.fee,
    this.patientName,
    this.phone,
    this.note,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : int.tryParse(json['doctor_id']?.toString() ?? ''),
      doctorName: json['doctor_name'] ?? 'Doctor',
      specialty: json['specialty'] ?? 'General',
      hospital: json['hospital'] ?? 'MediCare Hospital',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? 'In Clinic',
      status: (json['status'] ?? 'upcoming').toString().toLowerCase(),
      fee: json['fee'] ?? '₹500',
      patientName: json['patient_name'],
      phone: json['phone'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'specialty': specialty,
      'hospital': hospital,
      'date': date,
      'time': time,
      'type': type,
      'status': status,
      'fee': fee,
      'patient_name': patientName,
      'phone': phone,
      'note': note,
    };
  }
}
