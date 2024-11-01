import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/model/user_model.dart';
import 'package:e_commerce_app/features/domain/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImplementation implements UserRepository {
  @override
  Future<UserModel> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user signed in');
    }
    print('Current user UID: ${user.uid}');
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    print('User document exists: ${userDoc.exists}');
    if (!userDoc.exists) {
      throw Exception('User not found in Firestore');
    }

    String? name = userDoc.get('name') as String?;
    String? email = userDoc.get('email') as String?;

    return UserModel(
      name: name,
      email: email,
      uid: user.uid,
    );
  }
}
