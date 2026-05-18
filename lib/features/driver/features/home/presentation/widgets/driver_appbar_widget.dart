import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/enums/driver_enums.dart';
import 'package:wasla/core/widgets/custom_home_app_bar.dart';
import 'package:wasla/features/driver/features/home/data/models/driver_profile_model.dart';
import 'package:wasla/features/driver/features/home/presentation/manager/cubit/driver_cubit.dart';
import 'package:wasla/features/driver/features/trip/presentation/manager/cubit/driver_trip_cubit.dart';

class DriverAppBar extends StatefulWidget {
  const DriverAppBar({super.key});

  @override
  State<DriverAppBar> createState() => _DriverAppBarState();
}

class _DriverAppBarState extends State<DriverAppBar> {
  DriverProfileModel? driver;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      buildWhen: (previous, current) => current is DriverGetProfileSuccess,
      builder: (context, state) {
        if (state is DriverGetProfileSuccess) {
          driver = state.driver;
          context.read<DriverTripCubit>().vehicleType = VehicleType.formInt(
            driver!.vehicleType,
          );
        }
        return CustomHomeAppBar(
          isLoading: driver == null,
          userName: driver?.fullName,
          imageUrl: driver?.imageUrlBase,
          onBookmarkTap: () {},
          showBookmark: false,
        );
      },
    );
  }
}
