import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'StrideSmart',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'Release Type: Stable',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We value your privacy. All user data is securely stored and never shared with third parties.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By using this app, you agree to our terms and conditions. Please use responsibly.',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Center(
              child: Text(
                '© 2026 StrideSmart. All rights reserved.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
