import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/model/address_model.dart';
import 'package:e_commerce_app/features/domain/repository/address_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShippingAddressImplement implements ShippingAddress {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveAddress(AddressModel address) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("address")
          .add({
        "id": address.id,
        "name": address.name,
        "address": address.address,
        "pincode": address.pincode,
        "district": address.district,
        "state": address.state,
        "phone": address.phone,
      });
    } catch (e) {
      throw Exception("failed to save address$e");
    }
  }

  @override
  Stream<QuerySnapshot<Object?>> fetchAddress(String userId) {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    if (user.uid != userId) {
      throw Exception("Cannot fetch addresses for another user");
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .collection("address")
        .snapshots();
  }

  @override
  Future<void> deleteAddress(AddressModel address) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }

    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("address")
          .doc(address.id)
          .delete();
    } catch (e) {
      throw Exception("failed to delete$e");
    }
  }

  @override
  Future<void> editAddress(AddressModel address) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }

    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("address")
          .doc(address.id)
          .update({
        "name": address.name,
        "address": address.address,
        "pincode": address.pincode,
        "district": address.district,
        "state": address.state,
        "phone": address.phone,
      });
    } catch (e) {
      throw Exception("failed to delete$e");
    }
  }
}
