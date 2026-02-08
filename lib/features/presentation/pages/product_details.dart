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
import 'package:e_commerce_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10.r,
                              offset: Offset(0, 5.h),
                            ),
                          ],
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    BlocConsumer<FavouriteBloc, FavouriteState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        bool isFavourite = false;
                        if (state is FavouriteSuccess) {
                          isFavourite = state.favourites.any((favourite) =>
                              favourite.productId ==
                              widget.productDetails["id"]);
                        }

                        return GestureDetector(
                          onTap: () {
                            String productId = widget.productDetails["id"];
                            String imageUrl = widget
                                .productDetails["uploadImages"][0]
                                .toString()
                                .trim();
                            String name = widget.productDetails["productName"];
                            double price =
                                widget.productDetails["price"]?.toDouble() ??
                                    0.0;
                            String favouriteId = "fav_$productId";

                            if (isFavourite) {
                              context
                                  .read<FavouriteBloc>()
                                  .add(RemoveFavouriteEvent(favouriteId));
                            } else {
                              FavouriteModel newFavourite = FavouriteModel(
                                productId: productId,
                                favouriteid: favouriteId,
                                imageUrl: imageUrl,
                                name: name,
                                price: price,
                              );
                              context
                                  .read<FavouriteBloc>()
                                  .add(AddFavouriteEvent(newFavourite));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavourite ? AppColors.kred : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Main Image Section
              BlocBuilder<ImagePrevBloc, ImagePrevState>(
                builder: (context, state) {
                  int selectedIndex = 0;
                  if (state is ImagePrevSelected) {
                    selectedIndex = state.selectedIndex;
                  }

                  String imageUrl = widget.productDetails["uploadImages"]
                          [selectedIndex]
                      .toString()
                      .trim();

                  return Center(
                    child: Container(
                      height: 250.h,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 50.sp, color: Colors.grey);
                        },
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 10.h),

              // Thumbnail Gallery
              SizedBox(
                height: 80.h,
                child: BlocBuilder<ImagePrevBloc, ImagePrevState>(
                  builder: (context, state) {
                    int selectedIndex = 0;
                    if (state is ImagePrevSelected) {
                      selectedIndex = state.selectedIndex;
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: widget.productDetails["uploadImages"].length,
                      itemBuilder: (context, index) {
                        String thumbUrl = widget.productDetails["uploadImages"]
                                [index]
                            .toString()
                            .trim();
                        bool isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            context.read<ImagePrevBloc>().add(ImagePrev(index));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15.w),
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primarycolor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            // Remove padding for full fit
                            padding: EdgeInsets.zero,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.network(
                                thumbUrl,
                                fit: BoxFit.cover,
                                width: 80.w,
                                height: 80.h,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 25.h),

              // Details Section in White Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(25.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20.r,
                      offset: Offset(0, -5.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: widget.productDetails["productName"],
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8.h),
                    TextCustom(
                      text: "₹${widget.productDetails["price"]}",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),

                    SizedBox(height: 30.h),

                    TextCustom(
                      text: "Select Size",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 15.h),

                    // Size Selector
                    SizedBox(
                      height: 60.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productDetails["sizes"].length,
                        itemBuilder: (context, index) {
                          final size = widget.productDetails["sizes"][index];
                          bool isSelected = selectedsize == size;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedsize = size;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 15.w),
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primarycolor
                                    : const Color(0xFFF7F7F7),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 5.h),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: TextCustom(
                                text: size,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 30.h),

                    TextCustom(
                      text: 'Product Description',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 12.h),
                    TextCustom(
                      text: "${widget.productDetails["productDescription"]}",
                      color: Colors.grey.shade600,
                      height: 1.6,
                      fontSize: 15.sp,
                    ),

                    SizedBox(height: 40.h),

                    // Add To Cart Button
                    ButtonCustomized(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      text: "Add To Cart",
                      color: AppColors.primarycolor,
                      height: 65.h,
                      width: double.infinity,
                      borderRadius: 20.r,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      onPressed: () async {
                        if (selectedsize == null) {
                          context.showWarningSnackBar(AppStrings.selectSize);
                          return;
                        }

                        final cartBloc = context.read<CartBloc>();
                        final CartRepositoryImplementation cartRepo =
                            CartRepositoryImplementation();

                        bool isInCart = await cartRepo
                            .isProductInCart(widget.productDetails["id"]);

                        if (isInCart) {
                          context.showErrorSnackBar(AppStrings.productInCart);
                          return;
                        }

                        final cartItem = CartModel(
                          productid: widget.productDetails["id"],
                          cartid: "generated_cart_id",
                          count: 1,
                          imageUrl: widget.productDetails["uploadImages"][0]
                              .toString()
                              .trim(),
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

                        context.showSuccessSnackBar(
                            "${widget.productDetails["productName"]}${AppStrings.addedToCartSuffix}");
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
