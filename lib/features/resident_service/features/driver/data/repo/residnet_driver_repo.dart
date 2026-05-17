import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/features/driver/features/home/data/models/driver_profile_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/choose_driver_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/resident_trip_model.dart';

abstract class ResidnetDriverRepo {
  // Future<Either<String, LatLng>> getDriverLocation({required LatLng user});
  Future<Either<String, LatLng>> getDriverLocation({required String driverId});
  Future<Either<String, List<ChooseDriverModel>>> searchToRide({
    required String passengerId,
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String pickUpPlace,
    required String dropOffPlace,
    required int vehicleType,
  });

  Future<Either<String, Null>> cancelRide({
    required int tripId,
    required bool isResident,
  });
  Future<Either<Failure, ResidentTripModel>> getTripForResident({
    required int tripId,
  });
  Future<Either<String, Null>> rateDriver({
    required String driverId,
    required int starts,
  });

  Future<Either<Failure, DriverProfileModel>> getDriverProfile({
    required String id,
  });
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
  });
  Future<Either<String, int?>> isInRide({required String passengerId});
}
