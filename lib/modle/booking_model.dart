class BookingModel {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String type;
  final String patientName;
  final String phone;
  final String note;

  BookingModel({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
    required this.patientName,
    required this.phone,
    required this.note,
  });
}