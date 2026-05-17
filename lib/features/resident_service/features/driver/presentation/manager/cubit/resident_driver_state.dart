part of 'resident_driver_cubit.dart';

sealed class ResidentDriverState {}

final class ResidentDriverInitial extends ResidentDriverState {}

///3 basic states

final class ResidentDriverNetworkState extends ResidentDriverState {}

final class ResidentDriverFailureState extends ResidentDriverState {}

final class ResidentDriverOnRetryState extends ResidentDriverState {}

final class ResidentDriverUpdateButtonState extends ResidentDriverState {}

final class ResidentDriverSearchToPlaceState extends ResidentDriverState {}

final class ResidentDriverChoosePlaceState extends ResidentDriverState {}

final class ResidentDriverGetMyLocationLoadingState
    extends ResidentDriverState {}

final class ResidentDriverGetMyLocationSuccessState
    extends ResidentDriverState {}

final class ResidentDriverChangeDriverLocation extends ResidentDriverState {}

final class ResidentDriverBackToMyLocatonLocation extends ResidentDriverState {}

class ResidentDriverArrivedState extends ResidentDriverState {}

class ResidentDriverUpdateSelectedStarIndex extends ResidentDriverState {}

class ResidentDriverChangeVehicleType extends ResidentDriverState {}

class ResidentDriverCancelRideLoading extends ResidentDriverState {}

class ResidentDriverCancelRideSuccess extends ResidentDriverState {}

class ResidentDriverCancelRideFailure extends ResidentDriverState {
  final String errorMessage;
  ResidentDriverCancelRideFailure({required this.errorMessage});
}

class ResidentDriverRequestRideLoading extends ResidentDriverState {}

class ResidentDriverRequestRideSuccess extends ResidentDriverState {}

class ResidentDriverRequestRideFailure extends ResidentDriverState {
  final String errorMessage;
  ResidentDriverRequestRideFailure({required this.errorMessage});
}

class ResidentDriverGetRideDetailsLoading extends ResidentDriverState {}

class ResidentDriverGetRideDetailsSuccess extends ResidentDriverState {}

class ResidentAddRatingLoading extends ResidentDriverState {}

class ResidentAddRatingSuccess extends ResidentDriverState {}

class ResidentAddRatingFailure extends ResidentDriverState {
  final String errorMessage;
  ResidentAddRatingFailure({required this.errorMessage});
}

////get driver profile

class ResidentDriverProfileLoading extends ResidentDriverState {}

class ResidentDriverProfileSuccess extends ResidentDriverState {
  final DriverProfileModel driver;

  ResidentDriverProfileSuccess({required this.driver});
}

////choose driver states

abstract class ResidentChooseDriverState extends ResidentDriverState {
  final String driverId;

  ResidentChooseDriverState({required this.driverId});
}

class ResidentChooseDriverLoading extends ResidentChooseDriverState {
  ResidentChooseDriverLoading({required super.driverId});
}

class ResidentChooseDriverSuccess extends ResidentChooseDriverState {
  ResidentChooseDriverSuccess({required super.driverId});
}

class ResidentChooseDriverFailure extends ResidentChooseDriverState {
  final String errorMessage;
  ResidentChooseDriverFailure( { required this.errorMessage, required super.driverId});
}
