import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:flutter/material.dart';

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
    required this.imageList,
    required this.product1,
    required this.onTap,
  });

  final List<dynamic> imageList;
  final Map<String, dynamic> product1;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SizedBox(
        width: 310,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.all(Radius.circular(17)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                  child: SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.network(
                      imageList[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://via.placeholder.com/100',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: TextCustom(
                    text: product1['productName'] ?? 'Unknown',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 8, bottom: 13),
                  child: TextCustom(
                    text: "₹${product1['price']}",
                    fontSize: 19,
                    color: AppColors.kgreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
