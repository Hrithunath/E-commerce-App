import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/data/repository/address_service.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_alert_dialog.dart';
import 'package:e_commerce_app/features/presentation/pages/address/edit_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Row addressEditButton(BuildContext context, AddressModel address,
    ShippingAddressImplement shippingAddressService) {
  return Row(
    children: [
      Expanded(
        child: ButtonCustomized(
          text: "Edit",
          height: 45.h,
          color: AppColors.primarycolor,
          borderRadius: 10.r,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.white,
            size: 18.sp,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditAddress(address: address)));
          },
        ),
      ),
      SizedBox(width: 15.w),
      Expanded(
        child: ButtonCustomized(
          text: "Delete",
          height: 45.h,
          color: AppColors.primarycolor,
          borderRadius: 10.r,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          icon: Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 18.sp,
          ),
          onPressed: () {
            DialogHelper.showAlertDialog(
              context: context,
              title: "Remove Address",
              content: const Text(
                  "Are you sure you want to remove this item from Address?"),
              onConfirm: () async {
                await shippingAddressService.deleteAddress(address);
                if (context.mounted) {
                  // Navigator.of(context).pop(); // Handled by dialog
                }
              },
              confirmText: "Remove",
              confirmColor: AppColors.errorRed,
            );
          },
        ),
      ),
    ],
  );
}
