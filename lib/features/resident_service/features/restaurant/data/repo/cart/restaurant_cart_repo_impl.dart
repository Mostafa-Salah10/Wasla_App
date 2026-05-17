import 'package:dartz/dartz.dart';
import 'package:wasla/core/connection/network_info.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/core/database/api/api_end_points.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/api/errors/api_exceptions.dart';
import 'package:wasla/core/enums/payment_method.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/models/payment_model.dart';
import 'package:wasla/core/models/payment_result_mode.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restaurant_cart_model.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/repo/cart/restaurant_cart_repo.dart';

class RestaurantCartRepoImpl extends RestaurantCartRepo {
  final ApiConsumer api;

  RestaurantCartRepoImpl({required this.api});

  @override
  Future<Either<Failure, List<RestaurantCartModel>>> getCartItems({
    required String residentId,
    required String restaurantId,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }

      final response = await api.get(
        ApiEndPoints.getResidentCartWithRestaurant,
        queryParameters: {
          ApiKeys.residentId: residentId,
          ApiKeys.restaurantId: restaurantId,
        },
      );

      List<RestaurantCartModel> items = [];
      for (var item in response[ApiKeys.data]) {
        if (!item['isDeleted']) {
          items.add(RestaurantCartModel.fromJson(item));
        }
      }
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<String, Null>> removeFromCart({
    required String residentId,
    required int cartItemId,
  }) async {
    try {
      await api.delete(
        ApiEndPoints.removeItemFromCartWithRestaurant,
        queryParameters: {
          ApiKeys.cartItemId: cartItemId,
          ApiKeys.residentId: residentId,
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
  Future<Either<String, Null>> updateQuantity({
    required String residentId,
    required int quantity,
    required int cartItemId,
  }) async {
    try {
      await api.put(
        ApiEndPoints.updateQuantityCartWithRestaurant,
        queryParameters: {
          ApiKeys.quantity: quantity,
          ApiKeys.cartItemId: cartItemId,
          ApiKeys.residentId: residentId,
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
  Future<Either<String, PaymentResultModel>> restaurantCheckout({
    required String restaurantId,
    required String residentId,
    required String address,
    required String notes,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      final response = await api.post(
        'api/RestaurantOrder/checkout',
        body: {
          ApiKeys.residentId: residentId,
          ApiKeys.restaurantId: restaurantId,
          ApiKeys.address: address,
          ApiKeys.notes: notes,
          ApiKeys.paymentMethod: paymentMethod.index + 1,
        },
      );

      if (paymentMethod == PaymentMethod.creditCard) {
        return Right(PaymentModel.fromJson(json: response[ApiKeys.data]));
      } else {
        return Right(PaymentCashModel());
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
