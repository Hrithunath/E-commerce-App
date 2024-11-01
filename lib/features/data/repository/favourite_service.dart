import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/model/favourite_model.dart';
import 'package:e_commerce_app/features/domain/repository/favourite_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouritesRepositoryImplementation implements FavouriteRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addFavouriteService(FavouriteModel favourite) async {
    User? user = _firebaseAuth.currentUser;
    print("Adding favourite for user: ${user?.uid}");
    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    try {
      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .add({
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
  Future<void> removeFavouriteService(String favouriteId) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    try {
      // Check if the document exists before attempting to delete
      DocumentSnapshot snapshot = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .doc(favouriteId)
          .get();

      if (!snapshot.exists) {
        print("Favourite with ID: $favouriteId does not exist.");
        return; // Or throw an exception if needed
      }

      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .doc(favouriteId)
          .delete();
      print("Successfully removed favourite with ID: $favouriteId");
    } catch (e) {
      print("Error removing favourite: $e");
      rethrow;
    }
  }

  @override
  Future<List<FavouriteModel>> getFavouriteService() async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
          code: "USER_NOT_LOGGED_IN", message: "User must be logged in");
    }
    try {
      final querySnapshot = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .get();
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
