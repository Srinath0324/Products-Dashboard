import 'package:flutter/material.dart';

/// Model for dashboard statistics
class DashboardStats {
  final String title;
  final int value;
  final String? subtitle;
  final IconData? icon;

  const DashboardStats({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
  });

  String get displayValue => value.toString();
}
