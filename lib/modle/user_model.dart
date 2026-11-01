class UserModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String city;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.password = '',
    this.city = 'Patna',
  });
}