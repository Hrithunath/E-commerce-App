import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/presentation/Widget/address/custom_address_button.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddress extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final AddressModel? address;
  AddAddress({super.key, this.address});

  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Prefill controllers if editing
    if (address != null) {
      nameController.text = address!.name;
      addressController.text = address!.address;
      pinController.text = address!.pincode;
      districtController.text = address!.district;
      stateController.text = address!.state;
      phoneController.text = address!.phone;
    }
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primarycolor,
        title: TextCustom(
          text: address == null ? "Add Address" : "Edit Address",
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildShadowedField(
                    child: CustomTextField(
                      hint: "Name",
                      prefix: Icon(Icons.person_outline,
                          color: Colors.grey.shade600),
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      validator: (value) => Validator.validateText(value),
                      fillColor: Colors.white,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildShadowedField(
                    child: CustomTextField(
                      hint: "Address",
                      prefix: Icon(Icons.location_on_outlined,
                          color: Colors.grey.shade600),
                      keyboardType: TextInputType.text,
                      controller: addressController,
                      validator: (value) => Validator.validateText(value),
                      fillColor: Colors.white,
                      borderColor: Colors.transparent,
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildShadowedField(
                    child: CustomTextField(
                      hint: "Pin",
                      prefix: Icon(Icons.tag, color: Colors.grey.shade600),
                      keyboardType: TextInputType.number,
                      controller: pinController,
                      validator: (value) => Validator.validatePinCode(value),
                      fillColor: Colors.white,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildShadowedField(
                    child: CustomTextField(
                      hint: "District",
                      prefix: Icon(Icons.location_city_outlined,
                          color: Colors.grey.shade600),
                      keyboardType: TextInputType.name,
                      controller: districtController,
                      validator: (value) => Validator.validateText(value),
                      fillColor: Colors.white,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildShadowedField(
                    child: CustomTextField(
                      hint: "State",
                      prefix:
                          Icon(Icons.map_outlined, color: Colors.grey.shade600),
                      keyboardType: TextInputType.text,
                      controller: stateController,
                      validator: (value) => Validator.validateText(value),
                      fillColor: Colors.white,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildShadowedField(
                    child: CustomTextField(
                      hint: "Phone",
                      prefix: Icon(Icons.phone_outlined,
                          color: Colors.grey.shade600),
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      validator: (value) =>
                          Validator.validatePhoneNumber(value),
                      fillColor: Colors.white,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  ButtonCustomized(
                    text: "Save",
                    height: 60.h,
                    width: double.infinity,
                    color: AppColors.primarycolor,
                    borderRadius: 15.r,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () async {
                      await addAddress(
                          context,
                          userId,
                          nameController,
                          addressController,
                          pinController,
                          districtController,
                          stateController,
                          phoneController,
                          formkey);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShadowedField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: child,
    );
  }
}
