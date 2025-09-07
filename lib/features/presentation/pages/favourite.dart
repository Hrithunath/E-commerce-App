import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_alert_dialog.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_event.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: const TextCustom(
            text: "Favourite",
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<FavouriteBloc, FavouriteState>(
          builder: (context, state) {
            // Loading State: Show Skeletonizer
            if (state is FavouriteLoading) {
              return Center(
                child: Skeletonizer(
                  enabled: true,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 4, // Number of skeleton items
                    itemBuilder: (context, index) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.grey[300], // Skeleton gray
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2, left: 8),
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 20,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 18,
                                  width: 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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

              return Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    final favouriteModel = favourites[index];

                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: favouriteModel.imageUrl != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            favouriteModel.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                  child: Text("Image not available"));
                                            },
                                          ),
                                        )
                                      : const Center(child: Text("No Image")),
                                ),
                                Positioned(
                                  top: -2,
                                  right: 1,
                                  child: IconButton(
                                    onPressed: () {
                                      showAlertDialog(
                                        context,
                                        "Remove Favourite",
                                        "Are you sure you want to remove this item from favourites?",
                                        () {
                                          context
                                              .read<FavouriteBloc>()
                                              .add(RemoveFavouriteEvent(
                                                  favouriteModel.favouriteid));
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: AppColors.kred,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2, left: 8),
                            child: TextCustom(
                              text: favouriteModel.name ?? "Product Name",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextCustom(
                              text: "₹${favouriteModel.price.toString()}",
                              fontSize: 19,
                              color: AppColors.kgreen,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
                        context.read<FavouriteBloc>().add(LoadFavouritesEvent());
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
