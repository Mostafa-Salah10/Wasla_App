import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/resident_trip_model.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/trip_details/dirver_info_card_footer.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/trip_details/driver_card_info_source_dest.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/trip_details/driver_info_car_details.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/trip_details/driver_info_card_header.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/trip_details/show_driver_track_tile.dart';

class DriverInfoCard extends StatelessWidget {
  const DriverInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResidentDriverCubit>();
    return BlocBuilder<ResidentDriverCubit, ResidentDriverState>(
      buildWhen: (previous, current) =>
          current is ResidentDriverGetRideDetailsSuccess ||
          current is ResidentDriverGetRideDetailsLoading,

      builder: (context, state) {
        if (state is ResidentDriverGetRideDetailsLoading ||
            cubit.tripModel == null) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.acceptGreen,
              size: 50.0,
            ),
          );
        } else {
          return _ResidentTripData(cubit.tripModel!);
        }
      },
    );
  }
}

class _ResidentTripData extends StatelessWidget {
  const _ResidentTripData(this.trip);
  final ResidentTripModel trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          DriverInfoCardHeader(trip: trip),
          Divider(height: 10, thickness: 0.5, color: Colors.grey.shade300),
          DriverInfoCarDetails(trip: trip),
          Divider(height: 20, thickness: 0.5, color: Colors.grey.shade300),
          DriverCardInfoSourceDest(
            destination: trip.dropOffPlace,
            source: trip.pickUpPlace,
            destinationDate: trip.endRide,
            sourceDate: trip.startRide,
          ),
          Divider(height: 20, thickness: 0.5, color: Colors.grey.shade300),
          DirverInfoCardFooter(trip: trip),
          Divider(height: 20, thickness: 0.5, color: Colors.grey.shade300),
          BlocBuilder<ResidentDriverCubit, ResidentDriverState>(
            buildWhen: (previous, current) =>
                current is ResidentDriverArrivedState,
            builder: (context, state) {

              // final cubit=context.read<ResidentDriverCubit>();
              // cubit.fromPlace.lat=trip.!;
              // cubit.fromPlace.lng=trip.pickupLongitude!;
          
              return ShowDriverTrackTile(
                showMap: !context.read<ResidentDriverCubit>().isDriverArrived,
                title: 'showDriverLocation',
                route: AppRoutes.residentDriverTrakcingScreen,
              );
            },
          ),
        ],
      ),
    );
  }
}
