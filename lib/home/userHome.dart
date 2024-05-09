import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:su_project/config/config.dart';
import 'package:su_project/home/BarCode/viewQRCode.dart';
import 'package:su_project/home/Posts/AllPosts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Authentication/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> userData = {};
// Assuming 'currentUser' is the document ID or some identifier for user document
  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  // Initialize empty fields for user data
  final TextEditingController _collegeTextEditingController =
      TextEditingController();
  final TextEditingController _courseTextEditingController =
      TextEditingController();
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _studentIdTextEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .get()
        .then((results) {
      if (results.exists) {
        setState(() {
          _collegeTextEditingController.text = results.get('College');
          _courseTextEditingController.text =
              results.data()!['course'] as String;
          _nameTextEditingController.text =
              results.data()!['fullName'] as String;
          _studentIdTextEditingController.text =
              results.data()!['studentID'] as String;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Services",
          style: TextStyle(
            fontSize: 30,
            color: SU.backgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Route route =
                    MaterialPageRoute(builder: (_) => const loginPage());
                Navigator.pushAndRemoveUntil(context, route, (route) => false);
              });
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Divider(color: SU.primaryColor),
                    userInfoField(
                        'College', _collegeTextEditingController, Icons.school),
                    userInfoField(
                        'Course', _courseTextEditingController, Icons.book),
                    userInfoField(
                        'Name', _nameTextEditingController, Icons.person),
                    userInfoField('Student ID', _studentIdTextEditingController,
                        Icons.credit_card),
                  ],
                ),
                const Divider(color: SU.primaryColor),
                Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: GridView.count(
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 10,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 1.7, // Keeping your aspect ratio
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllPosts(),
                              ),
                            );
                          },
                          child: Card(
                            color: SU.backGroundContainerColor,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/3.png",
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                  const Text(
                                    "Post & Note",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: SU.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BarcodeScanPage(),
                              ),
                            );
                          },
                          child: Card(
                            color: SU.backGroundContainerColor,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/1.png",
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                  const Text(
                                    "Barcode",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: SU.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: SU.backGroundContainerColor,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/5.png",
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                  const Text(
                                    "Course \nEnrolled",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: SU.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: SU.backGroundContainerColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/2.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.165,
                                ),
                                const Text(
                                  "Academic \nAdvisor",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: SU.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: SU.backGroundContainerColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/6.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.165,
                                ),
                                const Text(
                                  "Course \nResults",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: SU.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: SU.backGroundContainerColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/8.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.165,
                                ),
                                const Text(
                                  "Academic \nRegsitration",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: SU.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userInfoField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: SU.primaryColor),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child:
                  Text(controller.text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
