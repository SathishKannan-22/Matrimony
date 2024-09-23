// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/screens/otp_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrimony/screens/welcome_screen.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  String _errorMessage = '';
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedMaritalStatus;
  String? _selectedDosham;
  String? _selectedOther;
  String? _selectedClass;
  String? _selectedWorking;
  String? _selectedType;
  DateTime? _selectedDate;
  final picker = ImagePicker();
  PlatformFile? _pickedFile;
  File? _image;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _hightController = TextEditingController();
  final TextEditingController _addBioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addmobileController = TextEditingController();
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _zodiacController = TextEditingController();
  final TextEditingController _motherTongueController = TextEditingController();
  final TextEditingController _starController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  final TextEditingController _physicalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _hightController.dispose();
    _addBioController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    _mobileController.dispose();
    _addmobileController.dispose();
    _casteController.dispose();
    _zodiacController.dispose();
    _motherTongueController.dispose();
    _starController.dispose();
    _incomeController.dispose();
    _educationController.dispose();
    _jobRoleController.dispose();
    _interestsController.dispose();
    _physicalController.dispose();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    var statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ].request();

    var allGranted = statuses.values.every((status) => status.isGranted);

    if (allGranted) {
      if (kDebugMode) {
        print('Permissions granted');
      }
    } else {
      if (kDebugMode) {
        print('Permissions not granted');
      }
    }
  }

  Future<void> registerUser() async {
    var url = Uri.parse('https://matrimony.bwsoft.in/api/auth/register/');

    var dateFormatter = DateFormat('yyyy-MM-dd');
    var formattedDate =
        _selectedDate != null ? dateFormatter.format(_selectedDate!) : null;

    var request = http.MultipartRequest('POST', url);

    request.fields['first_name'] = _firstNameController.text;
    request.fields['last_name'] = _lastNameController.text;
    request.fields['username'] = _userNameController.text;
    request.fields['gender'] = _selectedGender ?? '';
    request.fields['date_of_birth'] = formattedDate ?? '';
    request.fields['height'] = _hightController.text;
    request.fields['about_me'] = _addBioController.text;
    request.fields['address'] = _addressController.text;
    request.fields['city_living_in'] = _cityController.text;
    request.fields['state_living_in'] = _stateController.text;
    request.fields['country'] = _countryController.text;
    request.fields['email'] = _emailController.text;
    request.fields['password'] = _passwordController.text;
    request.fields['password2'] = _password2Controller.text;
    request.fields['physical_status'] = _physicalController.text;
    request.fields['mobile'] = _mobileController.text;
    request.fields['additional_mobile_number'] = _addmobileController.text;
    request.fields['marital_status'] = _selectedMaritalStatus ?? '';
    request.fields['religion'] = _selectedReligion ?? '';
    request.fields['caste'] = _casteController.text;
    request.fields['zodiac_sign'] = _zodiacController.text;
    request.fields['mother_tongue'] = _motherTongueController.text;
    request.fields['star'] = _starController.text;
    request.fields['dosham'] = _selectedDosham ?? '';
    request.fields['willing_other'] = _selectedOther ?? '';
    request.fields['family_status'] = _selectedClass ?? '';
    request.fields['family_type'] = _selectedType ?? '';
    request.fields['annual_income'] = _incomeController.text;
    request.fields['education'] = _educationController.text;
    request.fields['employed_in'] = _selectedWorking ?? '';
    request.fields['occupation'] = _jobRoleController.text;
    request.fields['interests'] = _interestsController.text;
    if (_pickedFile != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'profile_picture',
        _pickedFile!.bytes!,
        filename: _pickedFile!.name,
      ));
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('Registration successful');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OtpScreen(),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Registration failed, please try again';
        });
        if (kDebugMode) {
          print('Registration failed with status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error registering user: $error');
      }
      setState(() {
        _errorMessage = 'Enter valid input, please try again';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select Image Source"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.camera);
                            setState(() {
                              if (pickedFile != null) {
                                _image = File(pickedFile.path);
                              } else {
                                if (kDebugMode) {
                                  print('No image selected.');
                                }
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.amber,
                          )),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            if (pickedFile != null) {
                              _image = File(pickedFile.path);
                            } else {
                              if (kDebugMode) {
                                print('No image selected.');
                              }
                            }
                          });
                        },
                        child: const Text(
                          "Camera",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              if (pickedFile != null) {
                                _image = File(pickedFile.path);
                              } else {
                                if (kDebugMode) {
                                  print('No image selected.');
                                }
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.photo,
                            color: Colors.amber,
                          )),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            if (pickedFile != null) {
                              _image = File(pickedFile.path);
                            } else {
                              if (kDebugMode) {
                                print('No image selected.');
                              }
                            }
                          });
                        },
                        child: const Text(
                          "Gallery",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.amber,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _handleRadioValueWorking(String? value) {
    setState(() {
      _selectedWorking = value;
    });
  }

  void _handleRadioValueClass(String? value) {
    setState(() {
      _selectedClass = value;
    });
  }

  void _handleRadioValueReligion(String? value) {
    setState(() {
      _selectedReligion = value;
    });
  }

  void _handleRadioValueType(String? value) {
    setState(() {
      _selectedType = value;
    });
  }

  void _handleRadioValueDosham(String? value) {
    setState(() {
      _selectedDosham = value;
    });
  }

  void _handleRadioValueOther(String? value) {
    setState(() {
      _selectedOther = value;
    });
  }

  void _handleRadioValueChange(String? value) {
    setState(() {
      _selectedGender = value;
    });
  }

  void _handleRadioValue(String? value) {
    setState(() {
      _selectedMaritalStatus = value;
    });
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
                builder: (context) => const WelcomeScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: const Text(
          'Registration',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Let's begin with the basic details",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Text('First Name'),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                    hintText: 'Enter your first name',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Last Name'),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                    hintText: 'Enter your last name',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('User Name'),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                    hintText: 'Enter your user name',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: _handleRadioValueChange,
                        activeColor: Colors.amber,
                      ),
                      const Text('Male'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: _handleRadioValueChange,
                        activeColor: Colors.amber,
                      ),
                      const Text('Female'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Other',
                        groupValue: _selectedGender,
                        onChanged: _handleRadioValueChange,
                        activeColor: Colors.amber,
                      ),
                      const Text('Other'),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const Text(
                'Date of Birth',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Choose Date'),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDate != null
                        ? _selectedDate!.toLocal().toString().split(' ')[0]
                        : '',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const Text('Physical Status'),
              TextField(
                controller: _physicalController,
                decoration: InputDecoration(
                    hintText: 'Enter your physical status',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(width: 10),
              const Text('Height'),
              TextField(
                controller: _hightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter your height',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Mother tongue'),
              TextField(
                controller: _motherTongueController,
                decoration: InputDecoration(
                    hintText: 'Enter your mother tongue',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Add bio'),
              TextField(
                controller: _addBioController,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: 'Enter your bio',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Location & details',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Address'),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'Enter your address',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('City'),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                    hintText: 'Enter your city',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('State'),
              TextField(
                controller: _stateController,
                decoration: InputDecoration(
                    hintText: 'Enter your state',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Country'),
              TextField(
                controller: _countryController,
                decoration: InputDecoration(
                    hintText: 'Enter your country',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Email'),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Password'),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: 'Enter password for matrimony',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Confirm Password'),
              TextField(
                controller: _password2Controller,
                decoration: InputDecoration(
                    hintText: 'Enter your confirm password',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Mobile'),
              TextField(
                keyboardType: TextInputType.number,
                controller: _mobileController,
                decoration: InputDecoration(
                    hintText: 'Enter your mobile',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Additional Mobile'),
              TextField(
                keyboardType: TextInputType.number,
                controller: _addmobileController,
                decoration: InputDecoration(
                    hintText: 'Enter your additional mobile',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Relationship',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Single',
                        groupValue: _selectedMaritalStatus,
                        onChanged: _handleRadioValue,
                        activeColor: Colors.amber,
                      ),
                      const Text('Single'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Married',
                        groupValue: _selectedMaritalStatus,
                        onChanged: _handleRadioValue,
                        activeColor: Colors.amber,
                      ),
                      const Text('Married'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Divorced',
                        groupValue: _selectedMaritalStatus,
                        onChanged: _handleRadioValue,
                        activeColor: Colors.amber,
                      ),
                      const Text('Divorced'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Widowed',
                        groupValue: _selectedMaritalStatus,
                        onChanged: _handleRadioValue,
                        activeColor: Colors.amber,
                      ),
                      const Text('Widowed'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Cultural Background',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Religion',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Hindu',
                        groupValue: _selectedReligion,
                        onChanged: _handleRadioValueReligion,
                        activeColor: Colors.amber,
                      ),
                      const Text('Hindu'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Muslim',
                        groupValue: _selectedReligion,
                        onChanged: _handleRadioValueReligion,
                        activeColor: Colors.amber,
                      ),
                      const Text('Muslim'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'christian',
                        groupValue: _selectedReligion,
                        onChanged: _handleRadioValueReligion,
                        activeColor: Colors.amber,
                      ),
                      const Text('Cristian'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Sikh',
                        groupValue: _selectedReligion,
                        onChanged: _handleRadioValueReligion,
                        activeColor: Colors.amber,
                      ),
                      const Text('Sikh'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Other',
                        groupValue: _selectedReligion,
                        onChanged: _handleRadioValueReligion,
                        activeColor: Colors.amber,
                      ),
                      const Text('Other'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Caste'),
              TextField(
                controller: _casteController,
                decoration: InputDecoration(
                    hintText: 'Enter your caste',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Zodiac sign'),
              TextField(
                controller: _zodiacController,
                decoration: InputDecoration(
                    hintText: 'Enter your zodiac sign',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Star'),
              TextField(
                controller: _starController,
                decoration: InputDecoration(
                    hintText: 'Enter your Star',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Dosham',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Yes',
                        groupValue: _selectedDosham,
                        onChanged: _handleRadioValueDosham,
                        activeColor: Colors.amber,
                      ),
                      const Text('Yes'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'No',
                        groupValue: _selectedDosham,
                        onChanged: _handleRadioValueDosham,
                        activeColor: Colors.amber,
                      ),
                      const Text('No'),
                    ],
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    'Willing others',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Yes',
                        groupValue: _selectedOther,
                        onChanged: _handleRadioValueOther,
                        activeColor: Colors.amber,
                      ),
                      const Text('Yes'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'No',
                        groupValue: _selectedOther,
                        onChanged: _handleRadioValueOther,
                        activeColor: Colors.amber,
                      ),
                      const Text('No'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Social Class',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Upper',
                        groupValue: _selectedClass,
                        onChanged: _handleRadioValueClass,
                        activeColor: Colors.amber,
                      ),
                      const Text('Upper'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Middle-Upper',
                        groupValue: _selectedClass,
                        onChanged: _handleRadioValueClass,
                        activeColor: Colors.amber,
                      ),
                      const Text('Middle'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Middle-Lower',
                        groupValue: _selectedClass,
                        onChanged: _handleRadioValueClass,
                        activeColor: Colors.amber,
                      ),
                      const Text('Working'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Lower',
                        groupValue: _selectedClass,
                        onChanged: _handleRadioValueClass,
                        activeColor: Colors.amber,
                      ),
                      const Text('Lower'),
                    ],
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    'Family Type',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Joint',
                        groupValue: _selectedType,
                        onChanged: _handleRadioValueType,
                        activeColor: Colors.amber,
                      ),
                      const Text('Joint'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Nuclear',
                        groupValue: _selectedType,
                        onChanged: _handleRadioValueType,
                        activeColor: Colors.amber,
                      ),
                      const Text('Nuclear'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Annual income'),
              TextField(
                keyboardType: TextInputType.number,
                controller: _incomeController,
                decoration: InputDecoration(
                    hintText: 'Enter your annual income',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Education'),
              TextField(
                controller: _educationController,
                decoration: InputDecoration(
                    hintText: 'Enter your education',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Working in',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Private',
                        groupValue: _selectedWorking,
                        onChanged: _handleRadioValueWorking,
                        activeColor: Colors.amber,
                      ),
                      const Text('Private'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Goverment',
                        groupValue: _selectedWorking,
                        onChanged: _handleRadioValueWorking,
                        activeColor: Colors.amber,
                      ),
                      const Text('Goverment'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Business',
                        groupValue: _selectedWorking,
                        onChanged: _handleRadioValueWorking,
                        activeColor: Colors.amber,
                      ),
                      const Text('Business'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'Entrepreneur',
                        groupValue: _selectedWorking,
                        onChanged: _handleRadioValueWorking,
                        activeColor: Colors.amber,
                      ),
                      const Text('Entrepreneur'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Job Role'),
              TextField(
                controller: _jobRoleController,
                decoration: InputDecoration(
                    hintText: 'Enter your job role',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text('Interests'),
              TextField(
                controller: _interestsController,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'Enter your interests',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 165, 164, 164)),
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
                    contentPadding: const EdgeInsets.all(15)),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.black,
                            ),
                            Text(
                              'Choose image',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (_image == null && _pickedFile == null)
                const Center(child: Text('No image selected.'))
              else if (kIsWeb)
                Center(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.memory(_pickedFile!.bytes!)),
                )
              else
                Center(
                    child: SizedBox(
                        width: 100, height: 100, child: Image.file(_image!))),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              if (_errorMessage.isNotEmpty)
                Center(
                    child: Text(_errorMessage,
                        style: const TextStyle(color: Colors.red))),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        _isLoading ? null : registerUser();
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.black),
                      )),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
