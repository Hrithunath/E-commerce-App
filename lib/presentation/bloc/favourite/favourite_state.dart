part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {
  final List<FavouriteModel> favourites;

  FavouriteInitial(this.favourites);

  
}

class FavouriteLoading extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  final List<FavouriteModel> favourites;

  FavouriteLoaded(this.favourites);
}

class FavouriteAddedSuccess extends FavouriteState {
  final FavouriteModel favourite;

  FavouriteAddedSuccess(this.favourite);
}

class FavouriteRemovedSuccess extends FavouriteState {
  final String favouriteId;

  FavouriteRemovedSuccess(this.favouriteId);
}

class FavouriteError extends FavouriteState {
  final String message;

  FavouriteError({required this.message});
}