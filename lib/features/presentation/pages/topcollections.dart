import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Collection'),
      ),
      body: FutureBuilder(
        future: fetchTopCollections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display skeleton loaders
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4, // Number of skeleton items to display
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    margin: const EdgeInsets.all(10),
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

          // Display actual data
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              var product1 = topCollections[index];
              List<dynamic> imageList = product1['uploadImages'] ??
                  ['https://via.placeholder.com/100'];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetails(productDetails: product1),
                    ),
                  );
                },
                child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            imageList[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextCustom(
                              text: product1['productName'] ?? "No Name",
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            TextCustom(
                              text:
                                  "₹${product1['price']?.toString() ?? "No Price"}",
                              fontSize: 19,
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
            itemCount: topCollections.length,
          );
        },
      ),
    );
  }
}
