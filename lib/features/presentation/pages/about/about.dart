import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/pages/about/developer_information.dart';
import 'package:e_commerce_app/features/presentation/pages/about/privacy_policies.dart';
import 'package:e_commerce_app/features/presentation/pages/about/terms_condition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const TextCustom(
                  text: 'StrideSmart',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
                const TextCustom(text: '1.0.0'),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(children: <TextSpan>[
                        const TextSpan(
                            text: 'About us\n\n',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text:
                                'Welcome to our eCommerce application, the ultimate destination for all things shoes.\n\n',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text:
                                "Our app is designed to make it easy for you to browse and purchase a wide variety of shoes in all sizes, ensuring there's something for everyone. Whether you're looking for casual sneakers, formal shoes, or athletic footwear, we've got you covered.\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text:
                                "With seamless shopping and secure payment integration powered by Razorpay, you can shop with confidence and convenience.\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        const TextSpan(
                            text:
                                "Thank you for choosing our app as your go-to place for all your shoe needs!\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: 'Developer Information\n\n',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DeveloperInformation()));
                              }),
                        TextSpan(
                            text: 'Privacy Policy\n\n',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivacyPolicies()));
                              }),
                        TextSpan(
                            text: 'Terms & Condition\n\n',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsCondition()));
                              }),
                      ]),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
