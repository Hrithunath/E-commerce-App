import 'package:e_commerce_app/features/data/repository/address_service.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';
import 'package:e_commerce_app/features/presentation/pages/address/address.dart';
import 'package:flutter/material.dart';

Future<void> addAddress(
    BuildContext context,
    String? userId,
    TextEditingController nameController,
    TextEditingController addressController,
    TextEditingController pinController,
    TextEditingController districtController,
    TextEditingController stateController,
    TextEditingController phoneController,
    GlobalKey<FormState> formkey) async {
  if (formkey.currentState!.validate()) {
    ShippingAddressImplement shippingAddressImplement =
        ShippingAddressImplement();
    try {
      await shippingAddressImplement.saveAddress(
        AddressModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameController.text,
          address: addressController.text,
          pincode: pinController.text,
          district: districtController.text,
          state: stateController.text,
          phone: phoneController.text,
        ),
      );
      // Clear controllers after successful submission
      nameController.clear();
      addressController.clear();
      pinController.clear();
      stateController.clear();
      phoneController.clear();
      showSnackBarMessage(context, "Address added successfully", Colors.green);
      Navigator.of(context).pop(MaterialPageRoute(
          builder: (context) => ShippedAddress(
                userId: userId!,
                // isfromProfile: false,
              )));
    } catch (e) {
      showSnackBarMessage(context, "Failed to add address: $e", Colors.red);
    }
  }
}
