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

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? city,
    String? bloodGroup,
    String? weight,
    String? height,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      city: city ?? this.city,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      token: token ?? this.token,
    );
  }
}
