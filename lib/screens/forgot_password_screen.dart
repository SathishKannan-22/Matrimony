// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/screens/otp_forgot_password.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

final TextEditingController _emailController = TextEditingController();

Future<void> sendEmail(BuildContext context) async {
  final url = Uri.parse('https://matrimony.bwsoft.in/api/auth/password-reset/');
  try {
    final response = await http.post(url, body: {
      'email': _emailController.text,
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Email sent successfully');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpForgotPassword(email: _emailController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to send otp, check email id',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amber,
          ),
        );
      if (kDebugMode) {
        print('Failed to send email. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error sending email: $e');
    }
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: const Text('Forgot Password'),
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
                Image.asset(
                  'assets/images/Forgot password.png',
                  height: 250,
                  width: 250,
                ),
                const SizedBox(
                  height: 40,
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
                    onPressed: () {
                      sendEmail(context);
                    },
                    child: const Text(
                      'Request OTP',
                      style: TextStyle(color: Colors.black),
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
