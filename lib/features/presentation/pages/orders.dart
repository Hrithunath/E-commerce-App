import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/data/repository/order_servicee.dart';
import 'package:e_commerce_app/features/domain/repository/order_repository.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/pages/order_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = OrderRepositoryImplementation();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primarycolor,
        title: const TextCustom(
          text: "My Orders",
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: orderRepository.fetchOrderDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 3,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) => Skeletonizer(
                        enabled: true,
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(height: 180),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/order.webp',
                            width: 200,
                            height: 200,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const TextCustom(
                          text: 'You have no orders',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 10),
                        ButtonCustomized(
                            color: AppColors.primarycolor,
                            text: 'Start Shopping',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, "/HomeBottom");
                            })
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      itemBuilder: (context, index) {
                        var order = snapshot.data!.docs[index];
                        final orderData =
                            order.data() as Map<String, dynamic>? ?? {};
                        final addressMap =
                            orderData['address'] as Map<String, dynamic>? ?? {};

                        final name = addressMap['name'] ?? 'Unknown Name';
                        var cartItems =
                            order['cartItems'] as List<dynamic>? ?? [];
                        var orderId = order['orderId'] ?? 'N/A';
                        var status = order['status'] ?? 'Pending';
                        var timestamp = order['timestamp'] ?? 'N/A';
                        DateTime date = timestamp.toDate();
                        String formattedDate =
                            DateFormat('MMMM d, yyyy').format(date);
                        var totalAmount = order['totalAmount'] ?? 0;

                        // Status Color Mapping
                        Color statusColor;
                        Color statusBgColor;
                        switch (status.toString().toLowerCase()) {
                          case 'delivered':
                            statusColor = AppColors.kgreen;
                            statusBgColor = AppColors.kgreen.withOpacity(0.1);
                            break;
                          case 'shipped':
                            statusColor = Colors.blue;
                            statusBgColor = Colors.blue.withOpacity(0.1);
                            break;
                          case 'pending':
                            statusColor = Colors.orange;
                            statusBgColor = Colors.orange.withOpacity(0.1);
                            break;
                          default:
                            statusColor = Colors.grey;
                            statusBgColor = Colors.grey.withOpacity(0.1);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetails(
                                            orders: order,
                                            addressMap: addressMap,
                                            cartItems: cartItems,
                                          )));
                            },
                            borderRadius: BorderRadius.circular(25),
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
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header with Status Badge
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextCustom(
                                            text: "Name: $name",
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: statusBgColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: TextCustom(
                                            text: status,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    // Date
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            size: 14, color: AppColors.kgreen),
                                        const SizedBox(width: 6),
                                        TextCustom(
                                          text: formattedDate,
                                          fontSize: 14,
                                          color: AppColors.kgreen,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Order ID
                                    TextCustom(
                                      text: "Order ID: $orderId",
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(height: 15),

                                    // Order Summary
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FD),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildOrderRow(
                                              "Items", "${cartItems.length}"),
                                          const SizedBox(height: 8),
                                          _buildOrderRow("Total", "₹$totalAmount",
                                              isBoldValue: true),
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 15),

                                    // View Details Button - Much more prominent
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primarycolor,
                                            AppColors.primarycolor.withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primarycolor
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextCustom(
                                              text: "View Full Details",
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

  Widget _buildOrderRow(String label, String value,
      {Color? valueColor, bool isBoldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextCustom(
          text: label,
          fontSize: 14,
          color: Colors.black.withOpacity(0.6),
        ),
        TextCustom(
          text: value,
          fontSize: 15,
          fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600,
          color: valueColor ?? Colors.black87,
        ),
      ],
    );
  }
}