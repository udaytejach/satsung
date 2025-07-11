import 'package:flutter/material.dart';
import 'package:mirror/sidemenu/custom_appbar.dart';
import 'package:mirror/widget/expandable_card.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff345998),
      appBar: const CustomAppbar(title: 'Terms and Conditions'),
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
                  'Welcome to our app! By using our services, you agree to these terms and conditions. Please read them carefully.',
            ),
            ExpandableCard(
              heading: '2. User Responsibilities',
              body:
                  'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
            ),
            ExpandableCard(
              heading: '3. Limitation of Liability',
              body:
                  'We are not liable for any damages or losses resulting from the use of our services, to the maximum extent permitted by law.',
            ),
            ExpandableCard(
              heading: '4. Termination of Use',
              body:
                  'We reserve the right to suspend or terminate your access to our services at any time without notice.',
            ),
            ExpandableCard(
              heading: '5. Contact Information',
              body:
                  'If you have any questions about these terms, you can contact us at support@example.com.',
            ),
          ],
        ),
      ),
    );
  }
}
