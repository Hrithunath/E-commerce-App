part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteEvent {}

class AddFavouriteEvent extends FavouriteEvent {
  final FavouriteModel favourite;
  AddFavouriteEvent(this.favourite);
}

class RemoveFavouriteEvent extends FavouriteEvent {
  final String favouriteId;
  RemoveFavouriteEvent(this.favouriteId);
}

class LoadFavouritesEvent extends FavouriteEvent {}
