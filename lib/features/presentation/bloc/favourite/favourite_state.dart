part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteSuccess extends FavouriteState {
  final List<FavouriteModel> favourites;
  FavouriteSuccess(this.favourites);
}

class FavouriteError extends FavouriteState {
  final String message;
  FavouriteError(this.message);
}
