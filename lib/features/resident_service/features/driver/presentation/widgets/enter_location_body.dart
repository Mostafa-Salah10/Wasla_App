import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/general_button.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/autocomplete_suggestion_list.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/enter_location_dev.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/resident_vehicle_type_button.dart';

class EnterLocationBody extends StatelessWidget {
  const EnterLocationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnterLocationDev(),
        const SizedBox(height: 15),
        ResidentChooseVehicleTypeButton(),
        Divider(height: 20, thickness: 0.8, color: Colors.grey.shade300),
        Expanded(child: AutocompleteSuggestionList()),
        const SizedBox(height: 20),
        BlocConsumer<ResidentDriverCubit, ResidentDriverState>(
          listener: (context, state) {
            if (state is ResidentDriverRequestRideFailure) {
              toastAlert(color: AppColors.error, msg: state.errorMessage);
            }
            if (state is ResidentDriverRequestRideSuccess) {
              context.pushScreen(AppRoutes.chooseDriverScreen);
            }
          },
          buildWhen: (previous, current) =>
              current is ResidentDriverUpdateButtonState ||
              current is ResidentDriverRequestRideFailure ||
              current is ResidentDriverRequestRideLoading ||
              current is ResidentDriverRequestRideSuccess,
          builder: (context, state) {
            final cubit = context.read<ResidentDriverCubit>();
            return GeneralButton(
              color: cubit.isActiveButton
                  ? AppColors.primaryColor
                  : AppColors.gray,
              onPressed: () {
                if (cubit.isActiveButton) {
                  cubit.requestRide();
                }
              },
              text: state is ResidentDriverRequestRideLoading
                  ? 'loading'.tr(context)
                  : 'findDriver'.tr(context),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
