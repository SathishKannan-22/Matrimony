// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:matrimony/screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int _otpLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> verifyOtp() async {
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == _otpLength) {
      var response = await http.post(
        Uri.parse('https://matrimony.bwsoft.in/api/auth/verify-otp/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print('OTP Verified: $data');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Failed to verify OTP: ${response.statusCode}');
        }
      }
    } else {
      if (kDebugMode) {
        print('Please enter the complete OTP');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const WelcomeScreen(),
            //   ),
            // );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: const Text(
          'Verify OTP',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              color: const Color.fromARGB(255, 207, 207, 207),
              height: 1.0,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/otp.png',
              height: 300,
              width: 300,
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
                onPressed: verifyOtp,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: Colors.black,
                    ),
                    Text(
                      '  Verify OTP',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
