import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/presentation/Widget/Home/custom_product_card.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/pages/product_details.dart';
import 'package:flutter/material.dart';

class NewArivals extends StatelessWidget {
  const NewArivals({super.key});

  Future<List<Map<String, dynamic>>> fetchNewArrivals() async {
    var products = await fetchProducts();
    return products
        .where((product) => product['isNewArrival'] == true)
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
        title: const Text('New Arrivals'),
      ),
      body: FutureBuilder(
        future: fetchNewArrivals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          var topCollections = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              var product2 = topCollections[index];
              List<dynamic> imageList = product2['uploadImages'] ??
                  ['https://via.placeholder.com/100'];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetails(productDetails: product2),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Image.network(
                        imageList[0],
                        fit: BoxFit.cover,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextCustom(
                                text: product2['productName'] ?? "No Name"),
                            TextCustom(
                                text:
                                    "₹${product2['price']?.toString() ?? "No Price"}"),
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

// imageList: imageList,
//                 product1: product1,
//                 onTap: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => ProductDetails(
//                       productDetails: product1,
//                     ),
//                   ));
//                 },
