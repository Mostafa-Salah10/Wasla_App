
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/service/maps/models/places_model.dart';
import 'package:wasla/core/widgets/bloc_status_handler.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/trip_details/trip_details_body.dart';

class DriverTripDetailsView extends StatefulWidget {
  const DriverTripDetailsView({super.key, required this.tripId});
  final int tripId;

  @override
  State<DriverTripDetailsView> createState() => _DriverTripDetailsViewState();
}

class _DriverTripDetailsViewState extends State<DriverTripDetailsView> {
  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text("tripDetails".tr(context)),
      ),
      body: SafeArea(
        child: BlocStatusHandler<ResidentDriverCubit, ResidentDriverState>(
          body: const DriverTripDetailsViewBody(),
          onRetry: () {
            context.read<ResidentDriverCubit>().onRetry();
            getDetails();
          },
          isNetwork: (state) => state is ResidentDriverNetworkState,
          isError: (state) => state is ResidentDriverFailureState,
          buildWhen: (previous, current) =>
              current is ResidentDriverNetworkState ||
              current is ResidentDriverFailureState ||
              current is ResidentDriverOnRetryState,
        ),
      ),
    );
  }

  void getDetails() async {
    final cubit = context.read<ResidentDriverCubit>();
    cubit.tripId = widget.tripId;
    await cubit.getTripForResident();
    if (cubit.fromPlace == null || cubit.toPlace == null) {
      cubit.fromPlace = PlaceModel(
        name: cubit.tripModel!.pickUpPlace,
        lat: cubit.tripModel!.pickUpLatitude,
        lng: cubit.tripModel!.pickUpLongitude,
        country: 'Egypt',
      );
      cubit.toPlace = PlaceModel(
        name: cubit.tripModel!.dropOffPlace,
        lat: 0,
        lng: 0,
        country: 'Egypt',
      );
    }
  }
}
