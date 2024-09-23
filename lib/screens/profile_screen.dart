import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final int profileId; // Add this line to accept profile ID

  const ProfileScreen({super.key, required this.profileId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic> _profileDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileDetails();
  }

  Future<void> _fetchProfileDetails() async {
    final String profileUrl =
        'https://matrimony.bwsoft.in/api/auth/profile-edit/${widget.profileId}';

    try {
      final response = await http.get(Uri.parse(profileUrl));

      if (response.statusCode == 200) {
        setState(() {
          _profileDetails = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        // Handle error
        if (kDebugMode) {
          print('Failed to fetch profile details');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      if (kDebugMode) {
        print('Error fetching profile details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Matches',
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
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            '${_profileDetails['profile_picture']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_profileDetails['username']}, ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                '${_profileDetails['age']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          Text(
                            '${_profileDetails['occupation']}, ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'About',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Divider(
                              thickness: 4,
                              color: Colors.amber,
                            ),
                          ),
                          Text(
                            '${_profileDetails['about_me']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Interests',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Divider(
                              thickness: 4,
                              color: Colors.amber,
                            ),
                          ),
                          Text(
                            '${_profileDetails['interests']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Basic Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Divider(
                              thickness: 4,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 245, 214),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.date_range_rounded,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Born on',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['date_of_birth']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 245, 214),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Marital status',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['marital_status']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 245, 214),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Lives in',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    'Lives in ${_profileDetails['city_living_in']}, ${_profileDetails['state_living_in']}.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 245, 214),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.menu_book_outlined,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Caste & Religion',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['caste']}, ${_profileDetails['religion']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 245, 214),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Zodiac & star',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['zodiac_sign']}, ${_profileDetails['star']}.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 245, 214),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.language_rounded,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mother tongue',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['mother_tongue']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Contact details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Divider(
                              thickness: 4,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 61, 61, 61),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.phone,
                                    color: Color.fromARGB(255, 255, 191, 0),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact number',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['mobile']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 61, 61, 61),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.phone_iphone_rounded,
                                    color: Color.fromARGB(255, 255, 191, 0),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Additional number',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['additional_mobile_number']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 61, 61, 61),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.mail_rounded,
                                    color: Color.fromARGB(255, 255, 191, 0),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['email']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Family details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Divider(
                              thickness: 4,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.family_restroom_rounded,
                                    color: Color.fromARGB(255, 61, 61, 61),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Family type',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['family_type']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.stacked_bar_chart,
                                    color: Color.fromARGB(255, 61, 61, 61),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Family Status',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['family_status']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.handshake_outlined,
                                    color: Color.fromARGB(255, 61, 61, 61),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Willings to other cummunity',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['willing_other']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Career & Education',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Divider(
                              thickness: 4,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.workspace_premium_outlined,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Employed in',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['employed_in']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.cases_outlined,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Occupation',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['occupation']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.school,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Education',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['education']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.currency_exchange_rounded,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Annual income',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    '${_profileDetails['annual_income']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // Text('Profile Details: $_profileDetails'),
                        ],
                      ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
