import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasla/core/enums/driver_enums.dart';
import 'package:wasla/core/enums/driver_status.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/service/maps/map_services.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/features/driver/features/trip/data/models/driver_trip_and_resident_info_model.dart';
import 'package:wasla/features/driver/features/trip/data/repo/driver_trip_repo.dart';

part 'driver_trip_state.dart';

class DriverTripCubit extends Cubit<DriverTripState> {
  DriverTripCubit(this.driverTripRepo) : super(DriverTripInitial());

  final DriverTripRepo driverTripRepo;
  final mapController = MapController();

  LatLng passengerLocation = const LatLng(30.0770, 31.3400);

  LatLng? driverLocation;
  LatLng? previousDriverLocation;

  List<LatLng> routePoints = [];

  double driverRotation = 0.0;

  Timer? liveTrackingTimer;

  bool isDriverArrived = false;
  bool isStartedTrip = false;

  VehicleType vehicleType = VehicleType.car;

  int tripId = -1;
  int tripIdStored = -1;
  TripModel? tripDetails;

  final Distance distance = const Distance();

  void onRetry() {
    emit(DriverTripOnRetryState());
  }

  Future<void> fetchDriverLocation() async {
    final result = await MapServices.getCurrentLocation();

    result.fold(
      (error) {
        log("Location error: $error");
      },
      (location) {
        driverLocation = LatLng(location.latitude!, location.longitude!);
      },
    );
  }

  Future<void> initializeTrip() async {
    passengerLocation = LatLng(
      tripDetails!.pickUpLatitude,
      tripDetails!.pickUpLongitude,
    );
    // await fetchDriverLocation();

    if (driverLocation == null) {
      log('Driver Locaion Null Ya Disha');
    }

    if (driverLocation != null) {
      routePoints = await MapServices.getBestRoute(
        start: driverLocation!,
        end: passengerLocation,
      );

      updateDriverRotation();
    }

    emit(DriverChangeMyLocation());
  }

  Future<void> recalculateRoute() async {
    if (driverLocation != null) {
      routePoints = await MapServices.getBestRoute(
        start: driverLocation!,
        end: passengerLocation,
      );
    }
  }

  bool isDriverOffRoute() {
    if (routePoints.isEmpty || driverLocation == null) return false;

    double minDistance = double.infinity;

    for (final point in routePoints) {
      final d = distance.as(LengthUnit.Meter, driverLocation!, point);
      if (d < minDistance) {
        minDistance = d;
      }
    }

    return minDistance > 50;
  }

  void updateDriverRotation() {
    if (previousDriverLocation == null || driverLocation == null) return;

    driverRotation = MapServices.calculateBearing(
      previousDriverLocation!,
      driverLocation!,
    );
  }

  void checkArrival() {
    if (driverLocation == null) return;

    final d = distance.as(LengthUnit.Meter, driverLocation!, passengerLocation);

    if (d < 15) {
      isDriverArrived = true;
      stopLiveTracking();
      emit(DriverWhenArrived());
    }
  }

