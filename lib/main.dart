import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/loginpage.dart';
import 'package:mirror/services/http_override.dart';
import 'package:mirror/splash_screen.dart';
import 'package:mirror/services/shared_pref_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await SharedPrefServices.init();

  runApp(MirrorApp());
}

class MirrorApp extends StatefulWidget {
  @override
  _MirrorAppState createState() => _MirrorAppState();
}

class _MirrorAppState extends State<MirrorApp> {
  bool isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme:
            GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(),
        useMaterial3: true,
      ),

      // isDarkTheme
      //     ? ThemeData.dark().copyWith(
      //         textTheme:
      //             GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      //       )
      //     : ThemeData.light().copyWith(
      //         textTheme:
      //             GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      //       ),

      home: Splashscreen(),
    );
  }
}
