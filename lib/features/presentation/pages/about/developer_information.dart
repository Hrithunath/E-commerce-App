import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class DeveloperInformation extends StatelessWidget {
  const DeveloperInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Developer Information'),
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
                            text:
                                '''This application was developed by Hrithunath, a passionate Flutter developer with a strong focus on building user-friendly and efficient mobile applications. With expertise in creating responsive designs and integrating modern features, Hrithunath aims to deliver innovative and high-quality solutions.
\n\n''',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text:
                                "For queries or support, feel free to reach out:\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: " Email: hrithunath777@gmail.com\n\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline)),
                        TextSpan(
                            text:
                                "Thank you for choosing our app for your shoe-shopping journey!\n",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                height: 1.5,
                                fontWeight: FontWeight.w500)),
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
