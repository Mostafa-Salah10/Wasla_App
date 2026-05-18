import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasla/core/enums/driver_status.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/features/driver/features/trip/data/models/driver_trip_and_resident_info_model.dart';

abstract class DriverTripRepo {
  Future<Either<String, Null>> cancelRide({
    required int tripId,
    required bool isResident,
  });
  Future<Either<String, Null>> startRide({required int id});
  Future<Either<String, Null>> completeRide({required int id});
  Future<Either<String, Null>> acceptRide({
    required int id,
    required String driverId,
  });
  Future<Either<String, Null>> updateDriverLocation({
    required LatLng location,
    required String driverId,
    required int vehicleType,
  });
  Future<Either<String, Null>> updateDriverStatus({
    required DriverStatus status,
    required String driverId,
  });
  Future<Either<Failure, TripModel>> getTripDetails({required int tripId});
  Future<Either<String, int?>> isInRide({required String driverId});
}
