import 'package:e_commerce_app/features/domain/model/favourite_model.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_bloc.dart';

abstract class FavouriteRepository {
  Future<void> addFavouriteService(FavouriteModel favorite);
  Future<void> removeFavouriteService(String docId);
  Future<List<FavouriteModel>> getFavouriteService();
}
