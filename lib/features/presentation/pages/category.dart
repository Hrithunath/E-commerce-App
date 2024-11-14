import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopCategory extends StatefulWidget {
  const TopCategory({super.key});

  @override
  _TopCategoryState createState() => _TopCategoryState();
}

class _TopCategoryState extends State<TopCategory> {
  String selectedCategoryId = ""; // Initially no category selected

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchProductsByCategory(
      String categoryId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryId)
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Categories'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Skeletonizer(
              enabled: true,
              child: Container(
                height: 100,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading categories"));
          }
          var categories = snapshot.data!;
          if (categories.isNotEmpty && selectedCategoryId.isEmpty) {
            selectedCategoryId =
                categories[0]['id']; // Default to first category
          }

          return Column(
            children: [
              // Category Selection Row
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryId = category['id'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: selectedCategoryId == category['id']
                              ? Colors.blueAccent
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            category['categoryName'] ?? "Category",
                            style: TextStyle(
                              color: selectedCategoryId == category['id']
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchProductsByCategory(selectedCategoryId),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      ));
                    }
                    if (productSnapshot.hasError) {
                      return const Center(
                          child: Text("Error loading products"));
                    }
                    var products = productSnapshot.data!;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        var product = products[index];
                        List<dynamic> imageList = product['uploadImages'] ??
                            ['https://via.placeholder.com/100'];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  productDetails: product,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    imageList[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TextCustom(
                                        text:
                                            product['productName'] ?? "No Name",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      TextCustom(
                                        text:
                                            "₹${product['price']?.toString() ?? "No Price"}",
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
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
