import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:wasla/core/enums/driver_enums.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/service/maps/map_services.dart';
import 'package:wasla/core/service/maps/models/places_model.dart';
import 'package:wasla/features/driver/features/home/data/models/driver_profile_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/choose_driver_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/resident_trip_model.dart';
import 'package:wasla/features/resident_service/features/driver/data/repo/residnet_driver_repo.dart';

part 'resident_driver_state.dart';

class ResidentDriverCubit extends Cubit<ResidentDriverState> {
  ResidentDriverCubit(this.residnetDriverRepo) : super(ResidentDriverInitial());

  final ResidnetDriverRepo residnetDriverRepo;

  bool isActiveButton = false;
  bool isFromField = true;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  List<PlaceModel> searchedPlaces = [];
  PlaceModel? fromPlace, toPlace;
  LocationData? myLocation;
  double lat = 30.0444;
  double lng = 31.2357;
  LatLng driverLocation = LatLng(30.109760, 31.247240);
  List<LatLng> routePoints = [];

  List<ChooseDriverModel> selectedDrivers = [];
  int routeIndex = 0;
  Timer? driverTimer;
  double driverRotation = 0.0;
  int selecedRouteIndex = -1;
  final mapController = MapController();
  int tripId = -1;

  int isInRideId = -1;
  bool isPopFromButton = false;

  Timer? cancelTripTimer;

  VehicleType vehicleType = VehicleType.car;
  ResidentTripModel? tripModel;

  void onRetry() {
    emit(ResidentDriverOnRetryState());
  }

  void startLoadingTimer() {
    cancelTripTimer?.cancel();
    cancelTripTimer = Timer(const Duration(minutes: 2), () {
      cancelRide();
      cancelTripTimer = null;
    });
  }

  void changeVehicleType({required VehicleType type}) {
    vehicleType = type;
    emit(ResidentDriverChangeVehicleType());
  }

  void updateSelectedStartIndex(int index) {
    if (selecedRouteIndex != index) {
      selecedRouteIndex = index;
    }
    emit(ResidentDriverUpdateSelectedStarIndex());
  }

  void updateButtonState() {
    isActiveButton = fromPlace != null && toPlace != null;
    emit(ResidentDriverUpdateButtonState());
  }

  void searchToPlace(String place) async {
    if (isFromField && fromPlace != null) {
      fromPlace = null;
      updateButtonState();
    }
    if (!isFromField && toPlace != null) {
      toPlace = null;
      updateButtonState();
    }

    searchedPlaces.clear();
    searchedPlaces = await MapServices.searchPlaces(place);
    emit(ResidentDriverSearchToPlaceState());
  }

  void resetSearchedList({required PlaceModel place}) {
    if (isFromField) {
      fromPlace = place;
    } else {
      toPlace = place;
    }
    searchedPlaces.clear();
    updateButtonState();
    emit(ResidentDriverSearchToPlaceState());
  }

  void getMyLocation() async {
    emit(ResidentDriverGetMyLocationLoadingState());

    final result = await MapServices.getCurrentLocation();
    result.fold((error) {}, (success) {
      myLocation = success;
      lat = myLocation!.latitude!;
      lng = myLocation!.longitude!;
      emit(ResidentDriverGetMyLocationSuccessState());
    });
  }

  void chooseMyLocation() async {
    if (myLocation != null) {
      final result = await MapServices.getCityFromLatLng(
        myLocation!.latitude!,
        myLocation!.longitude!,
      );
      result.fold((error) {}, (success) {
        fromPlace = PlaceModel(
          name: success,
          country: 'Egypt',
          lat: myLocation!.latitude!,
          lng: myLocation!.longitude!,
        );
        updateButtonState();
        searchedPlaces.clear();
        emit(ResidentDriverSearchToPlaceState());
      });
    }
  }

  Future<void> getBestRoute() async {
    routePoints = await MapServices.getBestRoute(
      start: driverLocation,
      end: LatLng(fromPlace!.lat, fromPlace!.lng),
    );
  }

