import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProducts extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProducts({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryId)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        "id": doc["id"] ?? doc.id,
        "productName": doc["productName"] ?? "No Title",
        "price": doc["price"] ?? 0,
        "uploadImages": doc["uploadImages"] ?? [],
        "sizes": doc["sizes"] ?? [],
        "stock": doc["stock"] ?? 0,
        "productDescription": doc["productDescription"] ?? "",
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primarycolor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No products found in $categoryName",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio:
                  0.85, // Increased ratio to reduce overall height
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
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
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Top Image Area (Shaded Background)
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F1F1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: product["uploadImages"].isNotEmpty
                                    ? Image.network(
                                        product["uploadImages"][0],
                                        fit: BoxFit.contain,
                                        alignment: Alignment.bottomCenter,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                        
                          ],
                        ),
                      ),

                      // Bottom Details Area (White background part)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product["productName"] ?? "No Name",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1B20),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "₹${product["price"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2196F3),
                              ),
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
