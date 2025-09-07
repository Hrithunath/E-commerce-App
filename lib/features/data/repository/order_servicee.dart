import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/repository/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepositoryImplementation implements OrderRepository {
  @override
  Future<QuerySnapshot<Object?>>? fetchOrderDetails() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception("No user is signed in");
    }
    print(user.uid);

    try {
      final orderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .get();
      final dataMap = orderSnapshot.docs;
      print("hai$dataMap");
      return orderSnapshot;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