  void startDriverSimulation() {
    if (routePoints.isEmpty) return;

    driverTimer?.cancel();

    driverTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (routeIndex >= routePoints.length) {
        isDriverArrived = true;
        timer.cancel();
        emit(ResidentDriverArrivedState());
        return;
      }
      final lookAhead = (routeIndex + 5).clamp(0, routePoints.length - 1);
      final lookBehind = (routeIndex - 1).clamp(0, routePoints.length - 1);
      driverRotation = MapServices.calculateBearing(
        routePoints[lookBehind],
        routePoints[lookAhead],
      );

      driverLocation = routePoints[routeIndex];
      routeIndex++;

      ///suppose the driver it's location is the same location of current point

      if (routeIndex > 1) {
        routePoints.removeRange(0, routeIndex - 1);
        routeIndex = 1;
      }

      // goToCenter();

      emit(ResidentDriverChangeDriverLocation());
    });
  }

  void reset() {
    isActiveButton = false;
    isFromField = true;
    fromController.clear();
    toController.clear();
    searchedPlaces.clear();
    fromPlace = null;
    toPlace = null;
    vehicleType = VehicleType.car;
  }

  void goToCenter() {
    mapController.move(driverLocation, 11);
  }

  void backToOriginalLocation() {
    mapController.move(LatLng(lat, lng), 11);
    emit(ResidentDriverBackToMyLocatonLocation());
  }

  void resetTrackingData() {
    driverLocation = LatLng(30.1000, 31.2000);
    routePoints = [];
    routeIndex = 0;
    driverTimer?.cancel();
    driverRotation = 0.0;
  }

  Future<void> cancelRide() async {
    emit(ResidentDriverCancelRideLoading());

    cancelTripTimer?.cancel();
    cancelTripTimer = null;

    final result = await residnetDriverRepo.cancelRide(
      tripId: tripId,
      isResident: true,
    );
    result.fold(
      (error) {
        emit(ResidentDriverCancelRideFailure(errorMessage: error));
      },
      (success) {
        emit(ResidentDriverCancelRideSuccess());
      },
    );
  }

  Future<void> requestRide() async {
    final String? userId = await getUserId();
    emit(ResidentDriverRequestRideLoading());
    final result = await residnetDriverRepo.searchToRide(
      vehicleType: vehicleType.index,
      passengerId: userId!,
      pickupLatitude: fromPlace!.lat,
      pickupLongitude: fromPlace!.lng,
      dropoffLatitude: toPlace!.lat,
      dropoffLongitude: toPlace!.lng,
      pickUpPlace: fromPlace!.name,
      dropOffPlace: toPlace!.name,
    );
    result.fold(
      (error) {
        emit(ResidentDriverRequestRideFailure(errorMessage: error));
      },
      (success) {
        // tripId = success;
        selectedDrivers = success;
        emit(ResidentDriverRequestRideSuccess());
      },
    );
  }

  Future<void> getTripForResident() async {
    emit(ResidentDriverGetRideDetailsLoading());
    final result = await residnetDriverRepo.getTripForResident(tripId: tripId);
    result.fold(
      (error) {
        if (error is NoInternetFailure) {
          emit(ResidentDriverNetworkState());
        } else {
          emit(ResidentDriverFailureState());
        }
      },
      (success) {
        tripModel = success;
        emit(ResidentDriverGetRideDetailsSuccess());
      },
    );
  }

  Future<void> getDriverProfile({required String driverId}) async {
    emit(ResidentDriverProfileLoading());
    final result = await residnetDriverRepo.getDriverProfile(id: driverId);
    result.fold(
      (error) {
        if (error is NoInternetFailure) {
          emit(ResidentDriverNetworkState());
        } else {
          emit(ResidentDriverFailureState());
        }
      },
      (success) {
        emit(ResidentDriverProfileSuccess(driver: success));
      },
    );
  }

  Future<void> addRating({required String driverId}) async {
    if (selecedRouteIndex == -1) {
      emit(ResidentAddRatingFailure(errorMessage: 'Please select rating'));
      return;
    }
    emit(ResidentAddRatingLoading());
    final result = await residnetDriverRepo.rateDriver(
      driverId: driverId,
      starts: selecedRouteIndex + 1,
    );
    result.fold(
      (error) {
        emit(ResidentAddRatingFailure(errorMessage: error));
      },
      (success) {
        emit(ResidentAddRatingSuccess());
      },
    );
  }

  Future<void> chooseDriver({required String driverId}) async {
    final String? userId = await getUserId();
    emit(ResidentChooseDriverLoading(driverId: driverId));
    final result = await residnetDriverRepo.chooseDriver(
      driverId: driverId,
      vehicleType: vehicleType.index,
      passengerId: userId!,
      pickupLatitude: fromPlace!.lat,
      pickupLongitude: fromPlace!.lng,
      dropoffLatitude: toPlace!.lat,
      dropoffLongitude: toPlace!.lng,
      pickUpPlace: fromPlace!.name,
      dropOffPlace: toPlace!.name,
    );
    result.fold(
      (error) {
        emit(
          ResidentChooseDriverFailure(errorMessage: error, driverId: driverId),
        );
      },
      (success) {
        tripId = success;
        emit(ResidentChooseDriverSuccess(driverId: driverId));
      },
    );
  }

  Future<bool> isInRide() async {
    final String? userId = await getUserId();

    final result = await residnetDriverRepo.isInRide(passengerId: userId!);

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
  // ===============for real tracking======================

  Timer? liveTrackingTimer;
  bool isDriverArrived = false;
  Future<void> fetchDriverLocationFromBackend() async {
    final result = await residnetDriverRepo.getDriverLocation(
      // user: LatLng(lat, lng),
      driverId: tripModel!.driverId,
    );

    result.fold((error) {}, (location) {
      driverLocation = LatLng(location.latitude, location.longitude);
    });
  }

  Future<void> updateRoutePolyline() async {
    routePoints = await MapServices.getBestRoute(
      start: driverLocation,
      end: LatLng(fromPlace!.lat, fromPlace!.lng),
    );

    emit(ResidentDriverChangeDriverLocation());
  }

  void updateDriverRotation() {
    if (routePoints.length < 2) return;

    driverRotation = MapServices.calculateBearing(
      routePoints.first,
      routePoints[1],
    );
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

      await fetchDriverLocationFromBackend();

      await updateRoutePolyline();

      updateDriverRotation();

      final distance = const Distance().as(
        LengthUnit.Meter,
        driverLocation,
        LatLng(lat, lng),
      );

      if (distance < 10) {
        isDriverArrived = true;
        timer.cancel();
        emit(ResidentDriverArrivedState());
      }

      emit(ResidentDriverChangeDriverLocation());
    });
  }

  void stopLiveTracking() {
    liveTrackingTimer?.cancel();
  }
}
