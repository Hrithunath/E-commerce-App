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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final padding = screenWidth * 0.04;
    final imageWidth = screenWidth * 0.2;
    final imageHeight = screenHeight * 0.12;
    final fontSizeTitle = screenWidth * 0.045;
    final fontSizeSmall = screenWidth * 0.038;

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
        title: Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSizeTitle,
          ),
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
                  margin: EdgeInsets.symmetric(
                      horizontal: padding, vertical: padding * 0.5),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(padding * 0.5),
                    leading: Container(
                      width: imageWidth,
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(cartItem['image'] ??
                              'https://via.placeholder.com/150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: TextCustom(
                      text: cartItem['productName'] ?? 'No Name',
                      fontWeight: FontWeight.w500,
                      fontSize: fontSizeSmall,
                    ),
                    subtitle: TextCustom(
                      text: '₹${cartItem['price'] ?? '0'}',
                      fontSize: fontSizeSmall,
                      fontWeight: FontWeight.w800,
                    ),
                    trailing: TextCustom(
                      text: orders['status'],
                      color: Colors.blue,
                      fontSize: fontSizeSmall + 2,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 1.5),
                TextCustom(
                  text: "Shipping Address",
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: padding * 0.3),
                TextCustom(
                  text: addressMap['name'] ?? 'No Name',
                  fontSize: fontSizeSmall,
                  fontWeight: FontWeight.w800,
                ),
                TextCustom(
                  text: addressMap['address'] ?? 'No Address',
                  fontSize: fontSizeSmall,
                  color: Colors.grey,
                ),
                TextCustom(
                  text: addressMap['state'] ?? 'No State',
                  fontSize: fontSizeSmall,
                  color: Colors.grey,
                ),
                TextCustom(
                  text: addressMap['phone'] ?? 'No Phone',
                  fontSize: fontSizeSmall,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 1.5),
                TextCustom(
                  text: "Payment Details",
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: padding * 0.3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(
                      text: "Items (${cartItems.length})",
                      fontSize: fontSizeSmall,
                    ),
                    TextCustom(
                      text: "₹$totalCartPrice",
                      fontSize: fontSizeSmall,
                    ),
                  ],
                ),
                SizedBox(height: padding * 0.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(text: "Shipping", fontSize: fontSizeSmall),
                    TextCustom(text: "₹40", fontSize: fontSizeSmall),
                  ],
                ),
                SizedBox(height: padding * 0.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(text: "Import charges", fontSize: fontSizeSmall),
                    TextCustom(text: "₹128", fontSize: fontSizeSmall),
                  ],
                ),
                SizedBox(height: padding * 0.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(
                      text: "Total Amount",
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                    TextCustom(
                      text: "₹${orders['totalAmount'] ?? '0'}",
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
