import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/sidemenu/custom_appbar.dart';
import 'package:mirror/sidemenu/edit_profile.dart';
import 'package:mirror/widget/expandable_card.dart';
import 'package:mirror/services/shared_pref_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff345998),
      appBar: const CustomAppbar(title: 'My Profile'),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/bg_one.jpeg"), // Replace with your image path
              fit: BoxFit.cover, // Adjust as needed
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildProfileField("First Name",
                    SharedPrefServices.getfirstName().toString(), Icons.person),
                _buildProfileField("Last Name",
                    SharedPrefServices.getlastName().toString(), Icons.person),
                _buildProfileField("Gender",
                    SharedPrefServices.getgender().toString(), Icons.people),
                _buildProfileField(
                    "Phone Number",
                    SharedPrefServices.getmobileNumber().toString(),
                    Icons.phone),
                _buildProfileField(
                    "Status",
                    SharedPrefServices.getisLoggedIn().toString(),
                    Icons.shield),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.purpleAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text('Edit Profile',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                // color: Colors.white,
                              )))),
                ),
                const SizedBox(height: 15),
              ],
            ),
          )),
    );
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
}
