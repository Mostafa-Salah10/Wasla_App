import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/enums/driver_status.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/assets.dart';
import 'package:wasla/core/widgets/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:wasla/core/widgets/custom_bottom_sheet_confirm_widget.dart';
import 'package:wasla/features/chat/presentation/views/last_users_viwe.dart';
import 'package:wasla/features/driver/features/booking/presentation/views/driver_bookings_view.dart';
import 'package:wasla/features/driver/features/home/presentation/manager/cubit/driver_cubit.dart';
import 'package:wasla/features/driver/features/home/presentation/views/driver_dashboard_view.dart';
import 'package:wasla/features/driver/features/trip/presentation/manager/cubit/driver_trip_cubit.dart';
import 'package:wasla/features/profile/presentation/views/profile_view.dart';
import 'package:wasla/features/social_media/presentation/views/all_posts_view.dart';

class DriverBottomNavBar extends StatefulWidget {
  const DriverBottomNavBar({super.key});

  @override
  State<DriverBottomNavBar> createState() => _DriverBottomNavBarState();

  static List<Widget> screens = [
    const DriverDashboardView(),
    const DriverBookingsView(),
    const LastUsersViwe(),
    const AllPostsView(),
    const ProfileView(),
  ];
}

class _DriverBottomNavBarState extends State<DriverBottomNavBar> {
  late final AppLifecycleListener listener;
  @override
  void initState() {
    call(driverStatus: DriverStatus.online);
    listener = AppLifecycleListener(
      onDetach: () {
        changeMyStatus(DriverStatus.offline);
      },
    );

    checkIsInRide();
    super.initState();
  }

  void checkIsInRide() async {
    final cubit = context.read<DriverTripCubit>();
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
                AppRoutes.residentTripInfoScreen,
                extra: cubit.tripId,
              );
              Navigator.pop(bottomSheetContext);
            },
            onConfirm: () async {
              Navigator.pop(bottomSheetContext);
              await cubit.cancelRide();
              if (cubit.state is DriverCancelRideSuccess) {
                toastAlert(
                  color: AppColors.primaryColor,
                  msg: 'tripCancelled'.tr(context),
                );
              } else if (cubit.state is DriverCancelRideFailure) {
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
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      buildWhen: (previous, current) =>
          current is DriverUpdateBottomNabBarIndex,
      builder: (context, state) {
        final cubit = context.read<DriverCubit>();

        return Scaffold(
          body: DriverBottomNavBar.screens[cubit.bottomNabBarIndex],
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: cubit.bottomNabBarIndex,
            titles: getTitles(context),
            selectedIcons: selectedIcons,
            unSelectedIcons: unSelectedIcons,
            onIndexChange: (value) {
              cubit.updateBottomNavBarIndex(index: value);
            },
            onPop: () {
              if (cubit.bottomNabBarIndex != 0) {
                cubit.updateBottomNavBarIndex(index: 0);
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
    'community'.tr(context),

    'profile'.tr(context),
  ];

  List<String> get unSelectedIcons => [
    Assets.assetsImagesHomeOutlined,
    Assets.assetsImagesBookingOutlined,
    Assets.assetsImagesChatOutlined,
    Assets.assetsImagesPeopleOutlined,
    Assets.assetsImagesPersonOutlined,
  ];

  List<String> get selectedIcons => [
    Assets.assetsImagesHomeFilled,
    Assets.assetsImagesBookingFilled,
    Assets.assetsImagesChatFilled,
    Assets.assetsImagesGroup,
    Assets.assetsImagesPeronFilled,
  ];

  void updateMyLocation() {
    context.read<DriverTripCubit>().sendDriverLocatonToBackEnd();
  }

  void changeMyStatus(DriverStatus driverStatus) {
    context.read<DriverTripCubit>().updateDriverStatus(
      driverStatus: driverStatus,
    );
  }

  void call({required DriverStatus driverStatus}) {
    changeMyStatus(driverStatus);
    updateMyLocation();
  }
}
