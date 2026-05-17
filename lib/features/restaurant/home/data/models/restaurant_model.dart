import 'package:wasla/core/models/user_base_model.dart';

class RestaurantModel extends UserBaseModel {
  final String id;
  final String email;
  final String name;
  final String description;
  final String phoneNumber;
  final String ownerName;
  final int restaurantCategoryId;
  final String restaurantCategoryName;
  final String profile;
  final List<String> gallery;
  final int numberOfCompletedOrders;
  final bool isAvailable;

  RestaurantModel({
    required this.numberOfCompletedOrders,
    required this.isAvailable,
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.ownerName,
    required this.restaurantCategoryId,
    required this.restaurantCategoryName,
    required this.profile,
    required this.gallery,
  }) : super(
         fullNameBase: ownerName,
         emailBase: email,
         phoneNumberBase: phoneNumber,
         imageUrlBase: profile,
         latBase: 0.0,
         lngBase: 0.0,
       );

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      isAvailable: json['isAvailable'] ?? false,
      numberOfCompletedOrders: json['numberOfCompletedOrders'] ?? 0,
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      ownerName: json['ownerName'] ?? '',
      restaurantCategoryId: json['restaurantCategoryId'] ?? 0,
      restaurantCategoryName: json['restaurantCategoryName'] ?? '',
      profile: json['profile'] ?? '',
      gallery: List<String>.from(json['gallery'] ?? []),
    );
  }
}
