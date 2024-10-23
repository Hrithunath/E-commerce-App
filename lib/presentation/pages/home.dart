import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/presentation/Widget/Home/custom_product%7C_category.dart';
import 'package:e_commerce_app/presentation/Widget/Home/custom_product_card.dart';
import 'package:e_commerce_app/presentation/Widget/Home/custom_text_row.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/Widget/textFormFeild.dart';
import 'package:e_commerce_app/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/presentation/pages/product_details.dart';
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Textformfeildcustom(
                      label: "Search Product",
                      prefixIcon: Icons.search,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // First Carousel (Promotional Banners)
              SizedBox(
                height: 350,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: 380,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://img.freepik.com/free-vector/sale-banner-with-product-description_1361-1333.jpg?w=1380&t=st=1725946972~exp=1725947572~hmac=eddb2aa0c02c8159b3c65b763b416224bf249c7d7f6e279a77488f75cc0050d4",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Top Categories Section
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextCustom(
                    text: "Top Categories",
                    fontWeight: FontWeight.w600,
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
                        print('$category');

                        String imageUrl = category['imageUrl'] ??
                            'https://via.placeholder.com/100';

                        return CustomProductCategory(
                            category: category, imageUrl: imageUrl);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Second Carousel Top collection
              const CustomTextRow(
                  leading: "Popular collections", trailing: "See More"),
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
                            'https://via.placeholder.com/100';
                        print("$product1");
                        return CustomProductCard(
                            imageList: imageList,
                            product1: product1,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                        productDetails: product1,
                                      )));
                            });
                      },
                    ),
                  );
                },
              ),
              // New Arrivals Section
              const CustomTextRow(
                  leading: "New Arrivals", trailing: "See More"),
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
                            'https://via.placeholder.com/100';
                        return CustomProductCard(
                            imageList: imageList,
                            product1: product2,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                        productDetails: product2,
                                      )));
                            });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
