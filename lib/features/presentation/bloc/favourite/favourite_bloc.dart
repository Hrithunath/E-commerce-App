import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/features/domain/model/favourite_model.dart';
import 'package:e_commerce_app/features/domain/repository/favourite_repository.dart';
import 'package:meta/meta.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final FavouriteRepository favouriteRepository;

  FavouriteBloc(this.favouriteRepository) : super(FavouriteInitial()) {
    on<LoadFavouritesEvent>((event, emit) async {
      emit(FavouriteLoading());
      try {
        final favourites = await favouriteRepository.getFavouriteService();
        emit(FavouriteSuccess(favourites));
      } catch (e) {
        emit(FavouriteError(e.toString()));
      }
    });

    List<FavouriteModel> favouritesItems = [];
    on<AddFavouriteEvent>((event, emit) async {
      try {
        await favouriteRepository.addFavouriteService(event.favourite);
        emit(FavouriteSuccess(favouritesItems));
      } catch (e) {
        emit(FavouriteError(e.toString()));
      }
    });

    on<RemoveFavouriteEvent>((event, emit) async {
      try {
        await favouriteRepository.removeFavouriteService(event.favouriteId);
        // add(LoadFavouritesEvent());
      } catch (e) {
        emit(FavouriteError(e.toString()));
      }
    });
  }
}
