import 'package:e_commerce_app/features/domain/model/favourite_model.dart';

abstract class FavouriteRepository {
  Future<void> addFavouriteService(FavouriteModel favorite);
  Future<void> removeFavouriteService(String docId);
  Future<List<FavouriteModel>> getFavouriteService();
}
