import 'package:custom_widget_annotation/custom_widget_annotation.dart';
import 'package:flutter/material.dart';

part '../widgets/model/user_details.g.dart';

enum UserType { nonVerified, verified }

@customWidget
class UserDetails {
  UserDetails(
      {required this.firstName,
      this.lastName,
      this.userId,
      this.uniqueHash = 0.0,
      this.isActive = false,
      this.imagePath,
      this.lastLogin,
      required this.userType});

  final String firstName;
  final String? lastName;
  final bool isActive;
  final int? userId;
  final double uniqueHash;
  final UserType userType;
  final String? imagePath;
  final DateTime? lastLogin;
}
