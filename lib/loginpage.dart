import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/authorization/enter_otp_screen.dart';
import 'package:mirror/dashboard.dart';
import 'package:mirror/models/send_phone_number.model.dart';
import 'package:mirror/register.dart';
import 'package:mirror/services/api_services.dart';
import 'package:mirror/widget/progress_bar.dart';
import 'package:mirror/services/shared_pref_services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:country_picker/country_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  late SendOtpModel sendOtprequestModel;
  bool isApiCallProcess = false;

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "INDIA",
      example: "IN",
      displayName: "IN",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  @override
  void initState() {
    super.initState();
    sendOtprequestModel = SendOtpModel(
      phone_number: "",
    );
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
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? Image.asset(
                fit: BoxFit.fill,
                'assets/background.jpg') // Change to your image asset
            : Scaffold(
                backgroundColor: Color(0xff345998),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/bg_one.jpeg"), // Replace with your image path
                      fit: BoxFit.cover, // Adjust as needed
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          SizedBox(
                              height: 200,
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
                                  fontSize: 30,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Container(
                          //   // margin: EdgeInsets.all(8),
                          //   child: Card(
                          //     color: Color(0xFFFFFFFF),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(
                          //           12), // No rounded corners
                          //     ),
                          //     child:

                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Login",
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Enter your mobile number to login",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937)),
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      hintText: "Enter Phone Number",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 15, 10, 15),
                                        child: InkWell(
                                          onTap: () {
                                            showCountryPicker(
                                              context: context,
                                              countryListTheme:
                                                  const CountryListThemeData(
                                                      bottomSheetHeight: 600),
                                              onSelect: (value) {
                                                setState(() {
                                                  selectedCountry = value;
                                                });
                                              },
                                            );
                                          },
                                          child: Text(
                                            "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    _navigateToOtpScreen();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      // backgroundColor: Colors.purpleAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Text('Get Verification Code',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.white,
                                      )))),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle Registration logicRegistrationPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrationPage(),
                                ),
                              );
                            },
                            child: Text(
                                'Dont you Have an Account? Register Here',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff143061),
                                    decoration: TextDecoration.underline)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  void _navigateToOtpScreen() async {
    final phoneNumber = _phoneController.text.trim();
    final phoneNumber2 = "+${selectedCountry.phoneCode}$phoneNumber";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(phoneNumber2)),
    );

    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      // showToastNew('Please enter a valid phone number');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    } else {
      // sendOtprequestModel.phone_number = phoneNumber2;

      setState(() {
        isApiCallProcess = true;
      });
      ApiService apiService = ApiService();
      apiService.postPhoneNUmber(phoneNumber2).then((value) {
        setState(() {
          isApiCallProcess = false;
        });
        if (value.statusCode == 203 ||
            value.statusCode == 401 ||
            value.statusCode == 400 ||
            value.statusCode == 422 ||
            value.statusCode == 404) {
          setState(() {
            isApiCallProcess = false;
          });
        }
        if (value.statusCode == 200 || value.statusCode == 402) {
          setState(() {
            SharedPrefServices.setmobileNumber(phoneNumber2);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent successfully ${value.otp}')),
          );
          print(value.otp);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phonenumber: phoneNumber2,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.message)));
        }
      });
    }
  }
}
