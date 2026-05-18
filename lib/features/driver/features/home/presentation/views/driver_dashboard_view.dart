import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/widgets/bloc_status_handler.dart';
import 'package:wasla/features/driver/features/home/presentation/manager/cubit/driver_cubit.dart';
import 'package:wasla/features/driver/features/home/presentation/widgets/dirver_dahsboard_body.dart';

class DriverDashboardView extends StatefulWidget {
  const DriverDashboardView({super.key});

  @override
  State<DriverDashboardView> createState() => _DriverDashboardViewState();
}

class _DriverDashboardViewState extends State<DriverDashboardView> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocStatusHandler<DriverCubit, DriverState>(
        body: const DirverDahsboardBody(),
        onRetry: () {
          context.read<DriverCubit>().onRetry();
          getData();
        },
        isNetwork: (state) => state is DriverNetworkState,
        isError: (state) => state is DriverFailureState,
        buildWhen: (previous, current) =>
            current is DriverNetworkState ||
            current is DriverFailureState ||
            current is DriverOnRetryState,
      ),
    );
  }

  void getData() {
    final cubit = context.read<DriverCubit>();
    cubit.getDriverProfile();

    cubit.getDriverStatistics();
  }
}
