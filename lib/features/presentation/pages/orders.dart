import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/data/repository/order_servicee.dart';
import 'package:e_commerce_app/features/domain/repository/order_repository.dart';
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
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var order = snapshot.data!.docs[index];
                        final orderData =
                            order.data() as Map<String, dynamic>? ?? {};
                        final addressMap =
                            orderData['address'] as Map<String, dynamic>? ?? {};
                        final address = addressMap['address'] ?? 'No Address';
                        final name = addressMap['name'] ??
                            'Unknown Name'; // Corrected access
                        final phone = addressMap['phone'] ?? 'Unknown Phone';
                        final state = addressMap['state'] ?? 'Unknown State';
                        var cartItems =
                            order['cartItems'] as List<dynamic>? ?? [];

                        var orderId = order['orderId'] ?? 'N/A';
                        // var paymentId = order['paymentId'] ?? 'N/A';
                        var status = order['status'] ?? 'Pending';
                        var timestamp = order['timestamp'] ?? 'N/A';
                        DateTime date = timestamp.toDate();
                        String formattedDate =
                            DateFormat('MMMM d, yyyy').format(date);
                        var totalAmount = order['totalAmount'] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: 200,
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
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        text: orderId,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      TextCustom(
                                        text: name,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      TextCustom(
                                        text: "Order at  :$formattedDate",
                                        fontSize: 14,
                                        color: AppColors.kgreen,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextCustom(
                                              text: 'Order Status'),
                                          TextCustom(text: '$status')
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextCustom(text: 'items'),
                                          TextCustom(
                                              text: '${cartItems.length}')
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextCustom(text: 'Price'),
                                          TextCustom(text: '$totalAmount')
                                        ],
                                      ),
                                    ]),
                              )),
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
}
