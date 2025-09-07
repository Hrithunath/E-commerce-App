import 'package:e_commerce_app/features/domain/model/favourite_model.dart';

abstract class FavouriteEvent {}

class LoadFavouritesEvent extends FavouriteEvent {}

class AddFavouriteEvent extends FavouriteEvent {
  final FavouriteModel favourite;

  AddFavouriteEvent(this.favourite);
}

class RemoveFavouriteEvent extends FavouriteEvent {
  final String favouriteId;

  RemoveFavouriteEvent(this.favouriteId);
}
