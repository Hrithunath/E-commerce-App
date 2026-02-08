import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/data/repository/address_service.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_field.dart';
import 'package:e_commerce_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditAddress extends StatefulWidget {
  final AddressModel address; // Existing address to be edited

  const EditAddress({super.key, required this.address});

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController pinController;
  late TextEditingController districtController;
  late TextEditingController stateController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing address data
    nameController = TextEditingController(text: widget.address.name);
    addressController = TextEditingController(text: widget.address.address);
    pinController = TextEditingController(text: widget.address.pincode);
    districtController = TextEditingController(text: widget.address.district);
    stateController = TextEditingController(text: widget.address.state);
    phoneController = TextEditingController(text: widget.address.phone);
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    addressController.dispose();
    pinController.dispose();
    districtController.dispose();
    stateController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextCustom(
          text: "Edit Address",
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primarycolor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildShadowedField(
                    child: CustomTextField(
                      hint: "Name",
                      prefix: Icon(Icons.person_outline,
                          color: Colors.grey.shade600),
                      controller: nameController,
                      keyboardType: TextInputType.text,
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
                      controller: addressController,
                      keyboardType: TextInputType.text,
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
                      controller: pinController,
                      keyboardType: TextInputType.number,
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
                      controller: stateController,
                      keyboardType: TextInputType.name,
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
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          Validator.validatePhoneNumber(value),
                      fillColor: Colors.white,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  ButtonCustomized(
                    text: "Edit Address",
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
                      if (formKey.currentState!.validate()) {
                        ShippingAddressImplement shippingAddressImplement =
                            ShippingAddressImplement();
                        try {
                          await shippingAddressImplement.editAddress(
                            AddressModel(
                              id: widget.address.id, // Use existing ID
                              name: nameController.text,
                              address: addressController.text,
                              pincode: pinController.text,
                              district: districtController.text,
                              state: stateController.text,
                              phone: phoneController.text,
                            ),
                          );
                          context.showSuccessSnackBar(AppStrings.addressEdited);
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/ShippedAddress", (route) => false);
                        } catch (e) {
                          context.showErrorSnackBar(
                              "${AppStrings.addressEditFailed}$e");
                        }
                      }
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
