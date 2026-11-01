class AppointmentModel {
  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String date;
  final String time;
  final String type;
  final String status; // upcoming | completed | cancelled
  final String fee;

  AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.fee,
  });
}