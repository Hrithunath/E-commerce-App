import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails(
      {super.key,
      required this.orders,
      required this.cartItems,
      required this.addressMap});
  final QueryDocumentSnapshot<Object?> orders;
  final List<dynamic> cartItems;
  final Map<String, dynamic> addressMap;

  @override
  Widget build(BuildContext context) {
    double totalCartPrice = 0.0;
    for (var cartItem in cartItems) {
      final price = double.tryParse(cartItem['price'].toString()) ?? 0.0;
      final quantity = cartItem['quantity'] is int ? cartItem['quantity'] : 1;

      totalCartPrice += price * quantity;
    }
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Order Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primarycolor,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var cartItem = cartItems[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      cartItem['image'] ?? 'default_image_url'),
                                  fit: BoxFit.cover)),
                        ),
                        title: TextCustom(
                          text: cartItem['productName'] ?? 'No Name',
                          fontWeight: FontWeight.w500,
                        ),
                        subtitle: TextCustom(
                          text: '₹${cartItem['price'] ?? '0'}',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                        trailing: TextCustom(
                          text: orders['status'],
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const TextCustom(
                    text: "Shipping Address",
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(
                        text: addressMap['name'] ?? 'No Name',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 3,
                      ),
                    ],
                  ),
                  TextCustom(
                    text: addressMap['address'] ?? 'No Address',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  TextCustom(
                    text: addressMap['state'] ?? 'No state',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  TextCustom(
                    text: addressMap['phone'] ?? 'No phone',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const TextCustom(
                        text: "Payment Details",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(
                            text: "Items (${cartItems.length})",
                            fontSize: 17,
                          ),
                          TextCustom(
                            text: "₹$totalCartPrice",
                            fontSize: 17,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(text: "Shipping"),
                          TextCustom(text: "₹40"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(text: "Import charges"),
                          TextCustom(text: "₹128"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextCustom(
                            text: "Total Amount",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          TextCustom(
                            text: "₹${orders['totalAmount'] ?? '0'}",
                          ),
                        ],
                      ),
                    ])),
          ],
        ));
  }
}
