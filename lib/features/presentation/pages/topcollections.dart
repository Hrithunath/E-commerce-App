import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Topcollections extends StatelessWidget {
  const Topcollections({super.key});

  Future<List<Map<String, dynamic>>> fetchTopCollections() async {
    var products = await fetchProducts();
    return products
        .where((product) => product['isTopCollection'] == true)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final gridSpacing = screenWidth * 0.02;
    final gridItemHeight = screenHeight * 0.3;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: const Text('Popular Collection'),
      ),
      body: FutureBuilder(
        future: fetchTopCollections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              padding: EdgeInsets.all(gridSpacing),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: screenWidth / (2 * gridItemHeight),
                crossAxisSpacing: gridSpacing,
                mainAxisSpacing: gridSpacing,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          var topCollections = snapshot.data!;

          return GridView.builder(
            padding: EdgeInsets.all(gridSpacing),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: screenWidth / (2 * gridItemHeight),
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
            ),
            itemCount: topCollections.length,
            itemBuilder: (context, index) {
              var product = topCollections[index];
              List<dynamic> imageList = product['uploadImages'] ??
                  ['https://via.placeholder.com/100'];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetails(productDetails: product),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Image.network(
                            imageList[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextCustom(
                              text: product['productName'] ?? "No Name",
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                            TextCustom(
                              text:
                                  "₹${product['price']?.toString() ?? "No Price"}",
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
