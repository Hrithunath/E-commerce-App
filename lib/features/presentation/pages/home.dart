import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_appbar.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_primary_header_container.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_product_card.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_product_category.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_text_row.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_Form_Feild.dart';
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
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const Home(),
    );
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
      body:  SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppbar(
                    title: TextCustom(
                        text: "Good day for shopping",
                        fontSize: 14,
                        color: Colors.white),
                    subtitle: UsernameWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Textformfeildcustom(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchingProducts()));
                            },
                            fillColor: Colors.white,
                            hintText: "Search Product",
                            prefixIcon: Icons.search,
                            onChanged: (query) {
                              if (query.isEmpty) {
                                // Emit an empty search query to revert to the default product list
                                context
                                    .read<ProductSearchBloc>()
                                    .add(SearchByProductEvent(query: query));
                              } else {
                                // Trigger search when query is not empty
                                context
                                    .read<ProductSearchBloc>()
                                    .add(SearchByProductEvent(query: query));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
      
                  // Top Categories Section
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextCustom(
                        text: "Top Categories",
                        fontSize: 17,
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
                          height: 100,
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
                                    width: 70,
                                    height: 70,
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
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            var category = categories[index];
                            String imageUrl = category['imageUrl'] ?? '';
      
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>  CategoryProducts(
                          categoryId: category["id"],
                          categoryName: category["categoryName"],
                        ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/placeholder-images-image_large.webp', // Path to placeholder image
                                        image: imageUrl.isNotEmpty
                                            ? imageUrl
                                            : 'https://via.placeholder.com/100',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          // Fallback widget for broken images
                                          return Container(
                                            width: 70,
                                            height: 70,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.broken_image,
                                              size: 30,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      category['categoryName'] ??
                                          'Unknown', // Display category name
                                      style: const TextStyle(fontSize: 12,color: Colors.white,),
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
      
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
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
                      height: 300,
                      width: 300,
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
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder:
                              'assets/images/placeholder-images-image_large.webp', // Placeholder image
                          image: imageUrl.isNotEmpty
                              ? imageUrl
                              : 'https://via.placeholder.com/300',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          imageErrorBuilder: (context, error, stackTrace) {
                            // Show a fallback widget if the image fails to load
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
                      height: 300,
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
      
            const SizedBox(height: 20),
            // Second Carousel Top collection
            Padding(
              padding: const EdgeInsets.all(16),
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
                    height: 350,
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
                    height: 350,
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
          return Skeletonizer(
            enabled: true,
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          );
        }

        if (state is AuthenticatedState) {
          // Display user's name if available
          final String username = state.username ?? 'Unknown User';

          return Text(
            username,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          );
        }

        if (state is AuthErrorState) {
          return Text('Error: ${state.errorMessage}');
        }

        return const Text('User not logged in');
      },
    );
  }
}
