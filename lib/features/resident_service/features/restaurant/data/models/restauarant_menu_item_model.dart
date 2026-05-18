class RestauarantMenuItemModel {
  final int categoryId;
  final String categoryName;
  final List<MenuItem> items;

  RestauarantMenuItemModel({
    required this.categoryId,
    required this.categoryName,
    required this.items,
  });

  factory RestauarantMenuItemModel.fromJson(Map<String, dynamic> json) {
    return RestauarantMenuItemModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      items: List<MenuItem>.from(
        json['items'].map((e) => MenuItem.fromJson(e)),
      ),
    );
  }
}

class MenuItem {
  final int id;
  final String name;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final int preparationTime;
   bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.preparationTime,
    required this.isAvailable,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: (json['price']).toDouble(),
      discountPrice: (json['discountPrice']).toDouble(),
      imageUrl: json['imageUrl'],
      preparationTime: json['preparationTime'],
      isAvailable: json['isAvailable'],
    );
  }
}
