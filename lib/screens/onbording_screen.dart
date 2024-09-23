// import 'package:flutter/material.dart';
// import 'package:matrimony/screens/welcome_screen.dart';

// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   PageController _pageController = PageController();
//   int _currentPage = 0;

//   List<Widget> _buildPageIndicator() {
//     List<Widget> list = [];
//     for (int i = 0; i < 3; i++) {
//       list.add(i == _currentPage ? _indicator(true) : _indicator(false));
//     }
//     return list;
//   }

//   Widget _indicator(bool isActive) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 150),
//       margin: EdgeInsets.symmetric(horizontal: 4.0),
//       height: 8.0,
//       width: isActive ? 20.0 : 10.0,
//       decoration: BoxDecoration(
//         color: isActive ? Color.fromARGB(255, 243, 227, 0) : Colors.grey,
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (int page) {
//                   setState(() {
//                     _currentPage = page;
//                   });
//                 },
//                 children: <Widget>[
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Stack(
//                         children: [
//                           // Positioned(
//                           //     bottom: 20,
//                           //     left: 20,
//                           //     child: TextButton(
//                           //         onPressed: () {
//                           //           Navigator.pushReplacement(
//                           //               context,
//                           //               MaterialPageRoute(
//                           //                   builder: (context) =>
//                           //                       const WelcomeScreen()));
//                           //         },
//                           //         child: const Text(
//                           //           'Skip',
//                           //           style: TextStyle(
//                           //               color:
//                           //                   Color.fromARGB(255, 148, 147, 147),
//                           //               fontSize: 20),
//                           //         ))),
//                           // Positioned(
//                           //   bottom: 20,
//                           //   right: 20,
//                           //   child: SizedBox(
//                           //     height: 50,
//                           //     child: ElevatedButton(
//                           //       style: ElevatedButton.styleFrom(
//                           //         backgroundColor:
//                           //             const Color.fromARGB(255, 243, 227, 0),
//                           //         shape: const CircleBorder(),
//                           //       ),
//                           //       onPressed: () {
//                           //         Navigator.pushReplacement(
//                           //             context,
//                           //             MaterialPageRoute(
//                           //                 builder: (context) =>
//                           //                     const WelcomeScreen()));
//                           //       },
//                           //       child: const Icon(
//                           //         Icons.arrow_forward_ios_rounded,
//                           //         size: 25,
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 'assets/images/mrg.png',
//                                 height: 250,
//                                 width: 250,
//                               ),
//                               const SizedBox(
//                                 height: 30,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: RichText(
//                                   text: const TextSpan(
//                                     style: TextStyle(
//                                       fontSize: 20.0,
//                                       color: Colors.black,
//                                     ),
//                                     children: <TextSpan>[
//                                       TextSpan(
//                                         text: 'Welcome to',
//                                         style: TextStyle(
//                                           fontSize: 15.0,
//                                           fontWeight: FontWeight.bold,
//                                           color: Color.fromARGB(255, 0, 0, 0),
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: ' Our App!',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           // fontStyle: FontStyle.italic,
//                                           color:
//                                               Color.fromARGB(255, 243, 227, 0),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 30,
//                               ),
//                               const Text(
//                                 '''Your journey towards a stunning celebration of the together starts here with OUR APP as every love story deserves a beautifull begining
//                   ''',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   OnboardingPage(
//                     title: "Discover",
//                     description: "This is the second onboarding screen.",
//                     image: Icons.access_alarm,
//                   ),
//                   OnboardingPage(
//                     title: "Enjoy",
//                     description: "This is the third onboarding screen.",
//                     image: Icons.accessibility,
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: _buildPageIndicator(),
//             ),
//             _currentPage != 2
//                 ? Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: FloatingActionButton(
//                         onPressed: () {
//                           _pageController.nextPage(
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeIn,
//                           );
//                         },
//                         child: Icon(Icons.arrow_forward),
//                       ),
//                     ),
//                   )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OnboardingPage extends StatelessWidget {
//   final String title;
//   final String description;
//   final IconData image;

//   OnboardingPage(
//       {required this.title, required this.description, required this.image});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(40.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(
//             image,
//             size: 100.0,
//             color: Colors.blue,
//           ),
//           SizedBox(height: 30.0),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 24.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 15.0),
//           Text(
//             description,
//             style: TextStyle(
//               fontSize: 16.0,
//               color: Colors.grey,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
