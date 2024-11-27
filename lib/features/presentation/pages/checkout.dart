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
      appBar: AppBar(
        title: const Text('My Checkout'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemCount: widget.cartItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = widget.cartItems[index];
                  // var cartItem = (cartData!['cartItems'] as List)[index];
                  return Card(
                    child: SizedBox(
                      height: 70,
                      child: ListTile(
                        leading: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  item['image'] ?? "default image url"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: TextCustom(
                          text: "${item['productName'] ?? 0}",
                          fontSize: 19,
                          color: AppColors.kgreen,
                        ),
                        subtitle: TextCustom(
                          text: "₹${item['price'] ?? 0}",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
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
                          text: widget.address.name,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          height: 3,
                        ),
                      ],
                    ),
                    TextCustom(
                      text: widget.address.address,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    TextCustom(
                      text: widget.address.state,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    TextCustom(
                      text: widget.address.phone,
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
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final itemCount = state is CartLoadedState
                              ? getTotalQuantity(state)
                              : 0;
                          final totalSum = state is CartLoadedState
                              ? getTotalSum(state)
                              : 0.0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextCustom(
                                text: "Items ($itemCount)",
                                fontSize: 17,
                              ),
                              TextCustom(
                                text: "₹$totalSum",
                                fontSize: 17,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(text: "Shipping"),
                          TextCustom(text: "₹${Checkout.shippingCharges}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(text: "Import charges"),
                          TextCustom(text: "₹${Checkout.importCharges}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final totalSum = state is CartLoadedState
                              ? getTotalSum(state) +
                                  Checkout.shippingCharges +
                                  Checkout.importCharges
                              : 0.0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextCustom(
                                text: "Total Price",
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              TextCustom(
                                text: " ₹$totalSum",
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30),
        child: ButtonCustomized(
          text: "Submit Order",
          color: AppColors.primarycolor,
          height: 50,
          width: 300,
          borderRadius: 10,
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
