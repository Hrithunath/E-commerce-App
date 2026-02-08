import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, Object>? cartData;
  final AddressModel address;

  const Checkout(
      {super.key,
      required this.cartItems,
      required this.address,
      required this.cartData});

  static const double shippingCharges = 40.00;
  static const double importCharges = 128.00;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    super.initState();
  }

  @override
  void dispose() {
    @override
    void dispose() {
      _razorpay.clear();
      super.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const TextCustom(
          text: 'My Checkout',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = widget.cartItems[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(item['image'] ??
                                    "https://via.placeholder.com/150"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(
                                  text: "${item['productName'] ?? 'Product'}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(
                                      0xFF00B167), // Greenish color from UI
                                ),
                                const SizedBox(height: 4),
                                TextCustom(
                                  text: "₹${item['price'] ?? 0}",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextCustom(
                      text: "Shipping Address",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            text: widget.address.name,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          TextCustom(
                            text: widget.address.address,
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                          TextCustom(
                            text:
                                "${widget.address.pincode}, ${widget.address.state}",
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 12),
                          TextCustom(
                            text: widget.address.phone,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextCustom(
                      text: "Payment Details",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              final itemCount = state is CartLoadedState
                                  ? getTotalQuantity(state)
                                  : 0;
                              final totalSum = state is CartLoadedState
                                  ? getTotalSum(state)
                                  : 0.0;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(
                                    text: "Items ($itemCount)",
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                  ),
                                  TextCustom(
                                    text: "₹$totalSum",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextCustom(
                                text: "Shipping",
                                fontSize: 15,
                                color: Colors.grey.shade700,
                              ),
                              const TextCustom(
                                text: "₹${Checkout.shippingCharges}",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextCustom(
                                text: "Import charges",
                                fontSize: 15,
                                color: Colors.grey.shade700,
                              ),
                              const TextCustom(
                                text: "₹${Checkout.importCharges}",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              final totalSum = state is CartLoadedState
                                  ? getTotalSum(state) +
                                      Checkout.shippingCharges +
                                      Checkout.importCharges
                                  : 0.0;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextCustom(
                                    text: "Total Price",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  TextCustom(
                                    text: "₹$totalSum",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Spacing for fab
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ButtonCustomized(
          text: "Submit Order",
          color: AppColors.primarycolor,
          height: 60,
          width: double.infinity,
          borderRadius: 15,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () {
            double totalAmount =
                (widget.cartData?['totalAmount'] as num).toDouble();

            print("totalAmount:$totalAmount");
            final total = (totalAmount * 100).toInt();
            print(total);
            var options = {
              'key': 'rzp_test_AAOvWXA6IXusAo',
              'amount': total,
              'currency': 'INR',
              'name': 'Acme Corp.',
              'description': 'Fine T-Shirt',
              'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
            };
            _razorpay.open(options);
          },
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;

    if (user == null) {
      print("No user is signed in.");
      return;
    }

    // Prepare the total amount
    double totalAmount = (widget.cartData?['totalAmount'] as num).toDouble();

    // Consolidate cart items: Combine products with the same productId and size, and sum their quantities
    Map<String, Map<String, dynamic>> consolidatedItems = {};

    for (var item in widget.cartItems) {
      String productId = item['productId'];
      String size = item['size'];

      // Create a unique key based on productId and size
      String key = '$productId-$size';

      // Check if the item already exists in the consolidated map
      if (consolidatedItems.containsKey(key)) {
        consolidatedItems[key]!['quantity'] =
            (int.parse(consolidatedItems[key]!['quantity']) +
                    int.parse(item['quantity']))
                .toString();
      } else {
        // If not, add it to the map
        consolidatedItems[key] = {
          'cartId': item['cartId'],
          'image': item['image'],
          'price': item['price'],
          'productId': productId,
          'productName': item['productName'],
          'quantity': item['quantity'],
          'size': size,
          'stock': item['stock'],
        };
      }
    }

    // Convert consolidated map back to a list format for Firestore
    List<Map<String, dynamic>> consolidatedCartItems = [];
    consolidatedItems.forEach((key, value) {
      consolidatedCartItems.add(value);
    });

    // Prepare the order data to save in Firestore
    Map<String, dynamic> orderData = {
      'userId': user.uid,
      'cartItems': consolidatedCartItems,
      'totalAmount': totalAmount,
      'address': {
        'name': widget.address.name,
        'address': widget.address.address,
        'state': widget.address.state,
        'phone': widget.address.phone,
      },
      'orderId': '',
      'paymentId': response.paymentId,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Pending',
    };

    // Navigate to the success screen after the payment
    Navigator.pushReplacementNamed(context, "/PaymentSuccess");

    try {
      // Add the order data to Firestore under the user's orders
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .add(orderData)
          .then((value) async {
        // Update the order data with the orderId after it's created
        Map<String, dynamic> orderDatas = {
          'userId': user.uid,
          'cartItems':
              consolidatedCartItems, // Use consolidated cart items here
          'totalAmount': totalAmount,
          'address': {
            'name': widget.address.name,
            'address': widget.address.address,
            'state': widget.address.state,
            'phone': widget.address.phone,
          },
          'orderId': value.id,
          'paymentId': response.paymentId,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'Pending',
        };

        // Update the order document with the correct orderId
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .doc(value.id)
            .update(orderDatas)
            .then((_) async {
          // Delete items from the cart collection once the order is confirmed
          final allDocuments = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .get();

          for (var item in allDocuments.docs) {
            await item.reference.delete();
          }
        });
      });

      print("Order added successfully!");
    } catch (e) {
      print("Failed to add order: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pushReplacementNamed(context, "/HomeBottom");
    print("Payment Error: ${response.message}");
  }

  double getTotalSum(CartLoadedState state) {
    return state.cartItems.fold(0.0, (sum, item) {
      int quantity = item['count'] ?? 1;
      double price = double.tryParse(item['price'].toString()) ?? 0;
      return sum + (price * quantity);
    });
  }

  int getTotalQuantity(CartLoadedState state) {
    return state.cartItems.fold(0, (sum, item) {
      int quantity = item['count'] ?? 1;
      return sum + quantity;
    });
  }
}
