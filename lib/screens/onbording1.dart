import 'package:flutter/material.dart';
import 'package:matrimony/screens/onbording2.dart';
import 'package:matrimony/screens/welcome_screen.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                  bottom: 20,
                  left: 20,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()));
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            color: Color.fromARGB(255, 148, 147, 147),
                            fontSize: 20),
                      ))),
              Positioned(
                bottom: 20,
                right: 20,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Onboarding2()));
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 25,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/mrg.png',
                    height: 250,
                    width: 250,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Welcome to',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          TextSpan(
                            text: ' Our App!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '''Your journey towards a stunning celebration of the together starts here with OUR APP as every love story deserves a beautifull begining
                  ''',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
