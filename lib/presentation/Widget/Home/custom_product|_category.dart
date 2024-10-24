import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:flutter/material.dart';

class CustomProductCategory extends StatelessWidget {
  const CustomProductCategory({super.key, required this.category, required this.imageUrl});
 final Map<String, dynamic> category;

 final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                elevation: 3,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://via.placeholder.com/100',
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextCustom(
                text: category['categoryName'] ?? 'Unknown',
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}
