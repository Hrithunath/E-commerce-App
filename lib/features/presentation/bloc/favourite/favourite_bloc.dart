import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/features/domain/model/favourite_model.dart';
import 'package:e_commerce_app/features/domain/repository/favourite_repository.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_event.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final FavouriteRepository favouriteRepository;
  List<FavouriteModel> favouriteItems = [];

  FavouriteBloc(this.favouriteRepository) : super(FavouriteInitial()) {
    on<LoadFavouritesEvent>((event, emit) async {
      emit(FavouriteLoading());
      try {
        favouriteItems = await favouriteRepository.getFavouriteService();
        emit(FavouriteSuccess(favouriteItems));
      } catch (e) {
        emit(FavouriteError('Failed to load favourites: $e'));
      }
    });

    on<AddFavouriteEvent>((event, emit) async {
      emit(FavouriteLoading());
      try {
        await favouriteRepository.addFavouriteService(event.favourite);
        favouriteItems.add(event.favourite);
        emit(FavouriteSuccess(List.from(favouriteItems)));
      } catch (e) {
        emit(FavouriteError('Failed to add favourite: $e'));
      }
    });

    on<RemoveFavouriteEvent>((event, emit) async {
      emit(FavouriteLoading());
      try {
        await favouriteRepository.removeFavouriteService(event.favouriteId);
        favouriteItems
            .removeWhere((item) => item.favouriteid == event.favouriteId);
        emit(FavouriteSuccess(List.from(favouriteItems)));
      } catch (e) {
        emit(FavouriteError('Failed to remove favourite: $e'));
      }
    });
  }
}
