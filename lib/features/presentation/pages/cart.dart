import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_alert_dialog.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  static const double shippingCharges = 40.00;
  static const double importCharges = 128.00;

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(FetchCartEvent());
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          elevation: 0,
          title: const TextCustom(
            text: "My Cart",
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            // Cart Content
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoadingState) {
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                    );
                  } else if (state is CartLoadedState) {
                    final cartItems = state.cartItems;

                    if (cartItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.network(
                              'https://lottie.host/382973b0-9300-4ab3-b57f-9dc3e061ecc4/WIDFr2fRLF.json',
                              height: 200,
                            ),
                            const SizedBox(height: 20),
                            const TextCustom(
                              text: "Your cart is empty",
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 10),
                            ButtonCustomized(
                              height: 40,
                              width: 150,
                              text: 'Shop now',
                              color: AppColors.primarycolor,
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "/HomeBottom",
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    // Show cart data when not empty
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = cartItems[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                padding: const EdgeInsets.all(16),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.bgColor,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(cartItem[
                                                  'image'] ??
                                              "https://via.placeholder.com/150"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: TextCustom(
                                                  text:
                                                      cartItem['productName'] ??
                                                          'Unknown',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  final result =
                                                      await DialogHelper
                                                          .showAlertDialog(
                                                    context: context,
                                                    title: "Remove cart",
                                                    content: const Text(
                                                        "Are you sure you want to remove this item from cart?"),
                                                    onConfirm: () {
                                                      // Just close the dialog, deletion happens after
                                                    },
                                                    confirmText: "Remove",
                                                    confirmColor:
                                                        AppColors.errorRed,
                                                  );

                                                  // Delete the item after dialog is closed
                                                  if (result == true &&
                                                      context.mounted) {
                                                    context.read<CartBloc>().add(
                                                        DeleteCartItemEvent(
                                                            cartId: cartItem[
                                                                'cartId']));
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          const TextCustom(
                                            text:
                                                "GORE-TEX", // Placeholder subtitle
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextCustom(
                                                text:
                                                    "₹${cartItem['price']?.toString() ?? '0'}",
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        context.read<CartBloc>().add(
                                                            DecrementQuantityEvent(
                                                                productId: cartItem[
                                                                    'productId']));
                                                      },
                                                      icon: const Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0),
                                                    child: TextCustom(
                                                      text: cartItem['count']
                                                              ?.toString() ??
                                                          '1',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primarycolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        context.read<CartBloc>().add(
                                                            IncrementQuantityEvent(
                                                                productId: cartItem[
                                                                    'productId']));
                                                      },
                                                      icon: const Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                        Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom: 100, // Space for floating navbar
                          ),
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
                                          fontSize: 14,
                                          color: Colors.grey.shade700),
                                      TextCustom(
                                          text: "₹$totalSum",
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(
                                      text: "Shipping",
                                      fontSize: 14,
                                      color: Colors.grey.shade700),
                                  const TextCustom(
                                      text: "₹$shippingCharges",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(
                                      text: "Import charges",
                                      fontSize: 14,
                                      color: Colors.grey.shade700),
                                  const TextCustom(
                                      text: "₹$importCharges",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  final totalPrice = state is CartLoadedState
                                      ? getTotalSum(state)
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
                                        text:
                                            "₹${totalPrice + shippingCharges + importCharges}",
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              ButtonCustomized(
                                text: "Add Address",
                                color: AppColors.primarycolor,
                                height: 55,
                                width: double.infinity,
                                borderRadius: 12,
                                onPressed: () {
                                  final cartState = context
                                      .read<CartBloc>()
                                      .state as CartLoadedState;

                                  final totalPrice = getTotalSum(cartState) +
                                      shippingCharges +
                                      importCharges;

                                  final cartData = {
                                    'totalAmount': totalPrice.toInt(),
                                    'cartItems':
                                        cartState.cartItems.map((item) {
                                      return {
                                        'productName': item['productName'] ??
                                            'Unknown Product',
                                        'quantity': item['count'] ?? 1,
                                        'price': item['price'] ?? 'N/A',
                                        'image': item['image'] ??
                                            'default_image_url',
                                      };
                                    }).toList(),
                                  };

                                  Navigator.pushNamed(
                                    context,
                                    "/ShippedAddress",
                                    arguments: cartData,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is CartErrorState) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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
