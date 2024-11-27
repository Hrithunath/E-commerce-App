import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class CustomProductCategory extends StatelessWidget {
  const CustomProductCategory(
      {super.key,
      required this.category,
      required this.imageUrl,
      required this.onTap});
  final Map<String, dynamic> category;
  final VoidCallback onTap;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 70,
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
                padding: const EdgeInsets.only(left: 15),
                child: Center(
                  child: TextCustom(
                    text: category['categoryName'] ?? 'Unknown',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
