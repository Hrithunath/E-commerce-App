import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/data/repository/cart_service.dart';
import 'package:e_commerce_app/features/domain/model/cart_model.dart';
import 'package:e_commerce_app/features/domain/model/favourite_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_event.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_state.dart';
import 'package:e_commerce_app/features/presentation/bloc/image_prev/image_prev_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  final productDetails;
  const ProductDetails({super.key, required this.productDetails});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? selectedsize;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final imageHeight = screenHeight * 0.35;
    final thumbSize = screenWidth * 0.3;
    final sizeCircleRadius = screenWidth * 0.08;
    final buttonWidth = screenWidth * 0.85;
    final buttonHeight = screenHeight * 0.065;
    final padding = screenWidth * 0.045;
    final fontSizeTitle = screenWidth * 0.05;
    final fontSizeText = screenWidth * 0.042;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  BlocBuilder<ImagePrevBloc, ImagePrevState>(
                    builder: (context, state) {
                      int selectedIndex = 0;
                      if (state is ImagePrevSelected) selectedIndex = state.selectedIndex;

                      String imageUrl = widget.productDetails["uploadImages"][selectedIndex].toString().trim();

                      return Container(
                        width: double.infinity,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.transparent,
                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: padding * 0.5,
                    right: padding * 0.5,
                    child: BlocConsumer<FavouriteBloc, FavouriteState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        bool isFavourite = false;
                        if (state is FavouriteSuccess) {
                          isFavourite = state.favourites.any(
                              (favourite) => favourite.productId == widget.productDetails["id"]);
                        }

                        return IconButton(
                          icon: Icon(
                            isFavourite ? Icons.favorite : Icons.favorite_border,
                            color: isFavourite ? AppColors.kred : Colors.grey,
                            size: screenWidth * 0.08,
                          ),
                          onPressed: () {
                            String productId = widget.productDetails["id"];
                            String imageUrl = widget.productDetails["uploadImages"][0].toString().trim();
                            String name = widget.productDetails["productName"];
                            double price = widget.productDetails["price"]?.toDouble() ?? 0.0;
                            String favouriteId = "fav_$productId";

                            if (isFavourite) {
                              context.read<FavouriteBloc>().add(RemoveFavouriteEvent(favouriteId));
                            } else {
                              FavouriteModel newFavourite = FavouriteModel(
                                productId: productId,
                                favouriteid: favouriteId,
                                imageUrl: imageUrl,
                                name: name,
                                price: price,
                              );
                              context.read<FavouriteBloc>().add(AddFavouriteEvent(newFavourite));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding * 0.5),
              Padding(
                padding: EdgeInsets.all(padding),
                child: TextCustom(
                  text:
                      "${widget.productDetails["productName"]}\n₹${widget.productDetails["price"].toString()}",
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: thumbSize,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.productDetails["uploadImages"].length,
                  itemBuilder: (context, index) {
                    String thumbUrl = widget.productDetails["uploadImages"][index].toString().trim();
                    return Padding(
                      padding: EdgeInsets.all(padding * 0.5),
                      child: GestureDetector(
                        onTap: () {
                          context.read<ImagePrevBloc>().add(ImagePrev(index));
                        },
                        child: Container(
                          height: thumbSize,
                          width: thumbSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              thumbUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: padding * 0.5),
              Padding(
                padding: EdgeInsets.only(left: padding),
                child: TextCustom(
                  text: "Select Size",
                  fontSize: fontSizeText,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                height: sizeCircleRadius * 2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.productDetails["sizes"].length,
                  itemBuilder: (context, index) {
                    final size = widget.productDetails["sizes"][index];
                    return Padding(
                      padding: EdgeInsets.all(padding * 0.3),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedsize = size;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: selectedsize == size
                              ? AppColors.primarycolor
                              : Colors.grey[200],
                          radius: sizeCircleRadius,
                          child: TextCustom(
                            text: size,
                            fontSize: fontSizeText * 0.9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: padding * 0.4),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: 'Product Description',
                      fontSize: fontSizeText,
                      fontWeight: FontWeight.w900,
                    ),
                    SizedBox(height: padding * 0.25),
                    TextCustom(
                      text: "${widget.productDetails["productDescription"]}",
                      color: AppColors.kgrey,
                      height: 1.5,
                      fontSize: fontSizeText * 0.95,
                    ),
                  ],
                ),
              ),
              SizedBox(height: padding * 0.4),
              Center(
                child: ButtonCustomized(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  text: "Add To Cart",
                  color: AppColors.primarycolor,
                  height: buttonHeight,
                  width: buttonWidth,
                  borderRadius: 10,
                  onPressed: () async {
                    if (selectedsize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a size.")),
                      );
                      return;
                    }

                    final cartBloc = context.read<CartBloc>();
                    final CartRepositoryImplementation cartRepo = CartRepositoryImplementation();

                    bool isInCart = await cartRepo.isProductInCart(widget.productDetails["id"]);

                    if (isInCart) {
                      showSnackBarMessage(context, "This product is already in the cart.", Colors.red);
                      return;
                    }

                    final cartItem = CartModel(
                      productid: widget.productDetails["id"],
                      cartid: "generated_cart_id",
                      count: 1,
                      imageUrl: widget.productDetails["uploadImages"][0].toString().trim(),
                      name: widget.productDetails["productName"],
                      size: selectedsize!,
                      stock: widget.productDetails["stock"] as int,
                      price: double.tryParse(widget.productDetails["price"].toString()) ?? 0.0,
                    );

                    cartBloc.add(AddToCartEvent(
                      productId: cartItem.productid,
                      productName: cartItem.name,
                      productPrice: cartItem.price.toString(),
                      productQuantity: cartItem.count.toString(),
                      image: cartItem.imageUrl,
                      size: cartItem.size,
                      stock: cartItem.stock.toString(),
                    ));

                    showSnackBarMessage(
                        context, "${widget.productDetails["productName"]} added to cart.", Colors.green);
                  },
                ),
              ),
              SizedBox(height: padding),
            ],
          ),
        ),
      ),
    );
  }
}
