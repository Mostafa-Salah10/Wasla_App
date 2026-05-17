import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/enums/booking_filter.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/assets.dart';
import 'package:wasla/core/widgets/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:wasla/core/widgets/custom_bottom_sheet_confirm_widget.dart';
import 'package:wasla/features/chat/presentation/views/last_users_viwe.dart';
import 'package:wasla/features/profile/presentation/views/profile_view.dart';
import 'package:wasla/features/resident_service/features/booking/presentation/manager/cubit/resident_booking_cubit.dart';
import 'package:wasla/features/resident_service/features/booking/presentation/views/resident_all_bookings_view.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';
import 'package:wasla/features/resident_service/features/home/presentation/manager/cubit/home_resident_cubit.dart';
import 'package:wasla/features/resident_service/features/home/presentation/views/resident_home_view.dart';

class HomeResidentNavbar extends StatefulWidget {
  const HomeResidentNavbar({super.key});

  @override
  State<HomeResidentNavbar> createState() => _HomeResidentNavbarState();

  static List<Widget> screens = [
    const ResidentHomeView(),
    ResidentAllBookingsView(),
    LastUsersViwe(),
    const ProfileView(),
  ];
}

class _HomeResidentNavbarState extends State<HomeResidentNavbar> {
  @override
  void initState() {
    super.initState();
    // checkIsInRide();
  }

  void checkIsInRide() async {
    final cubit = context.read<ResidentDriverCubit>();
    final bool isInRide = await cubit.isInRide();

    if (isInRide) {
      showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (bottomSheetContext) {
          return CustomBottomSheetConfirmWidget(
            cancelText: 'noBack'.tr(context),
            confirmText: 'yesCancel'.tr(context),
            onCancel: () {
              context.push(
                AppRoutes.driverTripDetailsScreen,
                extra: cubit.tripId,
              );
              Navigator.pop(bottomSheetContext);
            },
            onConfirm: () async {
              Navigator.pop(bottomSheetContext);
              await cubit.cancelRide();
              if (cubit.state is ResidentDriverCancelRideSuccess) {
                toastAlert(
                  color: AppColors.primaryColor,
                  msg: 'tripCancelled'.tr(context),
                );
              } else if (cubit.state is ResidentDriverCancelRideFailure) {
                toastAlert(
                  color: AppColors.error,
                  msg: 'somethingWentWrong'.tr(context),
                );
              }
            },
            title: 'cancelRide'.tr(context),
            description: 'cancelRideDesc'.tr(context),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeResidentCubit, HomeResidentState>(
      buildWhen: (previous, current) =>
          current is HomeResidentUpadateBottomNavBarCurrentIndex,
      builder: (context, state) {
        final cubit = context.read<HomeResidentCubit>();

        return Scaffold(
          body: HomeResidentNavbar.screens[cubit.navBarcurrentIndex],
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: cubit.navBarcurrentIndex,
            titles: getTitles(context),
            selectedIcons: selectedIcons,
            unSelectedIcons: unSelectedIcons,
            onIndexChange: (value) {
              cubit.updateNavBarCurrentIndex(value);

              if (value == 1) {
                context.read<ResidentBookingCubit>().bookingFilter =
                    BookingFilter.values[0];
              }
            },
            onPop: () {
              if (cubit.navBarcurrentIndex != 0) {
                cubit.updateNavBarCurrentIndex(0);
              } else {
                SystemNavigator.pop();
              }
            },
          ),
        );
      },
    );
  }

  List<String> getTitles(BuildContext context) => [
    'home'.tr(context),
    'booking'.tr(context),
    'chat'.tr(context),
    'profile'.tr(context),
  ];

  List<String> get unSelectedIcons => [
    Assets.assetsImagesHomeOutlined,
    Assets.assetsImagesBookingOutlined,
    Assets.assetsImagesChatOutlined,
    Assets.assetsImagesPersonOutlined,
  ];

  List<String> get selectedIcons => [
    Assets.assetsImagesHomeFilled,
    Assets.assetsImagesBookingFilled,
    Assets.assetsImagesChatFilled,
    Assets.assetsImagesPeronFilled,
  ];
}
