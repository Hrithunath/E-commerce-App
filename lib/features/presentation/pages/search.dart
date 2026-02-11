import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_field.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/search/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchingProducts extends StatelessWidget {
  const SearchingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final gridSpacing = screenWidth * 0.02;
    final gridItemHeight = screenHeight * 0.3;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: null,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: CustomTextField(
                hint: 'Search products, brands, or styles',
                fillColor: Colors.white,
                borderColor: Colors.transparent,
                textStyle: TextStyle(
                  fontSize: 14.sp,
                ),
                autovalidateMode: AutovalidateMode.disabled,
                suffix: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.search,
                      color: AppColors.white,
                      size: 20.w,
                    ),
                  ),
                ),
                onChanged: (query) {
                  context
                      .read<ProductSearchBloc>()
                      .add(SearchByProductEvent(query: query));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductSearchBloc, ProductSearchState>(
                builder: (context, state) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }
                  return Padding(
                    padding: EdgeInsets.all(gridSpacing),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio:
                            screenWidth / (crossAxisCount * gridItemHeight),
                        crossAxisSpacing: gridSpacing,
                        mainAxisSpacing: gridSpacing,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        var product = state.products[index];
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
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TextCustom(
                                      text: productName,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                    TextCustom(
                                      text: "₹${price.toString()}",
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
