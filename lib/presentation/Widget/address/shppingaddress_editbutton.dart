import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/data/repository/address_service.dart';
import 'package:e_commerce_app/domain/model/address_model.dart';
import 'package:e_commerce_app/presentation/Widget/button.dart';
import 'package:e_commerce_app/presentation/Widget/scaffold_messenger.dart';
import 'package:e_commerce_app/presentation/pages/address/edit_address.dart';
import 'package:flutter/material.dart';

Row addressEditButton(double screenWidth, BuildContext context,
    AddressModel address, ShippingAddressImplement shippingAddressService) {
  return Row(
    children: [
      SizedBox(
        height: 60,
        width: screenWidth * 0.2,
        child: ButtonCustomized(
          text: "Edit",
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            height: 10,
          ),
          color: AppColors.primarycolor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditAddress(address: address)));
          },
        ),
      ),
      const SizedBox(width: 25),
      IconButton(
        onPressed: () {
          shippingAddressService.deleteAddress(address);
          showSnackBarMessage(context, "Address Deleted", Colors.green);
        },
        icon: const Icon(Icons.delete_outline_sharp,
            size: 35, color: Colors.grey),
      ),
    ],
  );
}
