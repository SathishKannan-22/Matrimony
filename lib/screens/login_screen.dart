// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/screens/forgot_password_screen.dart';
import 'package:matrimony/screens/home_screen.dart';
import 'package:matrimony/screens/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String _accessToken = '';
  late int userId;
  bool _obscureText = true;

  Future<void> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    const String refreshTokenUrl =
        'https://matrimony.bwsoft.in/api/auth/token/';

    try {
      final response = await http.post(
        Uri.parse(refreshTokenUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refresh': refreshToken ?? '',
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        _accessToken = responseBody['access_token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', _accessToken);
      } else {
        setState(() {
          _errorMessage = 'Failed to refresh token';
        });
        if (kDebugMode) {
          print('Token refresh failed, status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while refreshing token';
      });
      if (kDebugMode) {
        print('Token refresh failed with error: $e');
      }
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    const String apiUrl = 'https://matrimony.bwsoft.in/api/auth/login/';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        _accessToken = responseBody['access_token'];
        String refreshToken = responseBody['refresh_token'];
        userId = responseBody['id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('accessToken', _accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setInt('id', userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        if (response.statusCode == 401) {
          // Unauthorized, maybe token expired
          await _refreshToken(); // Try refreshing the token
          // Optionally retry login here if needed
        }
        setState(() {
          _errorMessage = 'Login failed, please try again';
        });
        if (kDebugMode) {
          print('Login failed, status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred, Check your internet';
      });
      if (kDebugMode) {
        print('Login failed with error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: const Text('Welcome Back'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/images/pic1.png',
              height: 80,
              width: 80,
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/Login.png',
                  height: 250,
                  width: 250,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.amber, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.amber, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                    },
                    child: const Text(
                      'forgot password ?',
                      style: TextStyle(color: Colors.amber),
                    )),
                const SizedBox(
                  height: 40,
                ),
                if (_isLoading)
                  const CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                if (_errorMessage.isNotEmpty)
                  Text(_errorMessage,
                      style: const TextStyle(color: Colors.red)),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.black,
                        ),
                        Text(
                          '  Login',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
