// import 'package:e_commerce_shoes/data/repository/address_service.dart';
// import 'package:e_commerce_shoes/domain/model/address_model.dart';
// import 'package:e_commerce_shoes/presentation/Widget/scaffold_messenger.dart';
// import 'package:flutter/material.dart';

// Future editAddressEditButton(
//   BuildContext context,
//   GlobalKey<FormState> formKey,
//   TextEditingController nameController,
//   TextEditingController addressController,
//   TextEditingController pinController,
//   TextEditingController stateController,
//   TextEditingController phoneController,
//   AddressModel address,
// ) async {
//   // Validate the form
//   if (!formKey.currentState!.validate()) return;

//   final shippingAddressService = ShippingAddressImplement();
  
//   try {
//     // Perform the address edit operation
//     await shippingAddressService.editAddress(address);
    
//     // Display a success message
//     showSnackBarMessage(context, "Address edited successfully", Colors.green);
    
//     // Navigate to the ShippedAddress screen
//     Navigator.pushNamedAndRemoveUntil(
//       context,
//       "/ShippedAddress",
//       (route) => false,
//     );
//   } catch (error) {
//     // Handle the error case by showing an error message
//     showSnackBarMessage(context, "Failed to edit address: $error", Colors.red);
//   }
// }
