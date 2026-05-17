import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/custom_bottom_sheet_confirm_widget.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/laod_accept_untill_driver/cancel_request_button.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/laod_accept_untill_driver/search_header_card.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/laod_accept_untill_driver/trip_info_card.dart';

class LoadUntillTripView extends StatefulWidget {
  const LoadUntillTripView({super.key});

  @override
  State<LoadUntillTripView> createState() => _LoadUntillTripViewState();
}

class _LoadUntillTripViewState extends State<LoadUntillTripView> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          } else {
            showModalBottomSheet(
              context: context,
              builder: (bottomSheetContext) {
                return CustomBottomSheetConfirmWidget(
                  cancelText: 'no'.tr(context),
                  confirmText: 'yesCancel'.tr(context),
                  onConfirm: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<ResidentDriverCubit>().cancelRide();
                  },
                  title: 'cancelWaiting'.tr(context),
                  description: 'cancelWaitingDesc'.tr(context),
                );
              },
            );
          }
        },
        child: Column(
          children: [
            const SearchHeaderCard(),
            const SizedBox(height: 25),
            const TripInfoCard(),
            const Spacer(),
            CancelDriverButton(
              title: "cancelRequest".tr(context),
              isSearchingRoute: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void initData() {
    final cubit = context.read<ResidentDriverCubit>();
    cubit.isDriverArrived = false;
    cubit.startLoadingTimer();
  }
}

class CancelDriverButton extends StatelessWidget {
  const CancelDriverButton({
    super.key,
    required this.title,
    required this.isSearchingRoute,
  });
  final String title;
  final bool isSearchingRoute;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResidentDriverCubit, ResidentDriverState>(
      buildWhen: (previous, current) =>
          current is ResidentDriverCancelRideLoading ||
          current is ResidentDriverCancelRideSuccess ||
          current is ResidentDriverCancelRideFailure,
      listener: (context, state) {
        if (state is ResidentDriverCancelRideSuccess) {
          toastAlert(
            color: AppColors.primaryColor,
            msg: 'tripCancelled'.tr(context),
          );

          if (isSearchingRoute) {
            context.pop();
          } else {
            context.pop();
            context.pushAndRemoveAllScreens(AppRoutes.residenBottomNavBar);
          }
        }
        if (state is ResidentDriverCancelRideFailure) {
          toastAlert(color: AppColors.error, msg: state.errorMessage);
        }
      },
      builder: (context, state) {
        return CancelRequestButton(
          title: state is ResidentDriverCancelRideLoading
              ? 'loading'.tr(context)
              : title,
          onTap: () {
            context.read<ResidentDriverCubit>().cancelRide();
          },
        );
      },
    );
  }
}
