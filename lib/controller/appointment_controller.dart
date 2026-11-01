import 'package:get/get.dart';
import '../modle/appointment_model.dart';

class AppointmentsController extends GetxController {
  final tab = 0.obs;

  final appointments = <AppointmentModel>[
    AppointmentModel(id: '1', doctorName: 'Dr. Ananya Sharma', specialty: 'Cardiologist', hospital: 'Apollo Hospital', date: 'Wed, 28 Oct', time: '4:30 PM', type: 'Video Call', status: 'upcoming', fee: '₹800'),
    AppointmentModel(id: '2', doctorName: 'Dr. Rohan Mehta', specialty: 'Dentist', hospital: 'City Dental Care', date: 'Fri, 30 Oct', time: '11:30 AM', type: 'In Clinic', status: 'upcoming', fee: '₹500'),
    AppointmentModel(id: '3', doctorName: 'Dr. Priya Verma', specialty: 'Neurologist', hospital: 'Max Super Speciality', date: '12 Oct', time: '3:00 PM', type: 'In Clinic', status: 'completed', fee: '₹900'),
    AppointmentModel(id: '4', doctorName: 'Dr. Amit Singh', specialty: 'Orthopedic', hospital: 'Fortis Hospital', date: '05 Oct', time: '1:00 PM', type: 'Video Call', status: 'cancelled', fee: '₹700'),
  ];

  List<AppointmentModel> get filtered {
    final status = tab.value == 0
        ? 'upcoming'
        : tab.value == 1
        ? 'completed'
        : 'cancelled';
    return appointments.where((a) => a.status == status).toList();
  }

  void changeTab(int i) => tab.value = i;
}