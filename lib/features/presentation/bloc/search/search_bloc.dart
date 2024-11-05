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
      QuerySnapshot snapshot = await firestore
          .collection('products')
          .where('productName', isGreaterThanOrEqualTo: event.query)
          .where('productName', isLessThanOrEqualTo: '${event.query}\uf8ff')
          .get();

      final products = snapshot.docs;

      if (products.isEmpty) {
        emit(ProductSearchState(products: []));
        print('No products found for query: ${event.query}');
      } else {
        emit(ProductSearchState(products: products));
      }
    } catch (e) {
      emit(ProductSearchState(products: []));
      print('Error searching products: $e');
    }
  }
}
