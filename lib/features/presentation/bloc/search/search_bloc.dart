import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'search_event.dart';
part 'search_state.dart';

class ProductSearchBloc extends Bloc<SearchProductEvent, ProductSearchState> {
  final FirebaseFirestore firestore;
  ProductSearchBloc(this.firestore) : super(ProductSearchState(products: [])) {
    on<SearchByProductEvent>(searchByProductEvent);
  }

  FutureOr<void> searchByProductEvent(
      SearchByProductEvent event, Emitter<ProductSearchState> emit) async {
    if (event.query.isEmpty) {
      emit(ProductSearchState(products: []));
      return;
    }

    try {
      // Fetch all products and filter in Dart for case-insensitive search
      QuerySnapshot snapshot = await firestore.collection('products').get();
      final queryLower = event.query.toLowerCase();
      final products = snapshot.docs.where((doc) {
        final name = (doc['productName'] ?? '').toString().toLowerCase();
        return name.contains(queryLower);
      }).toList();

      if (products.isEmpty) {
        emit(ProductSearchState(products: []));
        print('No products found for query: \\${event.query}');
      } else {
        emit(ProductSearchState(products: products));
      }
    } catch (e) {
      emit(ProductSearchState(products: []));
      print('Error searching products: \\${e}');
    }
  }
}
