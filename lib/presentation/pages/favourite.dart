import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/presentation/Widget/alert_dialog.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/bloc/favourite/favourite_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      child: BlocBuilder<FavouriteBloc, FavouriteState>(
        builder: (context, state) {
          if (state is FavouriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavouriteLoaded) {
            final favourites = state.favourites;
            if (favourites.isEmpty) {
              return const Center(
                child: Text("No favourites added."),
              );
            }

            return Column(
              children: [
                Container(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextCustom(
                      text: "My Favourite",
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: favourites.length,
                      itemBuilder: (context, index) {
                        final favouriteModel = favourites.elementAt(index);

                        return Card(
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: favouriteModel.imageUrl != null
                                          ? Image.network(
                                              favouriteModel.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Center(
                                                    child: Text(
                                                        "Image not available"));
                                              },
                                            )
                                          : const Center(
                                              child: Text("No Image")),
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
                                              context.read<FavouriteBloc>().add(
                                                  RemoveFavouriteEvent(
                                                      favouriteModel
                                                          .favouriteid));
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
                                padding: const EdgeInsets.only(
                                    top: 2, bottom: 0, left: 8),
                                child: TextCustom(
                                  text: favouriteModel.name ?? "Product Name",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                  ),
                ),
              ],
            );
          } else if (state is FavouriteError) {
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

          return const Center(
            child: Text("An unexpected error occurred."),
          );
        },
      ),
    );
  }
}
