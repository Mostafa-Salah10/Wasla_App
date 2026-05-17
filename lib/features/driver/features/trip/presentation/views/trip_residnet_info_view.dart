import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/widgets/bloc_status_handler.dart';
import 'package:wasla/features/driver/features/trip/presentation/manager/cubit/driver_trip_cubit.dart';
import 'package:wasla/features/driver/features/trip/presentation/widgets/trip_resident_info_body.dart';

class TripResidnetInfoView extends StatefulWidget {
  const TripResidnetInfoView({super.key, required this.tripId});
  final int tripId;

  @override
  State<TripResidnetInfoView> createState() => _TripResidnetInfoState();
}

class _TripResidnetInfoState extends State<TripResidnetInfoView> {
  @override
  void initState() {
    getDriverLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocStatusHandler<DriverTripCubit, DriverTripState>(
          body: TripResidentInfoBody(),
          onRetry: () {
            getDriverLocation();
            context.read<DriverTripCubit>().onRetry();
          },
          isNetwork: (state) => state is DriverTripNetworkState,
          isError: (state) => state is DriverTripFailureState,
          buildWhen: (previous, current) =>
              current is DriverTripNetworkState ||
              current is DriverTripFailureState ||
              current is DriverTripOnRetryState,
        ),
      ),
    );
  }

  void getDriverLocation() {
    final cubit = context.read<DriverTripCubit>();
    // cubit.fetchDriverLocation();
    // cubit.passengerLocation = LatLng(
    //   cubit.tripDetails!.pickUpLatitude,
    //   cubit.tripDetails!.pickUpLongitude,
    // );
    cubit.getRideDetails();
    cubit.isDriverArrived = false;
    cubit.isStartedTrip = false;
  }
}
