import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/features/domain/model/favourite_model.dart';
import 'package:e_commerce_app/features/domain/repository/favourite_repository.dart';
import 'package:meta/meta.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final FavouriteRepository favouriteRepository;

  FavouriteBloc(this.favouriteRepository) : super(FavouriteInitial(const [])) {
    // Event handlers
    on<LoadFavouritesEvent>(loadFavourites);
    on<AddFavouriteEvent>(addFavourites);
    on<RemoveFavouriteEvent>(removeFavourites);
  }

  Future<void> loadFavourites(
      LoadFavouritesEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      final favourites = await favouriteRepository.getFavouriteService();
      emit(FavouriteLoaded(favourites));
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }

  Future<void> addFavourites(
      AddFavouriteEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      await favouriteRepository.addFavouriteService(event.favourite);
      emit(FavouriteAddedSuccess(event.favourite));

      add(LoadFavouritesEvent());
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }

  Future<void> removeFavourites(
      RemoveFavouriteEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      final favouriteId = event.favouriteId;
      print("Removing favourite with ID: $favouriteId");
      await favouriteRepository.removeFavouriteService(event.favouriteId);

      emit(FavouriteRemovedSuccess(event.favouriteId));

      add(LoadFavouritesEvent());
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }
}
