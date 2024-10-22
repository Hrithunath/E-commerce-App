import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/data/repository/address_service.dart';
import 'package:e_commerce_app/domain/model/address_model.dart';
import 'package:e_commerce_app/presentation/Widget/address/shppingaddress_editbutton.dart';
import 'package:e_commerce_app/presentation/Widget/button.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/bloc/address_checkbox/address_checkbox_bloc.dart';
import 'package:e_commerce_app/presentation/pages/address/add_address.dart';
import 'package:e_commerce_app/presentation/pages/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for Bloc

class ShippedAddress extends StatefulWidget {
  final String userId;

  const ShippedAddress({super.key, required this.userId});

  @override
  State<ShippedAddress> createState() => _ShippedAddressState();
}

class _ShippedAddressState extends State<ShippedAddress> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final shippingAddressService = ShippingAddressImplement();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddAddress()));
            },
            icon: const Icon(Icons.add, color: Colors.black),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: shippingAddressService.fetchAddress(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching address"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No addresses found",
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            );
          }

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
                              var address = AddressModel.fromFirestore(addressDoc);
                              var documentId = addressDoc.id; // Get the document ID for Bloc

                              return SizedBox(
                                height: screenHeight * 0.35,
                                width: double.infinity,
                                child: Card(
                                  elevation: 7,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: AppColors.primarycolor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                      value: state.isSelected(documentId),
                                                      onChanged: (value) {
                                                        context
                                                            .read<AddressCheckboxBloc>()
                                                            .add(ToggleAddressCheckbox(
                                                                documentId: documentId));
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
                                          text: "${address.pincode},\n${address.state}",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 15),
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
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ButtonCustomized(
                      text: "Submit Order",
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        height: 10,
                      ),
                      color: AppColors.primarycolor,
                      onPressed: () {
                       Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => FlipCardAnimation()));
                      },
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
