import 'package:flutter/material.dart';
import 'package:matrimony/screens/login_screen.dart';
import 'package:matrimony/screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/mrg.png',
              height: 250,
              width: 250,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Welcome to',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const Text(
              'OUR APP',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'New to OUR APP ?',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 7,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.black,
                      ),
                      Text(
                        '  Create Account',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Already have an account?',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 7,
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(
                    color: Colors.amber,
                    width: 1,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
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
    );
  }
}
