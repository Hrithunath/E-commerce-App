import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String name;
  final String address;
  final String pincode;
  final String district;
  final String state;
  final String phone;

  AddressModel({
    required this.id,
    required this.name,
    required this.address,
    required this.pincode,
    required this.district,
    required this.state,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "pincode": pincode,
      "district": district,
      "state": state,
      "phone": phone,
    };
  }

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

    return AddressModel(
      id: doc.id,
      name: json["name"] ?? 'No Name',
      address: json["address"] ?? 'No Address',
      pincode: json["pincode"] ?? 'No Pincode',
      district: json["district"] ?? 'No District',
      state: json["state"] ?? 'No State',
      phone: json["phone"] ?? 'No Phone',
    );
  }
}
