import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_alert_dialog.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_event.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_state.dart';
import 'package:e_commerce_app/features/presentation/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:e_commerce_app/core/constants/app_strings.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  Future<void> _navigateToDetails(
      BuildContext context, String productId) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (context.mounted) Navigator.pop(context); // Close loading dialog

      if (doc.exists && context.mounted) {
        final productData = doc.data() as Map<String, dynamic>;
        productData['id'] = doc.id; // Ensure ID is present
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetails(productDetails: productData),
          ),
        );
      } else {
        if (context.mounted) {
          context.showErrorSnackBar(AppStrings.productNotFound);
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Close loading dialog
      if (context.mounted) {
        context.showErrorSnackBar("${AppStrings.errorPrefix}$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight:
              0, // Hide the app bar but keep the SafeArea/Scaffold structure
        ),
        body: BlocBuilder<FavouriteBloc, FavouriteState>(
          builder: (context, state) {
            // Loading State: Show Skeletonizer
            if (state is FavouriteLoading) {
              return Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: 14,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 20,
                                      width: 150,
                                      color: Colors.grey[300]),
                                  const SizedBox(height: 10),
                                  Container(
                                      height: 18,
                                      width: 80,
                                      color: Colors.grey[300]),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            // Success State: Display Favourites
            else if (state is FavouriteSuccess) {
              final favourites = state.favourites;
              if (favourites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.network(
                        'https://lottie.host/8d7f4053-3745-423f-b26c-cae2d62ad658/Ymoz1NGSX8.json',
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      const TextCustom(
                        text: "You haven't added any",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      const TextCustom(
                        text: "product yet",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      const TextCustom(
                        text: "Click ❤️ to save products",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      ButtonCustomized(
                        height: 40,
                        width: 190,
                        text: 'Browse Items',
                        color: AppColors.primarycolor,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/HomeBottom", (route) => false);
                        },
                      )
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextCustom(
                          text: "Favourite",
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        TextCustom(
                          text: "${favourites.length} items saved",
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: favourites.length,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 100, // Space for floating navbar
                      ),
                      itemBuilder: (context, index) {
                        final favouriteModel = favourites[index];

                        return InkWell(
                          onTap: () => _navigateToDetails(
                              context, favouriteModel.productId),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Product Image
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColors.bgColor,
                                    ),
                                    child: favouriteModel.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Image.network(
                                              favouriteModel.imageUrl!,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.broken_image,
                                                      size: 40),
                                            ),
                                          )
                                        : const Icon(Icons.image_not_supported,
                                            size: 40),
                                  ),
                                  const SizedBox(width: 14),
                                  // Vertical divider after image
                                  const VerticalDivider(
                                    width: 18,
                                    thickness: 1.2,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextCustom(
                                          text: favouriteModel.name ??
                                              "Product Name",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 4),
                                        TextCustom(
                                          text:
                                              "₹${favouriteModel.price.toString()}",
                                          fontSize: 15,
                                          color: AppColors.kgreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 8),
                                        InkWell(
                                          onTap: () => _navigateToDetails(
                                              context,
                                              favouriteModel.productId),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.primarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const TextCustom(
                                              text: "Add to Cart",
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Vertical divider before heart icon
                                  const VerticalDivider(
                                    width: 18,
                                    thickness: 1.2,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  // Heart Icon
                                  IconButton(
                                    onPressed: () async {
                                      final result =
                                          await DialogHelper.showAlertDialog(
                                        context: context,
                                        title: "Remove Favourite",
                                        content: const Text(
                                            "Are you sure you want to remove this item from favourites?"),
                                        onConfirm: () {
                                          // Just close the dialog, deletion happens after
                                        },
                                        confirmText: "Remove",
                                        confirmColor: AppColors.errorRed,
                                      );

                                      // Remove the item after dialog is closed
                                      if (result == true && context.mounted) {
                                        context.read<FavouriteBloc>().add(
                                            RemoveFavouriteEvent(
                                                favouriteModel.favouriteid));
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: AppColors.kred,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            // Error State: Show error message
            else if (state is FavouriteError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<FavouriteBloc>()
                            .add(LoadFavouritesEvent());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
