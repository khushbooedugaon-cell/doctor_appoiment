import 'dart:ui';
import 'package:flutter/material.dart';

class DoctorModel {
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final String experience;
  final String fee;
  final Color avatarColor;

  DoctorModel({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.experience,
    required this.fee,
    required this.avatarColor,
  });
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