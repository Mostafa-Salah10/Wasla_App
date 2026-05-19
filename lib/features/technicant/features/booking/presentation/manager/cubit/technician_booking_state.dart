part of 'technician_booking_cubit.dart';

sealed class TechnicianBookingState {}

class TechincainBookingInitialState extends TechnicianBookingState {}

class TechincainBookingNetworkState extends TechnicianBookingState {}

class TechincainBookingOnRetryState extends TechnicianBookingState {}

class TechincainBookingFailureState extends TechnicianBookingState {}

class TechincainBookingUpdateCurrentTapState extends TechnicianBookingState {}

/////GetAllBookings
class TechincainGetBookingsLoadingState extends TechnicianBookingState {}

class TechincainGetBookingsLoadedState extends TechnicianBookingState {
  final List<TechnicainBookingModel> bookings;
  TechincainGetBookingsLoadedState({required this.bookings});
}

/////GetBookingDetails
class TechincainGetBookingDetailsLoadingState extends TechnicianBookingState {}

class TechincainGetBookingDetailsLoadedState extends TechnicianBookingState {
  final TechnicainBookingModel booking;
  TechincainGetBookingDetailsLoadedState({required this.booking});
}

abstract class TechnicianBookingActionState extends TechnicianBookingState {
  final int bookingId;

  TechnicianBookingActionState({required this.bookingId});
}

////AcceptBooking

class TechincainAcceptBookingSuccessState extends TechnicianBookingActionState {
  TechincainAcceptBookingSuccessState({required super.bookingId});
}

class TechincainAcceptBookingFailureState extends TechnicianBookingActionState {
  final String errorMessage;

  TechincainAcceptBookingFailureState({
    required this.errorMessage,
    required super.bookingId,
  });
}

class TechincainAcceptBookingLoadingState extends TechnicianBookingActionState {
  TechincainAcceptBookingLoadingState({required super.bookingId});
}

////CancelBooking

class TechincainCancelBookingSuccessState extends TechnicianBookingActionState {

  TechincainCancelBookingSuccessState({required super.bookingId});
}

class TechincainCancelBookingFailureState extends TechnicianBookingActionState {
  final String errorMessage;

  TechincainCancelBookingFailureState({
    required super.bookingId,
    required this.errorMessage,
  });
}
