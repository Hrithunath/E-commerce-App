import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/data/repository/address_service.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_alert_dialog.dart';
import 'package:e_commerce_app/features/presentation/pages/address/edit_address.dart';
import 'package:flutter/material.dart';

Row addressEditButton(double screenWidth, BuildContext context,
    AddressModel address, ShippingAddressImplement shippingAddressService) {
  return Row(
    children: [
      SizedBox(
        height: 50,
        width: screenWidth * 0.3,
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
      SizedBox(
        height: 50,
        width: screenWidth * 0.27,
        child: ButtonCustomized(
          text: "Delete",
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            height: 10,
          ),
          color: AppColors.primarycolor,
          onPressed: () {
            showAlertDialog(
              context,
              "Remove Address",
              "Are you sure you want to remove this item from Address?",
              () {
                shippingAddressService.deleteAddress(address);
              },
            );
          },
        ),
      ),
    ],
  );
}
