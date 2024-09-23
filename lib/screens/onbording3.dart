import 'package:flutter/material.dart';
import 'package:matrimony/screens/welcome_screen.dart';

class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
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
                right: 20,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()));
                    },
                    child: const Row(
                      children: [
                        Text(
                          "Let's Go ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 15,
                        ),
                      ],
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/mrg2.png',
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
                            text: 'All round',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          TextSpan(
                            text: ' Verification !',
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
                    '''At OUR APP, We assure your safety to make sure you can confidently intract with others through our all round verfication''',
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
