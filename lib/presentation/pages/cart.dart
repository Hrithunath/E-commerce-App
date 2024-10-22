import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/presentation/Widget/alert_dialog.dart';
import 'package:e_commerce_app/presentation/Widget/button.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  static const double shippingCharges = 40.00;
  static const double importCharges = 128.00;

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(FetchCartEvent());
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: TextCustom(
              text: "My Cart",
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CartLoadedState) {
                  final cartItems = state.cartItems;

                  if (cartItems.isEmpty) {
                    TextCustom(text: "Cart is Empty");
                  }

                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
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
                                      cartItem['image'] ?? "default image url"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextCustom(
                                    text: cartItem['productName'] ??
                                        'Product Name Not Available',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 17),
                                IconButton(
                                  onPressed: () {
                                    showAlertDialog(
                                      context,
                                      "Remove cart",
                                      "Are you sure you want to remove this item from cart?",
                                      () {
                                        context.read<CartBloc>().add(
                                            DeleteCartItemEvent(
                                                cartId: cartItem['cartId']));
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextCustom(
                                  text:
                                      "₹${cartItem['price']?.toString() ?? 'Price Not Available'}",
                                  fontSize: 19,
                                  color: AppColors.kgreen,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context.read<CartBloc>().add(
                                            IncrementQuantityEvent(
                                                productId:
                                                    cartItem['productId']));
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                    TextCustom(
                                        text: cartItem['count']?.toString() ??
                                            '1'),
                                    IconButton(
                                      onPressed: () {
                                        context.read<CartBloc>().add(
                                            DecrementQuantityEvent(
                                                productId:
                                                    cartItem['productId']));
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CartErrorState) {
                  return Center(child: Text(state.errorMessage));
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            child: Column(
              children: [
                const Divider(),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final itemCount =
                        state is CartLoadedState ? state.cartItems.length : 0;
                    final totalSum =
                        state is CartLoadedState ? getTotalSum(state) : 0.0;
                    return ListTile(
                      title: TextCustom(text: "Items ($itemCount)"),
                      trailing: TextCustom(text: "₹$totalSum"),
                    );
                  },
                ),
                ListTile(
                  title: TextCustom(text: "Shipping"),
                  trailing: TextCustom(text: "₹$shippingCharges"),
                ),
                ListTile(
                  title: TextCustom(text: "Import charges"),
                  trailing: TextCustom(text: "₹$importCharges"),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final totalSum =
                        state is CartLoadedState ? getTotalSum(state) : 0.0;
                    return ListTile(
                      title: TextCustom(
                        text: "Total Price",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      trailing: TextCustom(
                          text:
                              "₹${totalSum + shippingCharges + importCharges}"),
                    );
                  },
                ),
                ButtonCustomized(
                  text: "Check Out",
                  color: AppColors.primarycolor,
                  height: 50,
                  width: 300,
                  borderRadius: 10,
                  onPressed: () {
                    Navigator.pushNamed(context, "/ShippedAddress");
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
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
