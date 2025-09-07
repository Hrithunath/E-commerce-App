import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/model/favourite_model.dart';
import 'package:e_commerce_app/features/domain/repository/favourite_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouritesRepositoryImplementation implements FavouriteRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addFavouriteService(FavouriteModel favourite) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      print("Error: User must be logged in to add favourites.");
      return;
    }

    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .doc(favourite.favouriteid)
          .set({
        "id": favourite.favouriteid,
        "name": favourite.name,
        "price": favourite.price,
        "image": favourite.imageUrl,
        "productId": favourite.productId,
      });
      print(
          "Added favourite with ID: ${favourite.favouriteid} for user: ${user.uid}");
    } catch (e) {
      print("Error adding favourite: $e");
    }
  }

  @override
  Future<void> removeFavouriteService(String favouriteId) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      print("Error: User must be logged in to remove favourites.");
      return;
    }

    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .doc(favouriteId)
          .delete();
      print(
          "Successfully removed favourite with ID: $favouriteId for user: ${user.uid}");
    } catch (e) {
      print("Error removing favourite: $e");
    }
  }

  @override
  Future<List<FavouriteModel>> getFavouriteService() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      print("Error: User must be logged in to view favourites.");
      return [];
    }

    try {
      final querySnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return FavouriteModel(
          favouriteid: doc.id,
          name: data['name'] as String,
          price: data['price'] as double,
          imageUrl: data['image'] as String,
          productId: data['productId'] as String,
        );
      }).toList();
    } catch (e) {
      print("Error fetching favourites: $e");
      return [];
    }
  }
}
