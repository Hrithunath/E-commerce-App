import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/data/repository/order_servicee.dart';
import 'package:e_commerce_app/features/domain/repository/order_repository.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = OrderRepositoryImplementation();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              padding: const EdgeInsets.all(16.0),
              child: const TextCustom(
                text: "My Orders",
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: orderRepository.fetchOrderDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No orders found.'));
                  } else {
                    List<dynamic> allCartItems = [];
                    for (var order in snapshot.data!.docs) {
                      var cartItems =
                          order['cartItems'] as List<dynamic>? ?? [];
                      allCartItems.addAll(cartItems);
                    }

                    return ListView.builder(
                      itemCount: allCartItems.length,
                      itemBuilder: (context, index) {
                        var item = allCartItems[index];
                        var imageUrl = item['image'] ?? '';
                        var productName = item['productName'] ?? 'Product Name';
                        var price = item['price'] ?? '0';
                        var size = item['size'] ?? 'N/A';
                        var stock = item['stock'] ?? 'N/A';
                        var productId = item['productId'] ?? 'N/A';

                        return Card(
                          child: ExpansionTile(
                            leading: Container(
                              height: 80,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: TextCustom(
                              text: productName,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            subtitle: TextCustom(
                              text: "₹$price",
                              fontSize: 14,
                              color: AppColors.kgreen,
                            ),
                            children: [
                              ListTile(
                                title: TextCustom(
                                  text: "Size: $size",
                                  fontSize: 14,
                                ),
                              ),
                              ListTile(
                                title: TextCustom(
                                  text: "Stock: $stock",
                                  fontSize: 14,
                                ),
                              ),
                              ListTile(
                                title: TextCustom(
                                  text: "Product ID: $productId",
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
