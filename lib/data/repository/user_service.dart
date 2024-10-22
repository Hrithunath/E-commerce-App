import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/domain/repository/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImplements implements UserRepository {
  

  @override
  Future<void>getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
    .collection("users")
    .doc(user?.uid)
    .get();
  }
}