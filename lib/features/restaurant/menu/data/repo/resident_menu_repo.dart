import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restauarant_menu_item_model.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restaurant_menu_category_model.dart';
import 'package:wasla/features/restaurant/menu/data/models/restaurant_menu_model.dart';

abstract class ResidentMenuRepo {
  Future<Either<Failure, List<RestaurantMenuCategoryModel>>> getMenuCategories({
    required String restaurantId,
  });
  Future<Either<Failure, List<RestauarantMenuItemModel>>> getMenuItems({
    required String restaurantId,
  });
  Future<Either<Failure, List<RestaurantMenuModel>>> getRestaurantMenu({
    required String restaurantId,
    required int pageNumber,
    required int pageSize,
  });
  Future<Either<String, Null>> addMenu({
    required String restaurantId,
    required String nameAr,
    required String nameEn,
    required double price,
    required double discount,
    required int preparationTime,
    required int categoryId,
    required File image,
  });
  Future<Either<String, Null>> updateMenu({
    required int id,
    required String nameAr,
    required String nameEn,
    required double price,
    required double discount,
    required int preparationTime,
    required int categoryId,
    required bool isAvailable,
    File? image,
  });

  Future<Either<String, Null>> deleteMenu({required int id});
  Future<Either<String, Null>> addMenuToCart({
    required String restaurantId,
    required String residentId,
    required int menuId,
  });
}
