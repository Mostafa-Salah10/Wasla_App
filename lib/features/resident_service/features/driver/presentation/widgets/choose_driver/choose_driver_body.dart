import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/widgets/empty_data_widget.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/choose_driver/choose_driver_list_item.dart';

class ChooseDriverBody extends StatelessWidget {
  const ChooseDriverBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResidentDriverCubit>();
    return cubit.selectedDrivers.isEmpty
        ? EmptyStateWidget(title: 'noDrivers'.tr(context))
        : ListView.builder(
            itemCount: cubit.selectedDrivers.length,
            itemBuilder: (_, index) =>
                ChoosedDriverListItem(driver: cubit.selectedDrivers[index]),
          );
  }
}
