
import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasla/core/connection/network_info.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/core/database/api/api_end_points.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/api/errors/api_exceptions.dart';
import 'package:wasla/core/enums/driver_status.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/driver/features/trip/data/models/driver_trip_and_resident_info_model.dart';
import 'package:wasla/features/driver/features/trip/data/repo/driver_trip_repo.dart';

class DriverTripRepoImpl extends DriverTripRepo {
  final ApiConsumer api;

  DriverTripRepoImpl({required this.api});
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
  Future<Either<String, Null>> completeRide({required int id}) async {
    try {
      await api.put(ApiEndPoints.completeTrip + id.toString());
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> startRide({required int id}) async {
    try {
      await api.put(ApiEndPoints.startTrip + id.toString());
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> acceptRide({
    required int id,
    required String driverId,
  }) async {
    try {
      await api.post(
        ApiEndPoints.acceptTrip + id.toString(),
        queryParameters: {ApiKeys.driverId: driverId},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> updateDriverLocation({
    required LatLng location,
    required String driverId,
    required int vehicleType,
  }) async {
    try {
      await api.post(
        ApiEndPoints.updateDriverLocation,
        body: {
          ApiKeys.driverId: driverId,
          ApiKeys.latitudeSmall: location.latitude,
          ApiKeys.longitudeSmall: location.longitude,
          "vehicleType": vehicleType,
        },
      );

      // log("Success");

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> updateDriverStatus({
    required DriverStatus status,
    required String driverId,
  }) async {
    try {
      await api.put(
        ApiEndPoints.updateDriverStatus,
        queryParameters: {
          ApiKeys.driverId: driverId,
          ApiKeys.newStatus: status.index,
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
  Future<Either<Failure, TripModel>> getTripDetails({
    required int tripId,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }
      final response = await api.get(
        ApiEndPoints.getTripDetailsForDriver + tripId.toString(),
      );

      return Right(TripModel.fromJson(response[ApiKeys.data]));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<String, int?>> isInRide({required String driverId}) async {
    try {
      final response = await api.get(
        ApiEndPoints.isInRide,
        queryParameters: {ApiKeys.userId: driverId},
      );

      return Right(response[ApiKeys.data]);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
