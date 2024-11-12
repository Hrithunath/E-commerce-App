import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(text: 'About'),
      ),
      body: Column(
        children: [
          TextCustom(text: 'APP Name'),
          TextCustom(text: '1.0.0'),
          Column(
            children: [
              TextCustom(text: 'About this app'),
              TextCustom(text: ''),
              TextCustom(text: 'Developer Information'),
              TextCustom(text: 'Privacy Policy'),
              TextCustom(text: 'Terms & Condition'),
            ],
          )
        ],
      ),
    );
  }
}
