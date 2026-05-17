class RestaurantMenuModel {
  final int id;
  final MealName name;
  final String nameValue;
  final String categoryName;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final int preparationTime;
  final bool isAvailable;
  final String restaurantId;
  final int categoryId;

  RestaurantMenuModel({
    required this.id,
    required this.name,
    required this.nameValue,
    required this.categoryName,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.preparationTime,
    required this.isAvailable,
    required this.restaurantId,
    required this.categoryId,
  });

  factory RestaurantMenuModel.fromJson(Map<String, dynamic> json) {
    return RestaurantMenuModel(
      id: json['id'],
      name: MealName.fromJson(json['name']),
      nameValue: json['nameValue'],
      categoryName: json['categoryName'],
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      preparationTime: json['preparationTime'],
      isAvailable: json['isAvailable'],
      restaurantId: json['restaurantId'],
      categoryId: json['categoryId'],
    );
  }
}

class MealName {
  final String english;
  final String arabic;

  MealName({required this.english, required this.arabic});

  factory MealName.fromJson(Map<String, dynamic> json) {
    return MealName(english: json['english'], arabic: json['arabic']);
  }
}
