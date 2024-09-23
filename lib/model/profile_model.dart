import 'package:flutter/foundation.dart';

class Profile {
  final String username;
  final String gender;
  final String height;
  final String education;
  final String occupation;
  final String age;

  Profile({
    required this.username,
    required this.gender,
    required this.height,
    required this.education,
    required this.occupation,
    required this.age,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    try {
      return Profile(
        // username: json['username'] ?? 'Unknown Username',
        gender: json['gender'] ?? '',
        height: json['height'] ?? '',
        education: json['education'] ?? '',
        occupation: json['occupation'] ?? '',
        age: json['age'] ?? '',
        username: json['username'] as String,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing profile: $json with error: $e');
      }
      rethrow;
    }
  }
}
