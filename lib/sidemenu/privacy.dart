import 'package:flutter/material.dart';
import 'package:mirror/sidemenu/custom_appbar.dart';
import 'package:mirror/widget/expandable_card.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff345998),
      appBar: const CustomAppbar(title: 'Privacy Policy'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/bg_one.jpeg"), // Replace with your image path
            fit: BoxFit.cover, // Adjust as needed
          ),
        ),
        child: ListView(
          children: [
            ExpandableCard(
              heading: '1. Introduction',
              body:
                  'We value your privacy and are committed to protecting your personal data. This privacy policy outlines how we collect, use, and protect your information.',
            ),
            ExpandableCard(
              heading: '2. Data Collection',
              body:
                  'We may collect personal information such as your name, email address, and usage data to improve the app experience.',
            ),
            ExpandableCard(
              heading: '3. Data Usage',
              body:
                  'The information we collect is used for analytics, app optimization, and providing a better user experience. We will never share your data with third parties without your consent.',
            ),
            ExpandableCard(
              heading: '4. Data Collection',
              body:
                  'We implement stringent security measures to ensure your data is safe. However, no method of electronic storage is 100% secure.',
            ),
            ExpandableCard(
              heading: '5. user Rights',
              body:
                  'You have the right to access, modify, and delete your personal information. Contact us to exercise these rights.',
            ),
            ExpandableCard(
              heading: '5. Contact Us',
              body:
                  'If you have any questions regarding our privacy policy, please reach out to us at support@example.com.',
            ),
          ],
        ),
      ),
    );
  }
}
