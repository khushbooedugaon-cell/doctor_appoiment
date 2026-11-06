import 'package:flutter/material.dart';

class DoctorModel {
  final int id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final String experience;
  final String fee;
  final Color avatarColor;
  final bool online;
  final String about;

  DoctorModel({
    this.id = 1,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.experience,
    required this.fee,
    required this.avatarColor,
    this.online = true,
    this.about = '',
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    Color parseColor(dynamic colorValue) {
      if (colorValue == null) return const Color(0xFF0D9488);
      if (colorValue is int) return Color(colorValue);
      final str = colorValue.toString().replaceAll('#', '');
      if (str.length == 6) {
        return Color(int.parse('FF$str', radix: 16));
      } else if (str.length == 8) {
        return Color(int.parse(str, radix: 16));
      }
      return const Color(0xFF0D9488);
    }

    return DoctorModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      hospital: json['hospital'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '4.8') ?? 4.8,
      experience: json['experience'] ?? '5 yrs',
      fee: json['fee'] ?? '₹500',
      avatarColor: parseColor(json['avatar_color']),
      online: json['online'] == true || json['online'] == 1 || json['online'] == '1',
      about: json['about'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'hospital': hospital,
      'rating': rating,
      'experience': experience,
      'fee': fee,
      'avatar_color': '#${avatarColor.value.toRadixString(16).substring(2)}',
      'online': online,
      'about': about,
    };
  }
}

class CategoryModel {
  final String title;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.title,
    required this.icon,
    required this.color,
  });
}
