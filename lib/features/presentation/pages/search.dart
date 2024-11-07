import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_Form_Feild.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/search/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchingProducts extends StatelessWidget {
  const SearchingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Textformfeildcustom(
            fillColor: Colors.white,
            hintText: "Search Product",
            prefixIcon: Icons.search,
            onChanged: (query) {
              // Emit the search event directly via the bloc when the query changes
              context
                  .read<ProductSearchBloc>()
                  .add(SearchByProductEvent(query: query));
            },
          ),
        ),
        body: BlocBuilder<ProductSearchBloc, ProductSearchState>(
          builder: (context, state) {
            if (state.products.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  var product = state.products[index];
                  // Access product data from the QueryDocumentSnapshot
                  var productName = product['productName'] ?? "No Name";
                  var price = product['price'] ?? 0;
                  var imageList = product['uploadImages'] ??
                      ['https://via.placeholder.com/100'];

                  return Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextCustom(
                                text: productName,
                              ),
                              TextCustom(
                                text: "₹${price.toString()}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
