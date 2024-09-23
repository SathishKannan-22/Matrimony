import 'package:flutter/material.dart';
import 'package:matrimony/model/profile_model.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        shadowColor: Colors.amber,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(
              color: Color.fromARGB(255, 218, 218, 218), width: 1),
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
                      child: Image.asset(
                        'assets/images/pic3.jpg',
                        fit: BoxFit.cover,
                        height: 400,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (profile.gender == 'Female')
                        const Icon(
                          Icons.female_rounded,
                          color: Colors.amber,
                          size: 35,
                        ),
                      if (profile.gender == 'Male')
                        const Icon(
                          Icons.male_rounded,
                          color: Colors.blue,
                          size: 35,
                        ),
                      Text(
                        profile.username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildProfileInfoRow(
                      icon: Icons.height_rounded,
                      label: 'Height',
                      value: profile.height),
                  _buildProfileInfoRow(
                      icon: Icons.school_outlined,
                      label: 'Education',
                      value: profile.education),
                  _buildProfileInfoRow(
                      icon: Icons.work_outline_rounded,
                      label: 'Job',
                      value: profile.occupation),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(
                                color: Colors.amber,
                                width: 1,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Not Interested',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
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
                            onPressed: () {},
                            child: const Text(
                              'View Profile',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.amber,
                  size: 30,
                ),
                onPressed: onLikeToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.amber,
          ),
          Text(
            '  $label - $value',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
