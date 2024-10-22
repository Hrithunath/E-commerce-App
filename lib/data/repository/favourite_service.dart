import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/domain/model/favourite_model.dart';
import 'package:e_commerce_app/domain/repository/favourite.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouritesRepositoryImplementation implements FavouriteRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addFavourite(FavouriteModel favourite) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    try {
      await firestore.collection("users").doc(user.uid).collection("favourites").add({
        "id": favourite.favouriteid,
        "name": favourite.name,
        "price": favourite.price,
        "image": favourite.imageUrl,
        "productId": favourite.productId
      });
    } catch (e) {
   
      print("Error adding favourite: $e");
      rethrow; 
    }
  }

  @override
  Future<void> removeFavourite(String favouriteId) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    try {
      await firestore.collection("users").doc(user.uid).collection("favourites").doc(favouriteId).delete();
    } catch (e) {
    
      print("Error removing favourite: $e");
      rethrow; 
  }

 
}

  @override
  Future<List<FavouriteModel>> getFavourite()async {
    
     User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    try {
      final querySnapshot = await firestore.collection("users").doc(user.uid).collection("favourites").get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return FavouriteModel(
          favouriteid: doc.id,
          name: data['name'],
          price: data['price'],
          imageUrl: data['image'],
          productId: data['productId'],
        );
      }).toList();
    } catch (e) {
      
      print("Error fetching favourites: $e");
      rethrow; 
    }
  }

}