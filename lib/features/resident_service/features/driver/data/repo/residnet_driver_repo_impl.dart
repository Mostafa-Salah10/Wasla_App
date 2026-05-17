import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasla/core/connection/network_info.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/core/database/api/api_end_points.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/api/errors/api_exceptions.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/driver/features/home/data/models/driver_profile_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/choose_driver_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/resident_trip_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/repo/residnet_driver_repo.dart';

class ResidnetDriverRepoImpl extends ResidnetDriverRepo {
  final ApiConsumer api;
  // LatLng fakeDriverLocation = const LatLng(30.1000, 31.2000);

  // /// ================= NEW TEST VARIABLES =================
  // List<LatLng> fakeRoutePoints = [];
  // int fakeRouteIndex = 0;

  // /// ======================================================

  ResidnetDriverRepoImpl({required this.api});

  @override
  // Future<Either<String, LatLng>> getDriverLocation({
  //   required LatLng user,
  // }) async {
  //   await Future.delayed(const Duration(milliseconds: 300));
  //   /// 🟢 أول مرة بس نجهز المسار
  //   if (fakeRoutePoints.isEmpty) {
  //     fakeRoutePoints = await MapServices.getBestRoute(
  //       start: fakeDriverLocation,
  //       end: user,
  //     );
  //     fakeRouteIndex = 0;
  //   }
  //   /// لو وصل لنهاية المسار
  //   if (fakeRouteIndex >= fakeRoutePoints.length) {
  //     fakeRouteIndex = fakeRoutePoints.length - 1;
  //   }
  //   fakeDriverLocation = fakeRoutePoints[fakeRouteIndex];
  //   fakeRouteIndex++;
  //   return Right(fakeDriverLocation);
  // }
  @override
  Future<Either<Failure, DriverProfileModel>> getDriverProfile({
    required String id,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }
      final response = await api.get(
        ApiEndPoints.getDriverProfile,
        queryParameters: {ApiKeys.id: id},
      );
      return Right(DriverProfileModel.fromJson(response[ApiKeys.data]));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<String, List<ChooseDriverModel>>> searchToRide({
    required String passengerId,
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String pickUpPlace,
    required String dropOffPlace,
    required int vehicleType,
  }) async {
    try {
      final response = await api.post(
        ApiEndPoints.searchToRide,
        body: {
          ApiKeys.passengerId: passengerId,
          ApiKeys.pickupLatitude: pickupLatitude,
          ApiKeys.pickupLongitude: pickupLongitude,
          ApiKeys.dropoffLatitude: dropoffLatitude,
          ApiKeys.dropoffLongitude: dropoffLongitude,
          ApiKeys.pickUpPlace: pickUpPlace,
          ApiKeys.dropOffPlace: dropOffPlace,
          ApiKeys.vehicleType: vehicleType,
        },
      );
      // log("Trip  : $response");

      List<ChooseDriverModel> drivers = [];
      for (var driver in response) {
        drivers.add(ChooseDriverModel.fromJson(driver));
      }

      return Right(drivers);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> cancelRide({
    required int tripId,
    required bool isResident,
  }) async {
    try {
      await api.put(
        ApiEndPoints.cancelRide + tripId.toString(),
        queryParameters: {ApiKeys.isResident: isResident},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, LatLng>> getDriverLocation({
    required String driverId,
  }) async {
    try {
      final response = await api.get(
        ApiEndPoints.getDriverLocation,
        queryParameters: {ApiKeys.driverId: driverId},
      );
      // log(
      //   "Current Driver Location : ${response[ApiKeys.data][ApiKeys.latitudeSmall]} , ${response[ApiKeys.data][ApiKeys.longitudeSmall]}",
      // );

      return Right(
        LatLng(
          response[ApiKeys.data][ApiKeys.latitudeSmall],
          response[ApiKeys.data][ApiKeys.longitudeSmall],
        ),
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<Failure, ResidentTripModel>> getTripForResident({
    required int tripId,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }

      final response = await api.get(
        ApiEndPoints.getRideDetaislForResident + tripId.toString(),
      );
      return Right(ResidentTripModel.fromJson(response[ApiKeys.data]));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<String, Null>> rateDriver({
    required String driverId,
    required int starts,
  }) async {
    try {
      final String? userId = await getUserId();
      await api.post(
        ApiEndPoints.addReview,
        body: {
          ApiKeys.serviceProviderId: driverId,
          ApiKeys.content: "perfect",
          ApiKeys.userId: userId!,
          ApiKeys.rating: starts,
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
  Future<Either<String, int>> chooseDriver({
    required String driverId,
    required String passengerId,
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String pickUpPlace,
    required String dropOffPlace,
    required int vehicleType,
  }) async {
    try {
      final response = await api.post(
        ApiEndPoints.chooseDriver,
        body: {
          ApiKeys.passengerId: passengerId,
          ApiKeys.driverId: driverId,
          ApiKeys.pickupLatitude: pickupLatitude,
          ApiKeys.pickupLongitude: pickupLongitude,
          ApiKeys.dropoffLatitude: dropoffLatitude,
          ApiKeys.dropoffLongitude: dropoffLongitude,
          ApiKeys.pickUpPlace: pickUpPlace,
          ApiKeys.dropOffPlace: dropOffPlace,
          ApiKeys.vehicleType: vehicleType,
        },
      );
      log("Trip  Id : $response");

      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, int?>> isInRide({required String passengerId}) async {
    try {
      final response = await api.get(
        ApiEndPoints.isInRide,
        queryParameters: {ApiKeys.userId: passengerId},
      );

      return Right(response[ApiKeys.data]);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
