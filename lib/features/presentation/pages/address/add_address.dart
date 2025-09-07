import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/presentation/Widget/address/custom_address_button.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_Form_Feild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  AddAddress({super.key});

  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primarycolor,
        title: const TextCustom(
          text: "Add Address",
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Textformfeildcustom(
                    label: "Name",
                    prefixIcon: Icons.person_sharp,
                    keyboardType: TextInputType.text,
                    controller: nameController, // Connect controller
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "Address",
                    prefixIcon: Icons.place,
                    keyboardType: TextInputType.text,
                    controller: addressController, // Connect controller
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "Pin",
                    prefixIcon: Icons.pin,
                    keyboardType: TextInputType.number,
                    controller: pinController, // Connect controller
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
                    keyboardType: TextInputType.text,
                    controller: stateController, // Connect controller
                    validator: (value) => Validator.validateText(value),
                  ),
                  const SizedBox(height: 10),
                  Textformfeildcustom(
                    label: "Phone",
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.number,
                    controller: phoneController, // Connect controller
                    validator: (value) => Validator.validatePhoneNumber(value),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ButtonCustomized(
                      text: "Add Address",
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        height: 10,
                      ),
                      color: AppColors.primarycolor,
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
