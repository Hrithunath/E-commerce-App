import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/domain/model/cart_model.dart';
import 'package:e_commerce_app/domain/model/favourite_model.dart';
import 'package:e_commerce_app/presentation/Widget/button.dart';
import 'package:e_commerce_app/presentation/Widget/scaffold_messenger.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/bloc/favourite/favourite_bloc.dart';
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.productDetails["uploadImages"][0].toString(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: BlocBuilder<FavouriteBloc, FavouriteState>(
                      builder: (context, state) {
                        final isFavourite = state is FavouriteLoaded &&
                            state.favourites.any((favourite) =>
                                favourite.productId ==
                                widget.productDetails["id"]);
                        return SizedBox(
                          height: 30,
                          child: IconButton(
                              icon: Icon(
                                isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    isFavourite ? AppColors.kred : Colors.grey,
                                size: 30,
                              ),
                              onPressed: () {
                                if (widget.productDetails
                                        is Map<String, dynamic> &&
                                    widget.productDetails["id"] != null) {
                                  String productId =
                                      widget.productDetails["id"] as String;
                                  String? imageUrl =
                                      widget.productDetails["uploadImages"][0];
                                  String? name =
                                      widget.productDetails["productName"];
                                  var priceValue =
                                      widget.productDetails["price"];
                                  double price;

                                  if (priceValue is int) {
                                    price = priceValue.toDouble();
                                  } else if (priceValue is double) {
                                    price = priceValue;
                                  } else {
                                    print(
                                        "Unexpected type for price: ${priceValue.runtimeType}");
                                    return;
                                  }

                                  print("Product ID: $productId");
                                  print("Image URL: $imageUrl");
                                  print("Name: $name");
                                  print("Price: $price");

                                  String favouriteId = "fav_$productId";
                                  if (isFavourite) {
                                    print(
                                        "Removing favourite for product ID: $productId");
                                    context
                                        .read<FavouriteBloc>()
                                        .add(RemoveFavouriteEvent(productId));
                                  } else {
                                    FavouriteModel newFavourite =
                                        FavouriteModel(
                                      productId: productId,
                                      favouriteid: favouriteId,
                                      imageUrl: imageUrl,
                                      name: name,
                                      price: price,
                                    );
                                    context
                                        .read<FavouriteBloc>()
                                        .add(AddFavouriteEvent(newFavourite));
                                    print("Added to favourites: $newFavourite");
                                  }
                                } else {
                                  print(
                                      "Invalid product ID or product details.");
                                }
                              }),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(17),
                child: TextCustom(
                  text:
                      "${widget.productDetails["productName"]}\n₹${widget.productDetails["price"].toString()}",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              widget.productDetails["uploadImages"][index]
                                  .toString(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.productDetails["uploadImages"].length,
                ),
              ),
              const SizedBox(height: 13),
              const Padding(
                padding: EdgeInsets.only(left: 17),
                child: TextCustom(
                  text: "Select Size",
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final size = widget.productDetails["sizes"][index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
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
                          radius: 27,
                          child: TextCustom(
                            text: widget.productDetails["sizes"][index],
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.productDetails["sizes"].length,
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 17),
                child: TextCustom(
                  text: "Specification",
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 17, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextCustom(
                      text: "Shown:",
                      fontSize: 17,
                    ),
                    TextCustom(
                      text: "${widget.productDetails["category"]}",
                      fontSize: 16,
                      color: AppColors.kgrey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
             
              Padding(
                padding: const EdgeInsets.all(17),
                child: TextCustom(
                  text: "${widget.productDetails["productDescription"]}",
                  color: AppColors.kgrey,
                  height: 1.5,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ButtonCustomized(
                  text: "Add To Cart",
                  color: AppColors.primarycolor,
                  height: 50,
                  width: 300,
                  borderRadius: 10,
                  onPressed: () {
                    
                    bool validateSelection() {
                      if (selectedsize == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select a size.")),
                        );
                        return false;
                      }
                      return true;
                    }

                    if (!validateSelection()) {
                      return;
                    }

                    final cartBloc = context.read<CartBloc>();
                    final currentState = cartBloc.state;

                    bool isProductAlreadyInCart = false;

                    if (currentState is CartLoadedState) {
                      isProductAlreadyInCart = currentState.cartItems.any(
                        (item) =>
                            item['productid'] ==
                            widget.productDetails["productid"],
                      );
                    }

                    if (isProductAlreadyInCart) {
                      showSnackBarMessage(context, "This product is already in the cart.", Colors.red);
                    
                      return;
                    }

                    final cartItem = CartModel(
                      productid: widget.productDetails["id"],
                      cartid: "generated_cart_id",
                      count: 1,
                      imageUrl: widget.productDetails["uploadImages"][0],
                      name: widget.productDetails["productName"],
                      size: selectedsize!,
                      stock: widget.productDetails["stock"] as int,
                      price: double.tryParse(
                              widget.productDetails["price"].toString()) ??
                          0.0,
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

                
                     showSnackBarMessage(context, "${widget.productDetails["productName"]} added to cart." , Colors.green);
                  },
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
