import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wasla/core/connection/network_info.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/core/database/api/api_end_points.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/api/errors/api_exceptions.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/convert_image_to_json.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restauarant_menu_item_model.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restaurant_menu_category_model.dart';
import 'package:wasla/features/restaurant/menu/data/models/restaurant_menu_model.dart';
import 'package:wasla/features/restaurant/menu/data/repo/resident_menu_repo.dart';

class ResidentMenuRepoImpl extends ResidentMenuRepo {
  final ApiConsumer api;

  ResidentMenuRepoImpl({required this.api});

  @override
  Future<Either<Failure, List<RestaurantMenuCategoryModel>>> getMenuCategories({
    required String restaurantId,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }

      final response = await api.get(
        ApiEndPoints.getMenuCategory,
        queryParameters: {ApiKeys.id: restaurantId},
      );

      List<RestaurantMenuCategoryModel> categories = [];
      for (var category in response[ApiKeys.data] ?? []) {
        categories.add(RestaurantMenuCategoryModel.fromJson(category));
      }
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestauarantMenuItemModel>>> getMenuItems({
    required String restaurantId,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }

      final response = await api.get(
        ApiEndPoints.getMenuCategoryItemByCategories,
        queryParameters: {ApiKeys.id: restaurantId},
      );

      List<RestauarantMenuItemModel> items = [];
      for (var item in response[ApiKeys.data] ?? []) {
        items.add(RestauarantMenuItemModel.fromJson(item));
      }
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<String, Null>> addMenu({
    required String restaurantId,
    required String nameAr,
    required String nameEn,
    required double price,
    required double discount,
    required int preparationTime,
    required int categoryId,
    required File image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'imageUrl': await convertImageToMultipart(image),
      });
      await api.post(
        ApiEndPoints.retaurantMenu,
        queryParameters: {
          'name.English': nameEn,
          'name.Arabic': nameAr,
          'price': price,
          'discountPrice': discount,
          'preparationTime': preparationTime,
          'restaurantId': restaurantId,
          'categoryId': categoryId,
        },
        body: formData,
        headers: {'Content-Type': 'multipart/form-data'},
      );

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> updateMenu({
    required int id,
    required String nameAr,
    required String nameEn,
    required double price,
    required double discount,
    required int preparationTime,
    required int categoryId,
    File? image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'imageUrl': await convertImageToMultipart(image),
      });
      await api.put(
        ApiEndPoints.retaurantMenu,
        queryParameters: {
          'name.English': nameEn,
          'name.Arabic': nameAr,
          'price': price,
          'discountPrice': discount,
          'preparationTime': preparationTime,
          'id': id,
          'categoryId': categoryId,
        },
        body: formData,
        headers: {'Content-Type': 'multipart/form-data'},
      );

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> deleteMenu({required int id}) async {
    try {
      await api.delete(ApiEndPoints.retaurantMenu, queryParameters: {'id': id});

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> addMenuToCart({
    required String restaurantId,
    required String residentId,
    required int menuId,
  }) async {
    try {
      await api.post(
        ApiEndPoints.addMenuToCart,
        body: {
          "menuItemId": menuId,
          "residentId": residentId,
          "restaurantId": restaurantId,
          "quantity": 1,
        },
      );

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<Failure, List<RestaurantMenuModel>>> getRestaurantMenu({
    required String restaurantId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }

      final response = await api.get(
        ApiEndPoints.getRestaurantMenu,
        queryParameters: {
          ApiKeys.id: restaurantId,
          ApiKeys.pageNumberCap: pageNumber,
          ApiKeys.pageSizeCap: pageSize,
        },
      );

      List<RestaurantMenuModel> items = [];
      for (var category in response[ApiKeys.data][ApiKeys.data] ?? []) {
        items.add(RestaurantMenuModel.fromJson(category));
      }
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
