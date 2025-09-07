part of 'cart_bloc.dart';

abstract class CartEvent{}

class AddToCartEvent extends CartEvent{
  final String productId;
  final String productName;
  final String productPrice;
  final String productQuantity;
  final String image; 
  final String size;
  final String stock;

  AddToCartEvent({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.image,
    required this.size,
    required this.stock
  });
}

class FetchCartEvent extends CartEvent {}

class DeleteCartItemEvent extends CartEvent{
  final String cartId;
  DeleteCartItemEvent({required this.cartId});
}

class IncrementQuantityEvent extends CartEvent {
  final String productId;

  IncrementQuantityEvent({required this.productId});
}

class DecrementQuantityEvent extends CartEvent {
  final String productId;

  DecrementQuantityEvent({required this.productId});
}

class ClearCartEvent extends CartEvent{

}

