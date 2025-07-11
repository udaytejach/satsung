import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/dashboard.dart';
import 'package:mirror/services/api_services.dart';
import 'package:mirror/sidemenu/custom_appbar.dart';
import 'package:mirror/widget/progress_bar.dart';
import 'package:mirror/services/shared_pref_services.dart';
import 'package:pinput/pinput.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedGender = 'male'; // Default value
  bool _showErrorFirstName = false;
  bool _showErrorLastName = false;
  bool _showErrorPhone = false;
  bool viewOTP = false;
  String view = "one";
  bool isApiCallProcess = false;
  final TextEditingController _otpController = TextEditingController();
  String welcomeMessage =
      "Enter verification code recieved on your Phone Number";

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

    // Add listeners to controllers to hide error messages when user types
    _firstNameController.addListener(() {
      setState(() {
        _showErrorFirstName = _firstNameController.text.isEmpty;
      });
    });

    _lastNameController.addListener(() {
      setState(() {
        _showErrorLastName = _lastNameController.text.isEmpty;
      });
    });

    _phoneController.addListener(() {
      setState(() {
        _showErrorPhone = _phoneController.text.isEmpty ||
            !RegExp(r'^\d{10}$').hasMatch(_phoneController.text);
      });
    });
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
      // appBar: const CustomAppbar(title: 'Register'),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/bg_one.jpeg"), // Replace with your image path
              fit: BoxFit.cover, // Adjust as needed
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name Input
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.white,
                            iconSize: 24,
                            // highlightColor: Colors.white,
                            focusColor: Colors.white,
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  view == "one"
                      ? Column(
                          children: [
                            SizedBox(
                              height: 70,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                textAlignVertical: TextAlignVertical.center,
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  // hintText: "Phone Number",
                                  labelText: "Phone Number",
                                  errorText: _showErrorPhone
                                      ? 'Please enter a valid phone number'
                                      : null,
                                  labelStyle: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  hintStyle: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
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
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(12, 12, 10, 15),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xff4e77ba))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xff4e77ba))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xff4e77ba))),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xff4e77ba))),
                                ),
                              ),
                            ),

                            // SizedBox(height: 10.0),
                            // Gender Selection Dropdown

                            SizedBox(height: 16.0),
                            // Submit Button
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
                                  _navigateToOtpScreen();
                                },
                                child: Text(
                                  "Get Verification Code",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),

                  view == "two"
                      ? Column(children: [
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
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 70,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              textAlignVertical: TextAlignVertical.center,
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                // hintText: "First Name",
                                labelText: "First name",
                                errorText: _showErrorFirstName
                                    ? 'Please enter your first name'
                                    : null,
                                labelStyle: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                hintStyle: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.fromLTRB(12, 12, 10, 15),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(12, 12, 10, 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              textAlignVertical: TextAlignVertical.center,
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                // hintText: "Last Name",
                                labelText: "Last Name",
                                errorText: _showErrorLastName
                                    ? 'Please enter your last name'
                                    : null,
                                labelStyle: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                hintStyle: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.fromLTRB(12, 12, 10, 15),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(12, 12, 10, 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xff4e77ba))),
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            focusColor: Color(0xff4e77ba),
                            dropdownColor: Color(0xff4e77ba),
                            value: _selectedGender,
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xff4e77ba))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xff4e77ba))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xff4e77ba))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xff4e77ba))),
                            ),
                            items: [
                              'male',
                              'female',
                              'rather_not_say',
                            ]
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black,
                                          )),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          // Submit Button
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
                                onBoard();
                                // setState(() {
                                //   view = "one";
                                // });
                              },
                              child: Text(
                                "Register",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ])
                      : Container(),

                  // SizedBox(height: 10.0),
                  // Last Name Input

                  // SizedBox(height: 10.0),
                  // Phone Number Input
                ],
              ),
            ),
          ),
        ),
      ),
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
            value.statusCode == 402 ||
            value.statusCode == 400 ||
            value.statusCode == 422 ||
            value.statusCode == 404) {
          setState(() {
            isApiCallProcess = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.message)));
        }
        if (value.statusCode == 200) {
          SharedPrefServices.setmobileNumber(phoneNumber2);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent successfully${value.otp}')),
          );
          print(value.otp);
          setState(() {
            view = "two";
          });
        } else {
          // showToastNew(value.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(value.message)),
          );
        }
      });
    }
  }

  void onBoard() {
    final phoneNumber = _phoneController.text.trim();
    final phoneNumber2 = "+${selectedCountry.phoneCode}$phoneNumber";
    String firstName = _firstNameController.text.trim().toString();
    String lastName = _lastNameController.text.trim().toString();
    String otp = _otpController.text.trim().toString();

    print(_firstNameController.text);
    print(_lastNameController.text);
    print(_selectedGender);
    print(_otpController.text);
    print(phoneNumber2);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(phoneNumber2)),
    );

    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      // showToastNew('Please enter a valid phone number');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all the details')),
      );
      return;
    } else {
      setState(() {
        isApiCallProcess = true;
      });
      ApiService apiService = ApiService();
      apiService.OnboardUser(
              phoneNumber2, firstName, lastName, _selectedGender, otp)
          .then((value) {
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.message)));
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
              builder: (context) => Dashboard(),
            ),
          );
        } else {
          // showToastNew(value.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(value.message)),
          );
        }
      });
    }
  }
}
