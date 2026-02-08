import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    super.key,
    required this.orders,
    required this.cartItems,
    required this.addressMap,
  });

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
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primarycolor,
        title: const TextCustom(
          text: 'Order Details',
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var cartItem = cartItems[index];
                var status = orders['status'] ?? 'Pending';

                // Status Color
                Color statusColor;
                switch (status.toString().toLowerCase()) {
                  case 'delivered':
                    statusColor = AppColors.kgreen;
                    break;
                  case 'shipped':
                    statusColor = Colors.blue;
                    break;
                  default:
                    statusColor = const Color(
                        0xFF2196F3); // Material Blue for Pending to match image
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                cartItem['image'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(
                                  text: cartItem['productName'] ?? 'No Name',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 8),
                                TextCustom(
                                  text: '₹${cartItem['price'] ?? '0'}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ],
                            ),
                          ),
                          TextCustom(
                            text: status,
                            color: statusColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Shipping Address Section
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextCustom(
                    text: "Shipping Address",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 15),
                  TextCustom(
                    text: "Name: ${addressMap['name']}",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  TextCustom(
                    text: "Address: ${addressMap['address']}",
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 5),
                  TextCustom(
                    text: "State: ${addressMap['state']}",
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 5),
                  TextCustom(
                    text: "Phone: ${addressMap['phone']}",
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),

            // Payment Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextCustom(
                    text: "Payment Details",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  _buildPaymentRow(
                      "Items (${cartItems.length})", "₹$totalCartPrice"),
                  const SizedBox(height: 12),
                  _buildPaymentRow("Shipping", "₹40"),
                  const SizedBox(height: 12),
                  _buildPaymentRow("Import charges", "₹128"),
                  const SizedBox(height: 15),
                  Divider(color: Colors.grey.withOpacity(0.2), thickness: 1),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextCustom(
                        text: "Total Amount",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      TextCustom(
                        text: "₹${orders['totalAmount'] ?? '0'}",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextCustom(
          text: label,
          fontSize: 16,
          color: Colors.black54,
        ),
        TextCustom(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
