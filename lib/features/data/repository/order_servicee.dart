import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/repository/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class orderRepositoryImplementation implements OrderRepository {
  @override
  Future<void> fetchOrderDetails() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;

    if (user == null) {
      print("No User is SignedIn");
      return;
    }

    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .orderBy('timeStamp', descending: true)
          .get();
    } catch (e) {
      print('Failed to fetch order: $e');
    }
  }
}
