import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mirror/chat_screen.dart';
import 'package:mirror/motivational_music.dart';
import 'package:mirror/music.dart';
import 'package:mirror/record.dart';
import 'package:mirror/services/api_services.dart';
import 'package:mirror/sidemenu.dart';
import 'package:mirror/record_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/sleepingmusic.dart';
import 'package:mirror/services/shared_pref_services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void _onItemTapped(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  int selectIndex = 0;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    selectIndex = 0;
    getProfileData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List children = [
    MyMomentsScreen(),
    MotivationalMusicPage(),
    SleepingMusicPage()
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff143061),
          elevation: 1,
          title: Text(
            'True Mirror',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Manually triggers the Drawer
              },
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.mic,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordThroughScreen()
                      // VoiceRecorderPage()
                      ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/bg_one.jpeg"), // Replace with your image path
              fit: BoxFit.cover, // Adjust as needed
            ),
          ),
          child: children[selectIndex],
        ),
        drawer: SideMenu(
            // toggleTheme: widget.toggleTheme,
            // isDarkTheme: widget.isDarkTheme,
            ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff143061),
          currentIndex: selectIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.live_tv_sharp,
              ),
              // label: 'Recordings',
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.music_note,
              ),
              // label: 'Motivation',
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.move_down,
              ),
              // label: 'Sleep',
              label: "",
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Text('Do you want to exit the app ?',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w500)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  exit(0);
                },
                child: Text('Exit',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        )) ??
        false;
  }

  void getProfileData() {
    String sessionTokebn = SharedPrefServices.getsessionToken().toString();
    print(sessionTokebn);
    ApiService apiService = ApiService();
    apiService.getProfileData(sessionTokebn).then((value) {
      setState(() {
        isApiCallProcess = false;
      });
      if (value.statusCode == 203 ||
          value.statusCode == 401 ||
          value.statusCode == 402 ||
          value.statusCode == 400 ||
          value.statusCode == 422 ||
          value.statusCode == 404) {
        setState(() {
          isApiCallProcess = false;
        });
      }
      if (value.statusCode == 200) {
        setState(() {
          // SharedPrefServices.setmobileNumber(phoneNumber2);
          SharedPrefServices.setloginId(value.metadata.userId);
          SharedPrefServices.setfirstName(value.metadata.firstName);
          SharedPrefServices.setlastName(value.metadata.lastName);
          SharedPrefServices.setgender(value.metadata.gender);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile fetched successfully')),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.message)));
      }
    });
  }
}
