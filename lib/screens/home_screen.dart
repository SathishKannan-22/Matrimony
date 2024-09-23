// ignore_for_file: use_build_context_synchronously,
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/screens/forgot_password_screen1.dart';
import 'package:matrimony/screens/login_screen.dart';
import 'package:matrimony/screens/profile_edit_screen.dart';
import 'package:matrimony/screens/profile_screen.dart';
import 'package:matrimony/service/profile_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;

  const HomeScreen({super.key, this.selectedIndex = 0});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Razorpay _razorpay;
  int _selectedIndex = 0;
  bool _isLoading = false;
  Map<String, dynamic>? _profile;
  List<dynamic> newUsers = [];
  List<dynamic> nearbyMatches = [];
  List<dynamic> _profiles = [];
  List<dynamic> _favorites = [];
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _newUsersFuture;
  late Future<List<dynamic>> _nearbyMatchesFuture;
  bool isLoadingNewUsers = true;
  bool isLoadingNearbyMatches = true;
  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchProfiles();
    _fetchFavorites();
    _newUsersFuture = _apiService.fetchNewUsers();
    _nearbyMatchesFuture = _apiService.fetchNearbyMatches();
    _checkForSubscriptions();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
Fluttertoast.showToast(msg: "Payment Success" + response.paymentId!,toastLength: Toast.LENGTH_SHORT);
    if (kDebugMode) {
      print("Payment Success: ${response.paymentId}");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
Fluttertoast.showToast(msg: "Payment Fail" + response.message!,toastLength: Toast.LENGTH_SHORT);

    if (kDebugMode) {
      print("Payment Error: ${response.code} - ${response.message}");
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
Fluttertoast.showToast(msg: "External Wallet" + response.walletName!,toastLength: Toast.LENGTH_SHORT);

    if (kDebugMode) {
      print("External Wallet: ${response.walletName}");
    }
  }

  void openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': 50000,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '9123456789', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<dynamic>> fetchSubscriptionPackages() async {
    final response = await http.get(Uri.parse(
        'https://matrimony.bwsoft.in/api/auth/subscription-packages/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load subscription packages');
    }
  }

  void showSubscriptionPopup(BuildContext context, List<dynamic> packages) {
    List<Color> containerColors = [
      const Color.fromARGB(255, 80, 80, 80),
      const Color.fromARGB(255, 141, 141, 141),
      const Color.fromARGB(255, 219, 175, 1),
      Colors.purple,
      Colors.orange,
    ];

    List<Color> iconColors = [
      const Color.fromARGB(255, 255, 215, 0),
      const Color.fromARGB(255, 255, 196, 0),
      const Color.fromARGB(255, 213, 213, 213),
      Colors.brown,
      Colors.teal,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Color.fromARGB(255, 104, 104, 103),
          title: const Column(
            children: [
              Text(
                'Subscription',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Packages',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: packages.asMap().entries.map<Widget>((entry) {
                int index = entry.key;
                var package = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: containerColors[index % containerColors.length],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${package['subscription']['name'] ?? ''}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        Image.asset(
                          'assets/images/crown.png',
                          height: 30,
                          width: 30,
                          color: iconColors[index % iconColors.length],
                        ),
                        // Icon(
                        //   Icons.boy,
                        //   color: iconColors[index % iconColors.length],
                        // ),
                        Text(
                          '${package['duration_months'] ?? ''} Months',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Price: ${package['price'] ?? ''}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${package['description'] ?? ''}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            Center(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 40,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkForSubscriptions() async {
    try {
      List<dynamic> packages = await fetchSubscriptionPackages();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSubscriptionPopup(context, packages);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch subscription packages: $e');
      }
    }
  }

  Future<void> _fetchFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      Uri.parse('https://matrimony.bwsoft.in/api/auth/favorites/list'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        final favoritesData = jsonDecode(response.body);
        if (favoritesData is List) {
          _favorites = favoritesData;
        } else if (favoritesData is Map && favoritesData.containsKey('data')) {
          _favorites = favoritesData['data'];
        } else {
          _favorites = [];
        }
        if (kDebugMode) {
          print('Favorites: $_favorites');
        }
      });
    } else {
      if (kDebugMode) {
        print('Failed to load favorites: ${response.statusCode}');
      }
    }
  }

  Future<void> _fetchProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      Uri.parse('https://matrimony.bwsoft.in/api/auth/profile-list/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        final profilesData = jsonDecode(response.body);
        if (profilesData is List) {
          _profiles = profilesData;
        } else if (profilesData is Map && profilesData.containsKey('data')) {
          _profiles = profilesData['data'];
        } else {
          _profiles = [];
        }
        if (kDebugMode) {
          print('Profiles: $_profiles');
        }
      });
    } else {
      if (kDebugMode) {
        print('Failed to load profiles: ${response.statusCode}');
      }
    }
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    int? userId = prefs.getInt('id');

    var apiUrl = 'https://matrimony.bwsoft.in/api/auth/profile-edit/$userId';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        setState(() {
          _profile = jsonDecode(response.body);
          if (kDebugMode) {
            print('Profile: $_profile');
          }
        });
      } else {
        if (kDebugMode) {
          print('Failed to load profile: ${response.statusCode}');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Failed to load profile with error: $e');
      }
    }
  }

  Future<void> _notInterested(int index) async {
    var profile = _profiles[index];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      if (kDebugMode) {
        print('Access token is missing');
      }
      return;
    }
    final url =
        Uri.parse('https://matrimony.bwsoft.in/api/auth/not-interested/');
    final requestBody = {
      'not_interested_user_id': profile['id'],
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Profile unliked successfully');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen(selectedIndex: 1)),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile removed from the match list',
              style: TextStyle(color: Colors.amber),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        if (kDebugMode) {
          print(
              'Failed to unlike profile. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unliking profile: $e');
      }
    }
  }

  Future<void> _deleteProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      if (kDebugMode) {
        print('Access token is missing');
      }
      return;
    }
    final url =
        Uri.parse('https://matrimony.bwsoft.in/api/auth/delete-account/');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 204) {
        if (kDebugMode) {
          print('Account deleted successfully');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('isLoggedIn');
        await prefs.remove('email');
        await prefs.remove('accessToken');
        await prefs.remove('id');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account deleted successfully',
              style: TextStyle(color: Colors.amber),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        if (kDebugMode) {
          print(
              'Failed to unlike profile. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unliking profile: $e');
      }
    }
  }

  Future<void> _unlikeProfile(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      if (kDebugMode) {
        print('Access token is missing');
      }
      return;
    }
    final url = Uri.parse(
        'https://matrimony.bwsoft.in/api/auth/favorite-delete/$index');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 204 ||
          response.statusCode == 200 ||
          response.statusCode == 304) {
        if (kDebugMode) {
          print('Profile unliked successfully');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen(selectedIndex: 1)),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile removed from favorite list',
              style: TextStyle(color: Colors.amber),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        if (kDebugMode) {
          print(
              'Failed to unlike profile. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unliking profile: $e');
      }
    }
  }

  Future<void> _addToFavorites(int index) async {
    var profile = _profiles[index];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse('https://matrimony.bwsoft.in/api/auth/favorites/');
    final requestBody = {
      'favorite_user_id': profile['id'],
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('Profile added to favorites successfully');
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreen(selectedIndex: 2)));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile added to favorite list',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amber,
          ),
        );
      } else {
        if (kDebugMode) {
          print(
              'Failed to add profile to favorites. Status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding profile to favorites: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<Profile>> fetchNewProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      Uri.parse('https://matrimony.bwsoft.in/api/auth/new-users/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Profile.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  Future<List<Profile>> fetchProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      Uri.parse('https://matrimony.bwsoft.in/api/auth/nearby-matches/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Profile.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text(
            'Matrimony',
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.amber,
              ))
            : Center(
                child: _selectedIndex == 0
                    ? home()
                    : _selectedIndex == 1
                        ? _buildProfilesList()
                        : _selectedIndex == 2
                            ? _buildFavoritesList()
                            : _buildProfileView(context),
              ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? Image.asset('assets/images/home1.png',
                      height: 30, width: 30, color: Colors.amber)
                  : Image.asset('assets/images/home.png',
                      height: 30, width: 30, color: Colors.amber),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? Image.asset('assets/images/ring1.png',
                      height: 30, width: 30, color: Colors.amber)
                  : Image.asset('assets/images/ring.png',
                      height: 30, width: 30, color: Colors.amber),
              label: 'Matches',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? Image.asset('assets/images/heart1.png',
                      height: 30, width: 30, color: Colors.amber)
                  : Image.asset('assets/images/heart.png',
                      height: 30, width: 30, color: Colors.amber),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? Image.asset('assets/images/user1.png',
                      height: 30, width: 30, color: Colors.amber)
                  : Image.asset('assets/images/user.png',
                      height: 30, width: 30, color: Colors.amber),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedFontSize: 13,
          selectedItemColor: Colors.amber,
          unselectedItemColor: const Color.fromARGB(255, 208, 208, 208),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget home() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    'Nearby matches for you',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 230,
              child: FutureBuilder<List<Profile>>(
                future: fetchProfiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No profiles found'));
                  } else {
                    final profiles = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.amber,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(5),
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    profile.profileImage,
                                    fit: BoxFit.cover,
                                    height: 130,
                                    width: 130,
                                  ),
                                ),
                                Text(
                                  '${profile.firstName} ${profile.lastName}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(profile.education),
                                Text('${profile.age}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    'New matches for you',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 230,
              child: FutureBuilder<List<Profile>>(
                future: fetchNewProfiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No profiles found'));
                  } else {
                    final profiles = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.amber,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(5),
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    profile.profileImage,
                                    fit: BoxFit.cover,
                                    height: 130,
                                    width: 130,
                                  ),
                                ),
                                Text(
                                  '${profile.firstName} ${profile.lastName}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(profile.education),
                                Text('${profile.age}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                height: 440,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Talk to astrologer!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Flexible(
                        child: Text(
                          'Book a consultation with our expert astrologer.',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Flexible(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    'Get lights about your life before and after marriege.',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Flexible(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    'Get guidance on finding a life partner, doshams if any and remedirs',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Flexible(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    'Check your horoscope compatibility with matching profiles.',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            // 'assets/images/barathi.png',
                            'assets/images/astrologer.png',
                            height: 200,
                            width: 200,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () {},
                            child: const Text(
                              'Explore now',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
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
              onPressed: openCheckout,
              child: const Text(
                'Payment',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilesList() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: _profiles.length,
            itemBuilder: (context, index) {
              var profile = _profiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Card(
                  shadowColor: Colors.amber,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 218, 218, 218),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  '${profile['profile_picture']}',
                                  fit: BoxFit.cover,
                                  height: 400,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (profile['gender'] == 'Female')
                                  const Icon(
                                    Icons.female_rounded,
                                    color: Colors.amber,
                                    size: 35,
                                  ),
                                if (profile['gender'] == 'Male')
                                  const Icon(
                                    Icons.male_rounded,
                                    color: Colors.amber,
                                    size: 35,
                                  ),
                                Text(
                                  profile['username'] ?? 'Unknown Username',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.height_rounded,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    '  Height - ${profile['height'] ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.school_outlined,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    '  Education - ${profile['education'] ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.work_outline_rounded,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    '  Job - ${profile['occupation'] ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      side: const BorderSide(
                                        color: Colors.amber,
                                        width: 1,
                                      ),
                                    ),
                                    onPressed: () {
                                      _notInterested(index);
                                    },
                                    child: const Text(
                                      'Not Interested',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                              profileId: profile['id']),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View Profile',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                          onPressed: () {
                            _addToFavorites(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildFavoritesList() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              var favorite = _favorites[index]['favorite_user'];
              int userId = favorite['id'] ?? ''; // Get user ID

              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Card(
                  shadowColor: Colors.amber,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 218, 218, 218),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  '${favorite['profile_picture']}',
                                  fit: BoxFit.cover,
                                  height: 400,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (favorite['gender'] == 'Female')
                                  const Icon(
                                    Icons.female_rounded,
                                    color: Colors.amber,
                                    size: 35,
                                  ),
                                if (favorite['gender'] == 'Male')
                                  const Icon(
                                    Icons.male_rounded,
                                    color: Colors.amber,
                                    size: 35,
                                  ),
                                Text(
                                  favorite['username'] ?? 'Unknown Username',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.height_rounded,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    '  Height - ${favorite['height'] ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.school_outlined,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    '  Education - ${favorite['education'] ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.work_outline_rounded,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    '  Job - ${favorite['occupation'] ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      side: const BorderSide(
                                        color: Colors.amber,
                                        width: 1,
                                      ),
                                    ),
                                    onPressed: () {
                                      _notInterested(index);
                                    },
                                    child: const Text(
                                      'Not Interested',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                              profileId: favorite['id']),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View Profile',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.amber,
                            size: 30,
                          ),
                          onPressed: () {
                            _unlikeProfile(userId);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildProfileView(BuildContext context) {
    if (_profile == null) {
      return const Center(child: Text('Profile not found'));
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 15),
            CircleAvatar(
              backgroundImage: _profile!['profile_picture'] != null
                  ? NetworkImage(_profile!['profile_picture'] as String)
                  : const AssetImage('assets/images/pic1.png'),
              radius: 100,
            ),
            const SizedBox(height: 15),
            Text(
              '${_profile!['username']}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(_profile!['mobile']),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileEditScreen()),
                );
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 214),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.mode_edit_outlined,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
              ),
              title: const Text(
                'Edit profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.amber,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPassword1(),
                  ),
                );
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 214),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.lock_reset_outlined,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
              ),
              title: const Text(
                'Forgot password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.amber,
              ),
            ),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 214),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.privacy_tip,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
              ),
              title: const Text(
                'Privacy policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.amber,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(
                color: Colors.amber,
                thickness: 0.5,
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content:
                          const Text('Are you sure to delete this account?'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber, elevation: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber, elevation: 2),
                              onPressed: () {
                                _deleteProfile();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 214),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
              ),
              title: const Text(
                'Delete account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.amber,
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure to logout?'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber, elevation: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber, elevation: 2),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('isLoggedIn');
                                await prefs.remove('email');
                                await prefs.remove('accessToken');
                                await prefs.remove('id');
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 214),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
              ),
              title: const Text(
                'Log out',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Profile {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String gender;
  final int height;
  final String education;
  final String employedIn;
  final String profileImage;
  final int age;

  Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.height,
    required this.education,
    required this.employedIn,
    required this.profileImage,
    required this.age,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      height: json['height'],
      education: json['education'],
      employedIn: json['employed_in'],
      profileImage: json['profile_picture'],
      age: json['age'],
    );
  }
}
