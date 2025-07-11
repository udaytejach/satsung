import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/dashboard.dart';
import 'package:mirror/services/api_services.dart';
import 'package:mirror/sidemenu/custom_appbar.dart';
import 'package:mirror/widget/expandable_card.dart';
import 'package:mirror/services/shared_pref_services.dart';
import 'package:mirror/widget/progress_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  TextEditingController firstNameController =
      TextEditingController(text: SharedPrefServices.getfirstName().toString());
  TextEditingController lastNameController =
      TextEditingController(text: SharedPrefServices.getlastName().toString());
  TextEditingController displayController = TextEditingController(
      text: SharedPrefServices.getdisplayname().toString());
  final _formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedGender = SharedPrefServices.getgender().toString();
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
        appBar: const CustomAppbar(title: 'Edit Profile'),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/bg_one.jpeg"), // Replace with your image path
              fit: BoxFit.cover, // Adjust as needed
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Center(
                  //   child: Stack(
                  //     clipBehavior: Clip.none,
                  //     children: [
                  //       CircleAvatar(
                  //         radius: 55,
                  //         backgroundImage: image != null
                  //             ? FileImage(image!)
                  //             : (SharedPrefServices.getProfileImage()
                  //                     .toString()
                  //                     .isNotEmpty
                  //                 ? NetworkImage(
                  //                     SharedPrefServices.getProfileImage()
                  //                         .toString())
                  //                 : const AssetImage('images/profile.webp')),
                  //       ),
                  //       Positioned(
                  //         top: 65,
                  //         left: 85,
                  //         child: GestureDetector(
                  //           onTap: () => selectImage(),
                  //           child: const CircleAvatar(
                  //             backgroundColor: Colours.kbuttonpurple,
                  //             radius: 18,
                  //             child: Icon(
                  //               Icons.edit,
                  //               color: Colours.kwhiteColor,
                  //               size: 18,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Center(
                  //   child: CircleAvatar(
                  //     radius: 50.0,
                  //     backgroundImage: const AssetImage('images/profile.webp'),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomText(
                        text: 'Mobile Number',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        text: '*',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CustomText(
                        text: SharedPrefServices.getmobileNumber().toString(),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: 'First Name',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        text: '*',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: firstNameController,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: 'Last Name',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        text: '*',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: lastNameController,
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  // CustomText(
                  //   text: 'Gender',
                  //   fontSize: 13,
                  //   fontWeight: FontWeight.w400,
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField<String>(
                    focusColor: Color(0xff4e77ba),
                    dropdownColor: Color(0xff4e77ba),
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff4e77ba))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff4e77ba))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff4e77ba))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff4e77ba))),
                    ),
                    items: ['male', 'female', 'rather_not_say']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
                                  )),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              updateProfileData();
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text('Save',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                )))),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildProfileField(String label, String value, IconData iconData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: "poppins"),
          ),
        ),
        const SizedBox(height: 4),
        Card(
          borderOnForeground: true,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent, // Set the border color
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(iconData, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                CustomText(
                  text: value.isNotEmpty ? value : '',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      isApiCallProcess = true;
    });
    String sessionTokebn = SharedPrefServices.getsessionToken().toString();
    print(sessionTokebn);
    ApiService apiService = ApiService();
    apiService.EditUser(
            firstNameController.text, lastNameController.text, selectedGender!)
        .then((value) {
      if (value.statusCode == 203 ||
          value.statusCode == 401 ||
          value.statusCode == 402 ||
          value.statusCode == 400 ||
          value.statusCode == 500 ||
          value.statusCode == 422 ||
          value.statusCode == 404) {
        setState(() {
          isApiCallProcess = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${value.message}')),
        );
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
          SnackBar(content: Text('Profile Updated successfully')),
        );
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.message)));
      }
    });
  }
}
