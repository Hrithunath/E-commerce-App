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

class Checkout extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, Object>? cartData;
  final AddressModel address;
  Checkout(
      {super.key,
      required this.cartItems,
      required this.address,
      required this.cartData});

  final Razorpay _razorpay = Razorpay();

  static const double shippingCharges = 40.00;
  static const double importCharges = 128.00;

  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

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
                itemCount: cartItems.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = cartItems[index];
                  // var cartItem = (cartData!['cartItems'] as List)[index];
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
                                  item['image'] ?? "default image url"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: TextCustom(
                          text: "₹${item['price'] ?? 0}",
                          fontSize: 19,
                          color: AppColors.kgreen,
                        ),
                        subtitle: TextCustom(
                          text: "Quantity: ${item['quantity'] ?? 0}",
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
                          text: address.name,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          height: 3,
                        ),
                      ],
                    ),
                    TextCustom(
                      text: address.address,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    TextCustom(
                      text: address.state,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    TextCustom(
                      text: address.phone,
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
                          TextCustom(text: "₹$shippingCharges"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(text: "Import charges"),
                          TextCustom(text: "₹$importCharges"),
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
                            text: " ₹${cartData?['totalAmount']}",
                          ),
                        ],
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
            double totalAmount = (cartData?['totalAmount'] as num).toDouble() +
                shippingCharges +
                importCharges;
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

    // Prepare order data to save in Firestore
    double totalAmount = (cartData?['totalAmount'] as num).toDouble() +
        shippingCharges +
        importCharges;
    Map<String, dynamic> orderData = {
      'cartItems': cartItems,
      'totalAmount': totalAmount,
      'address': {
        'name': address.name,
        'address': address.address,
        'state': address.state,
        'phone': address.phone,
      },
      'paymentId': response.paymentId,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Pending',
    };

    try {
      // Add order to the user's "orders" collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Use the current user's ID
          .collection('orders')
          .add(orderData)
          .then((_) async {
        final allDocuments = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();
        for (var item in allDocuments.docs) {
          await item.reference.delete();
        }
      });

      // Optionally, show a success message or navigate to a different screen
      print("Order added successfully!");
    } catch (e) {
      print("Failed to add order: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    print("Payment Error: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print("External Wallet: ${response.walletName}");
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
