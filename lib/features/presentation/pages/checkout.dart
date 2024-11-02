import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: "Order Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustom(
              text: "Product",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                // cartItems.length,
                itemBuilder: (context, index) {
                  // final cartItem = cartItems[index];
                  return Card(
                    child: SizedBox(
                      height: 100,
                      child: ListTile(
                        leading: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  // cartItem['image'] ??
                                  "default image url"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextCustom(
                                text:
                                    // cartItem['productName'] ??
                                    'Product Name Not Available',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              text:
                                  // "₹${cartItem['price']?.toString() ??
                                  'Price Not Available'
                              // }"
                              ,
                              fontSize: 19,
                              color: AppColors.kgreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                TextCustom(
                  text: "Shipping details",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            Column(
              children: [
                TextCustom(
                  text: "Payment Details",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
