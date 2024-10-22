import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/domain/model/favourite_model.dart';
import 'package:e_commerce_app/domain/repository/favourite.dart';
import 'package:meta/meta.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final FavouriteRepository favouriteRepository;

 
  FavouriteBloc(this.favouriteRepository) : super(FavouriteInitial(const [])) {
    // Event handlers
    on<LoadFavouritesEvent>(loadFavourites);
    on<AddFavouriteEvent>(addFavourite);
    on<RemoveFavouriteEvent>(removeFavourite);
  }

  Future<void> loadFavourites(LoadFavouritesEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      final favourites = await favouriteRepository.getFavourite();
      emit(FavouriteLoaded(favourites));
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }

  Future<void> addFavourite(AddFavouriteEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      await favouriteRepository.addFavourite(event.favourite);
      emit(FavouriteAddedSuccess(event.favourite));
      
      add(LoadFavouritesEvent());
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }

  Future<void> removeFavourite(RemoveFavouriteEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoading());
    try {
      await favouriteRepository.removeFavourite(event.favouriteId);
      emit(FavouriteRemovedSuccess(event.favouriteId));
     
      add(LoadFavouritesEvent());
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }
}
