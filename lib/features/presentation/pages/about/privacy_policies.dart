import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class PrivacyPolicies extends StatelessWidget {
  const PrivacyPolicies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: 'Privacy Policy\n\n',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'Last updated: November 11, 2024.\n\n',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text:
                                "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text:
                                "We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the Free Privacy Policy Generator.\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: 'Contact Us\n\n',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "If you have any questions about this Privacy Policy, You can contact us:\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: "By email: hrithunath777@gmail.com\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline)),
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
