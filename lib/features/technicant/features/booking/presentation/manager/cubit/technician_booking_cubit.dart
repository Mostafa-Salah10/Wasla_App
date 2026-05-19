import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/enums/technician_booking_status.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/features/technicant/features/booking/data/models/technicain_booking_model.dart';
import 'package:wasla/features/technicant/features/booking/data/repo/technician_bookings_repo.dart';

part 'technician_booking_state.dart';

class TechnicianBookingCubit extends Cubit<TechnicianBookingState> {
  TechnicianBookingCubit(this.technicianBookingsRepo)
    : super(TechincainBookingInitialState());

  final TechnicianBookingsRepo technicianBookingsRepo;

  int currentTap = 0;
  List<TechnicainBookingModel> bookings = [];

  void whenRetry() {
    emit(TechincainBookingOnRetryState());
  }

  void updateCurrentTap({required int index}) {
    if (currentTap != index) {
      currentTap = index;
      emit(TechincainBookingUpdateCurrentTapState());
      filterBookingsByStatus();
    }
  }

  Future<void> getBookings() async {
    final String? technicianId = await getUserId();
    emit(TechincainGetBookingsLoadingState());
    final result = await technicianBookingsRepo.getBookings(
      technicainId: technicianId!,
    );
    result.fold(
      (failure) {
        if (failure is NoInternetFailure) {
          emit(TechincainBookingNetworkState());
        } else {
          emit(TechincainBookingFailureState());
        }
      },
      (bookings) {
        this.bookings = bookings;
        filterBookingsByStatus();
      },
    );
  }

  void filterBookingsByStatus() {
    final filteredBookings = bookings
        .where((booking) => booking.status.index == currentTap)
        .toList();
    emit(TechincainGetBookingsLoadedState(bookings: filteredBookings));
  }

  Future<void> acceptBooking({required int bookingId}) async {
    emit(TechincainAcceptBookingLoadingState(bookingId: bookingId));
    final result = await technicianBookingsRepo.acceptBooking(
      bookingId: bookingId,
    );
    result.fold(
      (failure) => emit(
        TechincainAcceptBookingFailureState(
          errorMessage: failure,
          bookingId: bookingId,
        ),
      ),
      (_) {
        bookings
                .firstWhere((booking) => booking.bookingId == bookingId)
                .status =
            TechnicianBookingStatus.accepted;
        emit(TechincainAcceptBookingSuccessState(bookingId: bookingId));
        filterBookingsByStatus();
      },
    );
  }

  Future<void> acceptBookingFromDetailsScreen({required int bookingId}) async {
    emit(TechincainAcceptBookingLoadingState(bookingId: bookingId));
    final result = await technicianBookingsRepo.acceptBooking(
      bookingId: bookingId,
    );
    result.fold(
      (failure) => emit(
        TechincainAcceptBookingFailureState(
          errorMessage: failure,
          bookingId: bookingId,
        ),
      ),
      (_) {
        emit(TechincainAcceptBookingSuccessState(bookingId: bookingId));
      },
    );
  }

  Future<void> cancelBooking({required int bookingId}) async {
    final result = await technicianBookingsRepo.cancelBooking(
      bookingId: bookingId,
    );
    result.fold(
      (failure) => emit(
        TechincainCancelBookingFailureState(
          errorMessage: failure,
          bookingId: bookingId,
        ),
      ),
      (_) {
        bookings
                .firstWhere((booking) => booking.bookingId == bookingId)
                .status =
            TechnicianBookingStatus.cancelled;
        emit(TechincainCancelBookingSuccessState(bookingId: bookingId));
        filterBookingsByStatus();
      },
    );
  }

  Future<void> getBookingDatails({required int bookingId}) async {
    emit(TechincainGetBookingDetailsLoadingState());
    final result = await technicianBookingsRepo.getBookingDetails(
      bookingId: bookingId,
    );

    result.fold(
      (failure) {
        if (failure is NoInternetFailure) {
          emit(TechincainBookingNetworkState());
        } else {
          emit(TechincainBookingFailureState());
        }
      },
      (booking) {
        emit(TechincainGetBookingDetailsLoadedState(booking: booking));
      },
    );
  }
}
