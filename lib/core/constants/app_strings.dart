class AppStrings {
  // General Errors
  static const String genericError =
      "Oops! Something went wrong. Please try again.";
  static const String authenticationError = "Authentication failed: ";

  // Auth
  static const String userAuthenticated = "Welcome back! You’re signed in.";
  static const String userNotAuthenticated = "Please log in to continue.";
  static const String accountCreated =
      "Welcome aboard! Your account has been created.";

  // Product
  static const String selectSize = "Please pick a size first.";
  static const String productNotFound = "We couldn't find that product.";
  static const String productInCart = "This item is already in your cart.";
  static const String addedToCartSuffix = " has been added to your cart.";
  static const String errorPrefix = "Error: ";

  // Address
  static const String addressAdded = "New address saved!";
  static const String addressEdited = "Address updated successfully.";
  static const String addressAddFailed = "Couldn't save address: ";
  static const String addressEditFailed = "Couldn't update address: ";
  static const String selectDeliveryAddress =
      "Please choose a delivery address.";
}
