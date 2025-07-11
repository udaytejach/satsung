import 'package:mirror/dashboard.dart';
import 'package:mirror/services/api_services.dart';
import 'package:mirror/widget/progress_bar.dart';
import 'package:mirror/services/shared_pref_services.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  String phonenumber;
  OtpScreen({super.key, required this.phonenumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  String welcomeMessage =
      "Enter verification code recieved on your Phone Number";

  bool _isLoading = false;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  Widget uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff345998),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Verification Code",
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/bg_one.jpeg"), // Replace with your image path
            fit: BoxFit.cover, // Adjust as needed
          ),
        ),
        child: Stack(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    welcomeMessage,
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Hint: 123456',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Pinput(
                    length: 6,
                    controller: _otpController,
                    showCursor: true,
                    onChanged: (value) {
                      setState(() {
                        // _isOtpValid = value == '123456';
                      });
                    },
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        // padding:
                        //     const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        String enteredOtp = _otpController.text.trim();
                        if (enteredOtp.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Please Enter Verification Code')),
                          );
                        } else if (enteredOtp != '123456') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Incorrect Verification Code. Please try again')),
                          );
                        } else {
                          Login();
                        }
                      },
                      child: Text(
                        "VERIFY",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ]),
      ),
    );
  }

  void Login() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      // showToastNew('Please enter a valid phone number');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    } else {
      setState(() {
        isApiCallProcess = true;
      });
      ApiService apiService = ApiService();
      apiService.Login(widget.phonenumber, otp).then((value) {
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
            SharedPrefServices.setisLoggedIn(true);
            SharedPrefServices.setsessionToken(value.sessionToken);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(value.message)),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                  // toggleTheme: widget.toggleTheme,
                  // isDarkTheme: widget.isDarkTheme,
                  ),
            ),
          );
        } else {
          // showToastNew(value.message);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(value.message)),
          // );
        }
      });
    }
  }
}
