import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/features/profile/presentation/widgets/custom_switch_button.dart';
import 'package:wasla/features/profile/presentation/widgets/profile_item.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';

class RestauantStatusWidget extends StatelessWidget {
  const RestauantStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResidentMenuCubit, ResidentMenuState>(
      listener: (context, state) {
        if (state is ResidentChangeResStatusFailureState) {
          toastAlert(msg: state.errorMsge, color: AppColors.red);
        }
      },
      builder: (context, state) {
        return Skeletonizer(
          enabled:
              state is ResidentGetResStatusLoadingState ||
              state is ResidentMenuInitial,
          child: CustomSwitchButtonWithTitle(
            title: 'recieve_orders'.tr(context),
            trailing: CustomSwitchButton(
              withouteTransilate: true,
              onChanged: (value) {
                context.read<ResidentMenuCubit>().changeRestauantStatus();
              },
              value: context.read<ResidentMenuCubit>().restaurantStatus,
            ),
          ),
        );
      },
    );
  }
}
