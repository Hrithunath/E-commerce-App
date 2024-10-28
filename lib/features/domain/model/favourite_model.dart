class FavouriteModel {
  final String productId;
  final String favouriteid;
  final String? imageUrl; 
  final String? name;      
  final double price;

  FavouriteModel({
    required this.productId,
    required this.favouriteid,
     this.imageUrl, 
     this.name,     
    required this.price,
  });    
}
