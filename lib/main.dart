import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/screens/home_screen.dart';
import 'package:matrimony/screens/onbording1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:matrimony/service/notification_service.dart';
import 'package:matrimony/firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// function to listen to background changes
Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    if (kDebugMode) {
      print("Some notification Received in background...");
    }
  }
}

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize firebase messaging
  await PushNotifications.init();

  // initialize local notifications
  // dont use local notifications for web platform
  if (!kIsWeb) {
    await PushNotifications.localNotiInit();
  }

  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      if (kDebugMode) {
        print("Background Notification Tapped");
      }
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    }
  });

  // to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    if (kDebugMode) {
      print("Got a message in foreground");
    }
    if (message.notification != null) {
      if (kIsWeb) {
        showNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
        );
      } else {
        PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData,
        );
      }
    }
  });

  // for handling in terminated state
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    if (kDebugMode) {
      print("Launched from terminated state");
    }
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }

  // Get the current FCM token
  FirebaseMessaging.instance.getToken().then((token) {
    if (kDebugMode) {
      print("FCM Token: $token");
    }
    // Send the token to your server or save it for later use
  });

  // Monitor token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    if (kDebugMode) {
      print("Refreshed FCM Token: $newToken");
    }
    // Send the new token to your server or update it in your database
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.amber,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.amber,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _refreshToken();
    _checkLoginStatus();
  }

  Future<void> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) return;

    const String refreshTokenUrl =
        'https://matrimony.bwsoft.in/api/auth/token/refresh/';

    try {
      final response = await http.post(
        Uri.parse(refreshTokenUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refresh': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String accessToken = responseBody['access'];
        await prefs.setString('accessToken', accessToken);
        if (kDebugMode) {
          print('accessToken: $accessToken');
        }
      } else {
        if (kDebugMode) {
          print('Token refresh failed, status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh failed with error: $e');
      }
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Future.delayed(const Duration(seconds: 2), () {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Onboarding1()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/pic1.png',
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
