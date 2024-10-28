import 'package:e_commerce_app/features/presentation/Widget/Home/custom_appbar.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_primary_header_container.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class NewDesign extends StatelessWidget {
  const NewDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  CustomAppbar(
                    title: SizedBox(
                      width: double.infinity,
                      child: TextCustom(
                          text: "Good day for shopping",
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    subtitle: SizedBox(
                        width: double.infinity,
                        child: TextCustom(
                          text: "Hrithunath",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    action: [],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
