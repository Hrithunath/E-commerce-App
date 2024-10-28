import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/features/domain/repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartInitialState()) {
    on<AddToCartEvent>(addToCart);
    on<FetchCartEvent>(fetchCart);
    on<DeleteCartItemEvent>(deleteCartItemEvent);
    on<IncrementQuantityEvent>(incrementQuantity);
    on<DecrementQuantityEvent>(decrementQuantity);
    on<ClearCartEvent>(clearCart);
  }

  FutureOr<void> addToCart(
      AddToCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await cartRepository.addToCart(
          event.productId,
          event.productName,
          event.productPrice,
          event.productQuantity,
          event.image,
          event.size,
          event.stock);
      final cartItems = await cartRepository.fetchCart();
      emit(CartLoadedState(cartItems));
    } catch (e) {
      emit(CartErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> fetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final cartItems = await cartRepository.fetchCart();
      emit(CartLoadedState(cartItems));
    } catch (e) {
      emit(CartErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> deleteCartItemEvent(
      DeleteCartItemEvent event, Emitter<CartState> emit) async {
    if (state is CartLoadedState) {
      final currentState = state as CartLoadedState;
      final updatedCartItems =
          List<Map<String, dynamic>>.from(currentState.cartItems);

      updatedCartItems.removeWhere((item) => item['cartId'] == event.cartId);

      emit(CartLoadedState(updatedCartItems));

      try {
        await cartRepository.deleteCartItem(event.cartId);
      } catch (e) {
        emit(CartErrorState(errorMessage: e.toString()));

        final fetchedCartItems = await cartRepository.fetchCart();
        emit(CartLoadedState(fetchedCartItems));
      }
    }
  }

  void incrementQuantity(
      IncrementQuantityEvent event, Emitter<CartState> emit) {
    if (state is CartLoadedState) {
      final currentState = state as CartLoadedState;
      final updatedCartItems =
          List<Map<String, dynamic>>.from(currentState.cartItems);

      final index = updatedCartItems
          .indexWhere((item) => item['productId'] == event.productId);
      if (index != -1) {
        final updatedItem = Map<String, dynamic>.from(updatedCartItems[index]);
        int currentQuantity = updatedItem['count'] ?? 1;
        updatedItem['count'] = currentQuantity + 1;
        updatedCartItems[index] = updatedItem;

        emit(CartLoadedState(updatedCartItems));
      }
    }
  }

  void decrementQuantity(
      DecrementQuantityEvent event, Emitter<CartState> emit) {
    if (state is CartLoadedState) {
      final currentState = state as CartLoadedState;
      final updatedCartItems =
          List<Map<String, dynamic>>.from(currentState.cartItems);

      final index = updatedCartItems
          .indexWhere((item) => item['productId'] == event.productId);
      if (index != -1) {
        final updatedItem = Map<String, dynamic>.from(updatedCartItems[index]);
        int currentQuantity = updatedItem['count'] ?? 1;

        if (currentQuantity > 1) {
          updatedItem['count'] = currentQuantity - 1;
          updatedCartItems[index] = updatedItem;

          emit(CartLoadedState(updatedCartItems));
        }
      }
    }
  }

  FutureOr<void> clearCart(event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await cartRepository.clearCart();
      emit(CartLoadedState([]));
    } catch (e) {
      emit(CartErrorState(errorMessage: e.toString()));
    }
  }
}
