import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String name;  // Changed from username to name
  final String address;
  final String pincode;
  final String state;
  final String phone;

  AddressModel({
    required this.id,
    required this.name,  // Updated the constructor
    required this.address,
    required this.pincode,
    required this.state,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,  
      "address": address,
      "pincode": pincode,
      "state": state,
      "phone": phone,
    };
  }

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

    return AddressModel(
      id: doc.id,
      name: json["name"] ?? 'No Name',  // Updated to match field name
      address: json["address"] ?? 'No Address',
      pincode: json["pincode"] ?? 'No Pincode',
      state: json["state"] ?? 'No State',
      phone: json["phone"] ?? 'No Phone',
    );
  }
}
