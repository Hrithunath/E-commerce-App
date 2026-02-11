import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_appbar.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_primary_header_container.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_product_card.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_text_row.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_field.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/search/search_bloc.dart';
import 'package:e_commerce_app/features/presentation/pages/category.dart';
import 'package:e_commerce_app/features/presentation/pages/new_arivals.dart';
import 'package:e_commerce_app/features/presentation/pages/product_details.dart';
import 'package:e_commerce_app/features/presentation/pages/search.dart';
import 'package:e_commerce_app/features/presentation/pages/topcollections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  Future<List<Map<String, dynamic>>> fetchBanner() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('banner').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchTopCollections() async {
    var products = await fetchProducts();
    return products
        .where((product) => product['isTopCollection'] == true)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchNewArrivals() async {
    var products = await fetchProducts();
    return products
        .where((product) => product['isNewArrival'] == true)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(CheckLoginStatusEvent());
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  CustomAppbar(
                    title: const UsernameWidget(),
                    subtitle: TextCustom(
                        text: "Welcome to Stride Smart",
                        fontSize: 14.sp,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hint: 'Search products, brands, or styles',
                                    fillColor: Colors.white,
                                    borderColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SearchingProducts()));
                                    },
                                    textStyle: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                    autovalidateMode: AutovalidateMode.disabled,
                                    suffix: Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.primarycolor,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          Icons.search,
                                          color: AppColors.white,
                                          size: 20.w,
                                        ),
                                      ),
                                    ),
                                    onChanged: (query) {
                                      if (query.isEmpty) {
                                        // Emit an empty search query to revert to the default product list
                                        context.read<ProductSearchBloc>().add(
                                            SearchByProductEvent(query: query));
                                      } else {
                                        // Trigger search when query is not empty
                                        context.read<ProductSearchBloc>().add(
                                            SearchByProductEvent(query: query));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Categories Section
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextCustom(
                        text: "Top Categories",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Skeleton for categories
                        return SizedBox(
                          height: 100.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5, // Number of skeletons to show
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Skeletonizer(
                                  enabled: true,
                                  child: Container(
                                    width: 70.w,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No categories found");
                      }

                      var categories = snapshot.data!;
                      return SizedBox(
                        height: 100.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            var category = categories[index];
                            String imageUrl = category['imageUrl'] ?? '';

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CategoryProducts(
                                      categoryId: category["id"],
                                      categoryName: category["categoryName"],
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        imageUrl.isNotEmpty
                                            ? imageUrl
                                            : 'https://via.placeholder.com/100',
                                        width: 70.w,
                                        height: 70.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 70.w,
                                            height: 70.h,
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 30.sp,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      category['categoryName'] ??
                                          'Unknown', // Display category name
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // First Carousel (Promotional Banners)
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchBanner(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a placeholder while loading
                  return Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 180.h,
                      width: 300.w,
                      color: Colors.grey[400],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No banners found");
                } else {
                  var banners = snapshot.data!;

                  return CarouselSlider(
                    items: banners.map((banner) {
                      String imageUrl = banner['imageurl'] ?? '';

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          imageUrl.isNotEmpty
                              ? imageUrl
                              : 'https://via.placeholder.com/300',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 180.h,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 16 / 9,
                    ),
                  );
                }
              },
            ),

            // Second Carousel Top collection
            Padding(
              padding: EdgeInsets.all(16.r),
              child: CustomTextRow(
                leading: "Popular Collections",
                trailing: "See More",
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Topcollections()));
                },
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchTopCollections(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 300,
                      width: 300,
                      color: Colors.grey[300],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No Top Collections found");
                }

                var topCollections = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topCollections.length,
                      itemBuilder: (context, index) {
                        var product1 = topCollections[index];
                        List<dynamic> imageList = product1['uploadImages'] ??
                            ['https://via.placeholder.com/100'];
                        return CustomProductCard(
                          imageList: imageList,
                          product1: product1,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      productDetails: product1,
                                    )));
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            // New Arrivals Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextRow(
                leading: "New Arrivals",
                trailing: "See More",
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NewArrivals()));
                },
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchNewArrivals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 300,
                      width: 300,
                      color: Colors.grey[300],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No New Arrivals found");
                }

                var newArrivals = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newArrivals.length,
                      itemBuilder: (context, index) {
                        var product2 = newArrivals[index];
                        List<dynamic> imageList = product2['uploadImages'] ??
                            ['https://via.placeholder.com/100'];
                        return CustomProductCard(
                          imageList: imageList,
                          product1: product2,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      productDetails: product2,
                                    )));
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 100.h), // Space for floating navbar
          ],
        ),
      ),
    );
  }
}

class UsernameWidget extends StatelessWidget {
  const UsernameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const Center(
            child: SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          );
        }

        if (state is AuthenticatedState) {
          // Display user's name if available
          final String username = state.username ?? 'Unknown User';

          return Text(
            'Hello, $username',
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          );
        }

        if (state is AuthErrorState) {
          return Text('Error: ${state.errorMessage}');
        }

        // While waiting for state, show nothing (prevents 'User not logged in' flash)
        return const SizedBox.shrink();
      },
    );
  }
}
