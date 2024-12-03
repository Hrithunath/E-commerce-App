import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/data/repository/address_service.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_Form_Feild.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextCustom(
          text: "Edit Address",
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primarycolor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Textformfeildcustom(
                    label: "Name",
                    prefixIcon: Icons.person_sharp,
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "Address",
                    prefixIcon: Icons.place,
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "Pin",
                    prefixIcon: Icons.pin,
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    validator: (value) => Validator.validatePinCode(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "District",
                    prefixIcon: Icons.business,
                    keyboardType: TextInputType.name,
                    controller: districtController, // Connect controller
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "State",
                    prefixIcon: Icons.business,
                    controller: stateController,
                    keyboardType: TextInputType.name,
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "Phone",
                    prefixIcon: Icons.phone,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    validator: (value) => Validator.validatePhoneNumber(value),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ButtonCustomized(
                      text: "Edit Address",
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        height: 10,
                      ),
                      color: AppColors.primarycolor,
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
                            showSnackBarMessage(context,
                                "Address edited successfully", Colors.green);
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/ShippedAddress", (route) => false);
                          } catch (e) {
                            showSnackBarMessage(context,
                                "Failed to edit address: $e", Colors.red);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
