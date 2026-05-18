import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/enums/payment_method.dart';
import 'package:wasla/core/enums/service_provider_type.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/helpers/url_helper.dart';
import 'package:wasla/core/repo/global_repo.dart';
import 'package:wasla/features/payment/payment_service.dart';
import 'package:wasla/features/gym/features/packages/data/models/gym_package_model.dart';
import 'package:wasla/features/profile/data/models/gym_model.dart';
import 'package:wasla/features/resident_service/features/gym/data/models/booking_returned_data_model.dart';
import 'package:wasla/features/resident_service/features/gym/data/models/gym_data_model.dart';
import 'package:wasla/features/resident_service/features/gym/data/repo/gym_resident_repo.dart';

part 'gym_resident_state.dart';

class GymResidentCubit extends Cubit<GymResidentState> {
  GymResidentCubit(this.gymResidentRepo) : super(GymResidentInitial());

  final GymResidentRepo gymResidentRepo;

  List<GymDataModel> allGyms = [];
  List<GymPackageModel> gymPackages = [];
  int pageNumber = 1;
  int pageSize = 6;
  BookingReturnedDataModel? bookingReturnedDataModel;
  int totalGyms = -1;
  GymModel? gym;
  int serviceIdFlag = -1;
  String selecedGymId = '';

  PaymentMethod paymentMethod = PaymentMethod.cash;

  void onRetry() {
    emit(GymResidentOnRetryState());
  }

  Future<void> getAllGyms({required bool fromPagination}) async {
    if (totalGyms == allGyms.length) {
      return;
    }
    if (fromPagination) {
      emit(GymResidentGetAllGymsFromPaginationLoading());
    } else {
      emit(GymResidentGetAllGymsLoading());
    }
    final result = await gymResidentRepo.getAllGym(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    result.fold(
      (err) {
        if (err is NoInternetFailure) {
          emit(GymResidentNetworkState());
        } else {
          emit(GymResidentFailureState());
        }
      },
      (success) {
        if (success.gyms.isNotEmpty) {
          pageNumber++;
          totalGyms = success.totalCount;
          allGyms.addAll(success.gyms);
        }
        emit(GymResidentGetAllGymsSuccess());
      },
    );
  }

  Future<void> getGymDetails({required String gymId}) async {
    final result = await GlobalRepo.geGymProfile(gymId: gymId);
    result.fold(
      (error) {
        if (error is NoInternetFailure) {
          emit(GymResidentNetworkState());
        } else {
          emit(GymResidentFailureState());
        }
      },
      (success) {
        gym = success;
        emit(GymResidentGetGymDetailsSuccess());
      },
    );
  }

  Future<void> getGymPackages({required String gymId}) async {
    gymPackages.clear();
    emit(GymResidentGetGymPackagesLoading());
    final result = await GlobalRepo.getGymPackagesAndOffers(gymId: gymId);
    result.fold(
      (error) {
        if (error is NoInternetFailure) {
          emit(GymResidentNetworkState());
        } else {
          emit(GymResidentFailureState());
        }
      },
      (success) {
        gymPackages = success;
        emit(GymResidentGetGymPackagesSuccess());
      },
    );
  }

  Future<void> bookAtGym({
    required String gymId,
    required int bookingId,
    required int amount,
  }) async {
    emit(GymResidentBookingLoading(itemId: bookingId));
    final String? residentId = await getUserId();
    final result = await gymResidentRepo.bookAtGym(
      gymId: gymId,
      serviceId: bookingId,
      residentId: residentId!,
      isPaymentOnline: paymentMethod == PaymentMethod.creditCard,
    );
    result.fold(
      (error) {
        emit(GymResidentBookingFailure(errMsg: error, itemId: bookingId));
      },
      (success) async {
        if (paymentMethod == PaymentMethod.cash) {
          emit(
            GymResidentBookingSuccessFromCash(
              bookingId: bookingId,
              itemId: bookingId,
            ),
          );

          return;
        } else {
          bookingReturnedDataModel = success;
          final paymentResult = await PaymentService.createPayment(
            userId: residentId,
            serviceProviderId: gymId,
            amount: amount,
            bookingId: success.bookingId,
            serviceProviderType: ServiceProviderTypeEnum.gym.index + 1,
            entityType: EntityType.booking.index,
            paymentMethod: paymentMethod.index + 1,
          );
          paymentResult.fold(
            (error) {
              emit(GymResidentBookingFailure(errMsg: error, itemId: bookingId));
            },
            (paymentUrl) {
              emit(
                GymResidentBookingSuccess(
                  bookingId: success.bookingId,
                  itemId: bookingId,
                ),
              );
              UrlHelper.openWebsite(paymentUrl);
            },
          );
        }
      },
    );
  }

  void reset() {
    pageNumber = 1;
    pageSize = 6;
    totalGyms = -1;
    allGyms.clear();
    gym = null;
    serviceIdFlag = -1;
  }
}
