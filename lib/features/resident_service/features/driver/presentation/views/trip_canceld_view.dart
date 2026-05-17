import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/widgets/general_button.dart';
import 'package:wasla/features/driver/features/trip/presentation/manager/cubit/driver_trip_cubit.dart';

class TripCancelledScreen extends StatefulWidget {
  final bool isDriver;

  const TripCancelledScreen({super.key, required this.isDriver});

  @override
  State<TripCancelledScreen> createState() => _TripCancelledScreenState();
}

class _TripCancelledScreenState extends State<TripCancelledScreen> {
  @override
  void initState() {
    super.initState();
    reset();
  }

  // isDriver = true  →  الكلام موجه للسواق  →  الراكب هو اللي كنسل
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              if (context.canPop()) {
                context.pop();
              } else {
                if (widget.isDriver) {
                  context.pushAndRemoveAllScreens(
                    AppRoutes.driverBottomNavBarScreen,
                  );
                } else {
                  context.pushAndRemoveAllScreens(AppRoutes.residenBottomNavBar);
                }
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCEBEB),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7C1C1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 40,
                        color: Color(0xFFE24B4A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'tripCancelled'.tr(context),
                  style: Theme.of(context).textTheme.displayMedium,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE24B4A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Text(
                  widget.isDriver
                      ? 'tripCancelledMessage'.tr(context)
                      : 'driverCancelled'.tr(context),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),

                const Spacer(),
                GeneralButton(
                  onPressed: () {
                    if (widget.isDriver) {
                      context.pushAndRemoveAllScreens(
                        AppRoutes.driverBottomNavBarScreen,
                      );
                    } else {
                      context.pushAndRemoveAllScreens(
                        AppRoutes.residenBottomNavBar,
                      );
                    }
                  },
                  text: 'backToHome'.tr(context),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void reset() {
    final cubit = context.read<DriverTripCubit>();
    cubit.tripId = -1;
    cubit.tripIdStored = -1;
  }
}
