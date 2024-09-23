import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiService {
  final String baseUrl = 'https://matrimony.bwsoft.in/api/auth/';

  Future<List<dynamic>> fetchNewUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      final response = await http.get(
        Uri.parse('${baseUrl}new-users/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // Adjust the key based on the actual response structure
        if (responseBody is Map<String, dynamic> &&
            responseBody.containsKey('data')) {
          return responseBody['data'];
        } else {
          throw Exception('Invalid response structure: "data" key not found');
        }
      } else {
        throw Exception('Failed to load new users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching new users: $e');
    }
  }

  Future<List<dynamic>> fetchNearbyMatches() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      final response = await http.get(
        Uri.parse('${baseUrl}nearby-matches/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // Adjust the key based on the actual response structure
        if (responseBody is Map<String, dynamic> &&
            responseBody.containsKey('data')) {
          return responseBody['data'];
        } else {
          throw Exception('Invalid response structure: "data" key not found');
        }
      } else {
        throw Exception(
            'Failed to load nearby matches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nearby matches: $e');
    }
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(
        //       profile['profile_picture'] ?? 'assets/images/pic3.jpg'),
        // ),
        title: Text(profile['username'] ?? 'Unknown'),
        subtitle: Text(profile['occupation'] ?? 'No Occupation'),
      ),
    );
  }
}

class ProfileList extends StatelessWidget {
  final List<dynamic> profiles;

  const ProfileList({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return ProfileCard(profile: profiles[index]);
      },
    );
  }
}
