import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_appbar.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_primary_header_container.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_product%7C_category.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_product_card.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_text_row.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_Form_Feild.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/presentation/pages/new_arivals.dart';
import 'package:e_commerce_app/features/presentation/pages/product_details.dart';
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
    return SingleChildScrollView(
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
                  subtitle: TextCustom(
                    text: "Hrithunath",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Textformfeildcustom(
                          fillColor: Colors.white,
                          hintText: "Search Product",
                          prefixIcon: Icons.search,
                          onChanged: (value) {},
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
                      return Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey[300],
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
                          String imageUrl = category['imageUrl'] ??
                              'https://via.placeholder.com/100';

                          return CustomProductCategory(
                              category: category, imageUrl: imageUrl);
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
          SizedBox(
            height: 330,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchBanner(),
              builder: (context, snapshot) {
                // Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 330,
                      color: Colors.grey[300],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No banners found");
                }

                var banners = snapshot.data!;

                return CarouselSlider(
                  items: banners.map((banner) {
                    String imageUrl = banner['imageurl'] ??
                        'https://via.placeholder.com/350x330';
                    print('Image URL: $imageUrl');

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 330,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                  ),
                );
              },
            ),
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
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No Top Collections found");
              }

              var topCollections = snapshot.data!;
              return SizedBox(
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
                    builder: (context) => const NewArivals()));
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
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No New Arrivals found");
              }

              var newArrivals = snapshot.data!;
              return SizedBox(
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
              );
            },
          ),
        ],
      ),
    );
  }
}
