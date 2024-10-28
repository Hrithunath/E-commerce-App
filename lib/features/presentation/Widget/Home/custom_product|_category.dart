import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class CustomProductCategory extends StatelessWidget {
  const CustomProductCategory(
      {super.key, required this.category, required this.imageUrl});
  final Map<String, dynamic> category;

  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CircleAvatar(
                radius: 34,
                foregroundImage: NetworkImage(
                  imageUrl,
                ),
                // backgroundImage: const NetworkImage("https://via.placeholder.com/100"),
                onForegroundImageError: (exception, stackTrace) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextCustom(
                text: category['categoryName'] ?? 'Unknown',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
