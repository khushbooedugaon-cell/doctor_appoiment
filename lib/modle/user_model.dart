class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String city;
  final String? bloodGroup;
  final String? weight;
  final String? height;
  final String? token;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password = '',
    this.city = 'Patna',
    this.bloodGroup,
    this.weight,
    this.height,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? 'Patna',
      bloodGroup: json['blood_group'],
      weight: json['weight'],
      height: json['height'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'blood_group': bloodGroup,
      'weight': weight,
      'height': height,
      'token': token,
    };
  }
}
