import 'package:flutter/material.dart';
import 'package:matrimony/screens/onbording3.dart';
import 'package:matrimony/screens/welcome_screen.dart';

class Onboarding2 extends StatefulWidget {
  const Onboarding2({super.key});

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
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
                              builder: (context) => const Onboarding3()));
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
                    'assets/images/mrg1.png',
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
                            text: 'Fusing Love &',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          TextSpan(
                            text: ' Compatibility !',
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
                    '''Explore a platform assigned for losting unions where every match is a harmonious fusion with bourdless love and timeless compatibility !   ''',
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
