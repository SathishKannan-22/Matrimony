// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/screens/forgot_password_screen.dart';
import 'package:matrimony/screens/login_screen.dart';

class OtpForgotPassword extends StatefulWidget {
  final String email;

  const OtpForgotPassword({super.key, required this.email});

  @override
  State<OtpForgotPassword> createState() => _OtpForgotPasswordState();
}

class _OtpForgotPasswordState extends State<OtpForgotPassword> {
  bool _obscureText = true;
  final int _otpLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    final url = Uri.parse(
        'https://matrimony.bwsoft.in/api/auth/password-reset-confirm/');
    final otp = _controllers.map((controller) => controller.text).join();
    final newPassword = _newPasswordController.text;

    try {
      final response = await http.post(url, body: {
        'email': widget.email,
        'otp': otp,
        'new_password': newPassword,
      });

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Password reset successfully');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password changed successfully',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amber,
          ),
        );
      } else {
        if (kDebugMode) {
          print(
              'Failed to reset password. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to reset password:Try again',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amber,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting password: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error resetting password. Please try again.'),
        ),
      );
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
                builder: (context) => const ForgotPassword(),
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
                  'assets/images/Reset password.png',
                  height: 250,
                  width: 250,
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_otpLength, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      child: SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _controllers[index],
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < _otpLength - 1) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter your new password',
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
                      resetPassword(context);
                    },
                    child: const Text(
                      'Reset Password',
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
