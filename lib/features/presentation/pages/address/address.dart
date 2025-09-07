import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/data/repository/address_service.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/address/custom_shpping_address_edit_button.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/bloc/address_checkbox/address_checkbox_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:e_commerce_app/features/presentation/pages/address/add_address.dart';
import 'package:e_commerce_app/features/presentation/pages/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Import Skeletonizer

class ShippedAddress extends StatelessWidget {
  final String userId;
  Map<String, Object>? cartData;
  late AddressModel address;

  ShippedAddress({super.key, required this.userId, this.cartData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final shippingAddressService = ShippingAddressImplement();
    cartData =
        ModalRoute.of(context)?.settings.arguments as Map<String, Object>?;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primarycolor,
        title: const TextCustom(
          text: "Address",
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddAddress()));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: shippingAddressService.fetchAddress(userId),
        builder: (context, snapshot) {
          // Skeletonizer loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  itemCount: 5, // Number of skeleton items to show
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300], // Skeleton item color
                      ),
                    );
                  },
                ),
              ),
            );
          }

          // Error handling state
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching address"),
            );
          }

          // No data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No addresses found",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            );
          }

          // Data available state
          var addressDocs = snapshot.data!.docs;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: addressDocs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var addressDoc = addressDocs[index];
                              address = AddressModel.fromFirestore(addressDoc);
                              var documentId = addressDoc.id;

                              return SizedBox(
                                height: screenHeight * 0.319,
                                width: double.infinity,
                                child: Card(
                                  elevation: 7,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        color: AppColors.primarycolor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: TextCustom(
                                                text: address.name,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w800,
                                                height: 3,
                                              ),
                                            ),
                                            BlocBuilder<AddressCheckboxBloc,
                                                AddressCheckBoxState>(
                                              builder: (context, state) {
                                                return Row(
                                                  children: [
                                                    Checkbox(
                                                      value: state.isSelected(
                                                          documentId),
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                AddressCheckboxBloc>()
                                                            .add(ToggleAddressCheckbox(
                                                                documentId:
                                                                    documentId));
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        TextCustom(
                                          text: address.address,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                        TextCustom(
                                          text:
                                              "${address.pincode},\n${address.state}",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 10),
                                        TextCustom(
                                          text: "Ph: ${address.phone}",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 20),
                                        addressEditButton(
                                          screenWidth,
                                          context,
                                          address,
                                          shippingAddressService,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: 55,
                              width: 300,
                              child: ButtonCustomized(
                                text: "Check Out",
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  height: 10,
                                ),
                                color: AppColors.primarycolor,
                                onPressed: () {
                                  // Get the selected address document IDs
                                  final selectedAddressId = context
                                      .read<AddressCheckboxBloc>()
                                      .state
                                      .selectedDocumentId;

                                  if (selectedAddressId == null) {
                                    showSnackBarMessage(
                                        context,
                                        "Please select a delivery address",
                                        Colors.red);
                                  } else {
                                    // Find the selected address based on its document ID
                                    final selectedAddressDoc =
                                        addressDocs.firstWhere(
                                      (doc) => doc.id == selectedAddressId,
                                    );

                                    final selectedAddress =
                                        AddressModel.fromFirestore(
                                            selectedAddressDoc);

                                    final cartItems = (context
                                            .read<CartBloc>()
                                            .state as CartLoadedState)
                                        .cartItems;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Checkout(
                                          cartItems: cartItems,
                                          address: selectedAddress,
                                          cartData: cartData,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
