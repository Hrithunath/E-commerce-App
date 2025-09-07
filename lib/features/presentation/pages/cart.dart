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
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                                              cartItem['image'] ??
                                                  "default image url"),
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
                                                context
                                                    .read<CartBloc>()
                                                    .add(DeleteCartItemEvent(
                                                        cartId: cartItem[
                                                            'cartId']));
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                context
                                                    .read<CartBloc>()
                                                    .add(DecrementQuantityEvent(
                                                        productId: cartItem[
                                                            'productId']));
                                              },
                                              icon: const Icon(Icons.remove),
                                            ),
                                            TextCustom(
                                                text: cartItem['count']
                                                        ?.toString() ??
                                                    '1'),
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<CartBloc>()
                                                    .add(IncrementQuantityEvent(
                                                        productId: cartItem[
                                                            'productId']));
                                              },
                                              icon: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              const Divider(),
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  final itemCount = state is CartLoadedState
                                      ? getTotalQuantity(state)
                                      : 0;
                                  final totalSum = state is CartLoadedState
                                      ? getTotalSum(state)
                                      : 0.0;
                                  return ListTile(
                                    title: TextCustom(text: "Items ($itemCount)"),
                                    trailing: TextCustom(text: "₹$totalSum"),
                                  );
                                },
                              ),
                              const ListTile(
                                title: TextCustom(text: "Shipping"),
                                trailing: TextCustom(text: "₹$shippingCharges"),
                              ),
                              const ListTile(
                                title: TextCustom(text: "Import charges"),
                                trailing:
                                    TextCustom(text: "₹$importCharges"),
                              ),
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  final totalPrice = state is CartLoadedState
                                      ? getTotalSum(state)
                                      : 0.0;
                                  return ListTile(
                                    title: const TextCustom(
                                      text: "Total Price",
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    trailing: TextCustom(
                                        text:
                                            "₹${totalPrice + shippingCharges + importCharges}"),
                                  );
                                },
                              ),
                              ButtonCustomized(
                                text: "Add Address",
                                color: AppColors.primarycolor,
                                height: 50,
                                width: 300,
                                borderRadius: 10,
                                onPressed: () {
                                  final cartState =
                                      context.read<CartBloc>().state
                                          as CartLoadedState;

                                  final totalPrice = getTotalSum(cartState) +
                                      shippingCharges +
                                      importCharges;

                                  final cartData = {
                                    'totalAmount': totalPrice.toInt(),
                                    'cartItems': cartState.cartItems.map((item) {
                                      return {
                                        'productName':
                                            item['productName'] ??
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
                              const SizedBox(height: 10),
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
