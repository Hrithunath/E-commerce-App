

import 'package:e_commerce_app/domain/model/favourite_model.dart';

abstract class FavouriteRepository {
  
  Future<void>addFavourite(FavouriteModel favorite);
   Future<void>removeFavourite(String docId);
    Future<List<FavouriteModel>>getFavourite();
}