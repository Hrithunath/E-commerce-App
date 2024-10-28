import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/repository/cart_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepositoryImplementation implements CartRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addToCart(
    String productId,
    String productName,
    String price,
    String quantity,
    String image,
    String size,
    String stock,
  ) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentReference cartRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc();

        await cartRef.set({
          'cartId': cartRef.id,
          'productId': productId,
          'productName': productName,
          'price': price,
          'quantity': quantity,
          'image': image,
          'size': size,
          'stock': stock
        });
      } else {
        throw Exception('No user is logged in.');
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  // Future<void> addToCart(String productId, String productName, String price,
  //     String quantity, String image,String size,String stock,) async {
  //   try {
  //     User? user = _firebaseAuth.currentUser;
  //     if (user != null) {
  //       DocumentReference cartRef = _firestore
  //           .collection('users')
  //           .doc(user.uid)
  //           .collection('cart')
  //           .doc(productId);

  //       await cartRef.set({
  //         'productId':productId,
  //         'productName': productName,
  //         'price': price,
  //         'quantity': quantity,
  //         'image': image,
  //         'size': size,
  //         'stock':stock
  //       });
  //     } else {
  //       throw Exception('No user is logged in.');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to add to cart: $e');
  //   }
  // }

  @override
  Future<List<Map<String, dynamic>>> fetchCart() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        QuerySnapshot cartSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();

        return cartSnapshot.docs.map((doc) {
          return {
            'cartId': doc.id,
            'productName': doc['productName'],
            'price': doc['price'],
            'quantity': doc['quantity'],
            'image': doc['image'],
            'size': doc['size'],
            'stock': doc['stock'],
            'productId': doc['productId']
          };
        }).toList();
      } else {
        throw Exception('No user is logged in.');
      }
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  // Check if the product already exists in the cart
  Future<bool> isProductInCart(String productId) async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        // Query the cart collection for the specific productId
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .where('productId', isEqualTo: productId)
            .get();

        // Return true if the product exists, false otherwise
        return querySnapshot.docs.isNotEmpty;
      } else {
        return false; // User not logged in
      }
    } catch (e) {
      // Handle errors
      print('Error checking product in cart: $e');
      return false;
    }
  }

  // Fetch product by productId
  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      DocumentSnapshot productSnapshot =
          await _firestore.collection('products').doc(productId).get();

      if (productSnapshot.exists) {
        return productSnapshot.data() as Map<String, dynamic>?;
      } else {
        print("Product not found");
        return null;
      }
    } catch (e) {
      print("Error fetching product: $e");
      return null;
    }
  }

  @override
  Future<void> deleteCartItem(String docId) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cart')
          .doc(docId)
          .delete();
    } catch (e) {
      print('error : $e');
      throw Exception('Failed to delete product. Please try again');
    }
  }

  @override
  Future<void> updateItemQuantity(String productId,
      {required bool increment}) async {
    User? user = _firebaseAuth.currentUser;
    var item = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .doc(productId)
        .get();

    if (item.exists) {
      int currentQuantity = int.tryParse(item['quantity']) ?? 1;
      int newQuantity = increment ? currentQuantity + 1 : currentQuantity - 1;

      // Ensure quantity doesn't drop below 1
      if (newQuantity > 0) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(productId)
            .update({
          'quantity': newQuantity.toString(),
        });
      }
    }
  }

  @override
  Future<void> clearCart() async {
    User? user = _firebaseAuth.currentUser;

    try {
      // Reference to the user's cart collection
      CollectionReference cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('cart');

      // Fetch all documents in the cart collection
      QuerySnapshot cartItems = await cartCollection.get();

      // Delete each document
      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
