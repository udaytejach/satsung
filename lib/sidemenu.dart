import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/loginpage.dart';
import 'package:mirror/services/api_services.dart';
import 'package:mirror/services/shared_pref_services.dart';
import 'package:mirror/sidemenu/privacy.dart';
import 'package:mirror/sidemenu/profile_page.dart';
import 'package:mirror/sidemenu/terms_conditions.dart';
import 'package:shimmer/shimmer.dart';

class SideMenu extends StatefulWidget {
  // final VoidCallback toggleTheme;
  // final bool isDarkTheme;

  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff143061),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xff143061),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 85,
                          child: Image(
                            image: AssetImage(
                              'assets/satsunglogo.png',
                            ),
                            fit: BoxFit.cover,
                          )),
                      Shimmer.fromColors(
                        baseColor: Colors.pink,
                        highlightColor: Colors.blueAccent,
                        child: Text(
                          "TRUE MIRROR",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "poppins"),
                  ),
                  onTap: () {
                    // Navigate to Terms and Conditions Screen
                    // TermsAndConditionsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.description,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "poppins"),
                  ),
                  onTap: () {
                    // Navigate to Terms and Conditions Screen
                    // TermsAndConditionsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsAndConditionsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "poppins"),
                  ),
                  onTap: () {
                    // Navigate to Privacy Policy ScreenPrivacyPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "poppins"),
                  ),
                  onTap: () {
                    Logout();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "poppins"),
                  ),
                  onTap: () {
                    // Handle Account Deletion Functionality
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Text('Do you want to Delete your Account?',
                                  style: GoogleFonts.poppins(
                                      // color: Colours.kbuttonpurple,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              Icon(
                                Icons.delete_forever_outlined,
                                size: 50,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('NO',
                                style: GoogleFonts.poppins(
                                    // color: Colours.korange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text('YES',
                                style: GoogleFonts.poppins(
                                    // color: Colours.korange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Center(
              child: Text(
            'Are you sure want to logout ?',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          )),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ))),
                  SizedBox(
                      child: ElevatedButton(
                          onPressed: () {
                            ApiService apiService = ApiService();

                            apiService.Logout(
                                    SharedPrefServices.getsessionToken()
                                        .toString())
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Logged Out successfully')),
                              );

                              SharedPrefServices.clearUserFromSharedPrefs();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );

                              // if (value.statusCode == 203 ||
                              //     value.statusCode == 401 ||
                              //     value.statusCode == 402 ||
                              //     value.statusCode == 400 ||
                              //     value.statusCode == 500 ||
                              //     value.statusCode == 422 ||
                              //     value.statusCode == 404) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content: Text('Error: ${value.message}')),
                              //   );
                              // }
                              // if (value.statusCode == 200) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content: Text('Logget Out successfully')),
                              //   );

                              //   SharedPrefServices.clearUserFromSharedPrefs();
                              //   Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => LoginScreen(),
                              //     ),
                              //   );
                              // } else {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(content: Text(value.message)));
                              // }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )))
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // delete Account
  DeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Center(
              child: Text(
            'Are you sure want to Delete Your Account?',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          )),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ))),
                  SizedBox(
                      child: ElevatedButton(
                          onPressed: () {
                            ApiService apiService = ApiService();

                            apiService
                                .deleteProfile(
                                    SharedPrefServices.getsessionToken()
                                        .toString())
                                .then((value) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //       content: Text('Logged Out successfully')),
                              // );

                              // SharedPrefServices.clearUserFromSharedPrefs();
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => LoginScreen(),
                              //   ),
                              // );

                              if (value.statusCode == 203 ||
                                  value.statusCode == 401 ||
                                  value.statusCode == 402 ||
                                  value.statusCode == 400 ||
                                  value.statusCode == 500 ||
                                  value.statusCode == 422 ||
                                  value.statusCode == 404) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${value.status}')),
                                );
                              }
                              if (value.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Account Deleted successfully')),
                                );

                                SharedPrefServices.clearUserFromSharedPrefs();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value.status)));
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )))
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