  void startLiveTracking() {
    liveTrackingTimer?.cancel();

    liveTrackingTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      if (isDriverArrived) {
        timer.cancel();
        return;
      }

      await fetchDriverLocation();

      if (driverLocation != null) {
        if (isDriverOffRoute()) {
          await recalculateRoute();
        }
      }

      updateDriverRotation();
      checkArrival();

      // if (driverLocation != null) {
      //   mapController.move(driverLocation!, 15);
      // }

      emit(DriverChangeMyLocation());
    });
  }

  void stopLiveTracking() {
    liveTrackingTimer?.cancel();
  }

  void backToOriginalLocation() {
    if (driverLocation == null) return;

    mapController.move(driverLocation!, 15);

    emit(DriverBackToMyLocation());
  }

  ////End Methods of tracking
  Timer? driverLocationTimer;
  Future<void> cancelRide() async {
    emit(DriverCancelRideLoading());
    final result = await driverTripRepo.cancelRide(
      tripId: tripId,
      isResident: false,
    );
    result.fold((error) => emit(DriverCancelRideFailure(errorMessage: error)), (
      success,
    ) {
      tripId = -1;
      tripIdStored = -1;
      emit(DriverCancelRideSuccess());
    });
  }

  Future<void> startRide() async {
    emit(DriverStartRideLoading());
    final result = await driverTripRepo.startRide(id: tripId);
    result.fold((error) => emit(DriverStartRideFailure(errorMessage: error)), (
      success,
    ) {
      isStartedTrip = true;
      tripId = -1;
      emit(DriverStrartRideSuccess());
    });
  }

  Future<void> compelteRide() async {
    emit(DriverCompleteRideLoading());
    final result = await driverTripRepo.completeRide(id: tripIdStored);
    result.fold(
      (error) => emit(DriverCompleteRideFailure(errorMessage: error)),
      (success) {
        isStartedTrip = false;
        tripIdStored = -1;
        tripId = -1;
        emit(DriverCompleteRideSuccess());
      },
    );
  }

  Future<bool> isInRide() async {
    final String? userId = await getUserId();

    final result = await driverTripRepo.isInRide(driverId: userId!);

    return result.fold(
      (error) {
        return false;
      },
      (success) {
        if (success != null) {
          tripId = success;
          return true;
        }
        return false;
      },
    );
  }

  Future<void> acceptRide() async {
    final String? driverId = await getUserId();
    emit(DriverAcceptRideLoading());
    final result = await driverTripRepo.acceptRide(
      id: tripId,
      driverId: driverId!,
    );
    result.fold(
      (error) => emit(DriverAcceptRideFailure(errorMessage: error)),
      (success) => emit(DriverAcceptRideSuccess()),
    );
  }

  Future<void> updateDriverLocation() async {
    await fetchDriverLocation();

    final String? driverId = await getUserId();
    if (driverId == null) return;
    final result = await driverTripRepo.updateDriverLocation(
      vehicleType: vehicleType.index,
      driverId: driverId,
      location: driverLocation!,
    );
    result.fold((error) {}, (success) {});
  }

  void sendDriverLocatonToBackEnd() {
    driverLocationTimer?.cancel();

    if (tripId == -1) {
      driverLocationTimer = Timer.periodic(const Duration(seconds: 10), (
        timer,
      ) {
        if (tripId == -1) {
          updateDriverLocation();
        } else {
          timer.cancel();
          sendDriverLocatonToBackEnd();
        }
      });
    } else {
      driverLocationTimer = Timer.periodic(const Duration(milliseconds: 1500), (
        timer,
      ) {
        if (tripId != -1) {
          updateDriverLocation();
        } else {
          timer.cancel();
          sendDriverLocatonToBackEnd();
        }
      });
    }
  }

  void stopDriverLocationTimer({required String driverId}) async {
    driverLocationTimer?.cancel();
    driverLocationTimer = null;

    await driverTripRepo.updateDriverStatus(
      driverId: driverId,
      status: DriverStatus.offline,
    );
  }

  Future<void> updateDriverStatus({required DriverStatus driverStatus}) async {
    final String? driverId = await getUserId();
    final result = await driverTripRepo.updateDriverStatus(
      driverId: driverId!,
      status: driverStatus,
    );
    result.fold(
      (error) => toastAlert(color: AppColors.red, msg: 'Restart the app'),
      (success) {},
    );
  }

  Future<void> getRideDetails() async {
    emit(DriverGetRideDeatialsLoading());
    final result = await driverTripRepo.getTripDetails(tripId: tripId);
    result.fold(
      (error) {
        if (error is NoInternetFailure) {
          emit(DriverTripNetworkState());
        } else {
          emit(DriverTripFailureState());
        }
      },
      (success) {
        tripDetails = success;
        emit(DriverGetRideDeatialsSuccess());
      },
    );
  }
}
