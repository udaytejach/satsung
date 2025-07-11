import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mirror/dashboard.dart';
import 'package:mirror/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Timer(
      const Duration(seconds: 5),
      () {
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff345998),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  child: Image(
                    image: AssetImage(
                      'assets/satsunglogo.png',
                    ),
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                height: 5,
              ),
              Shimmer.fromColors(
                baseColor: Colors.pink,
                highlightColor: Colors.blueAccent,
                child: Text(
                  "TRUE MIRROR",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
