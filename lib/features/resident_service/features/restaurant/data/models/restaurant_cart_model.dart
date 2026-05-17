class RestaurantCartModel {
  final int cartItemId;
  final int menuItemId;
  final String menuItemName;
  final String menuItemCategoryName;
  final String imageUrl;
  int quantity;
  double totalPrice;
  final bool isAvailable;

  RestaurantCartModel({
    required this.isAvailable,
    required this.cartItemId,
    required this.menuItemId,
    required this.menuItemName,
    required this.menuItemCategoryName,
    required this.imageUrl,
    required this.quantity,
    required this.totalPrice,
  });

  factory RestaurantCartModel.fromJson(Map<String, dynamic> json) {
    return RestaurantCartModel(
      cartItemId: json['cartItemId'],
      menuItemId: json['menuItemId'],
      menuItemName: json['menuItemName'],
      menuItemCategoryName: json['menuItemCategoryName'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      isAvailable: json['isAvailable'],
    );
  }
}
