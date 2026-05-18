import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/custom_plusing_animation_widget.dart';

class EnterYourLocationSimulateWidget extends StatelessWidget {
  const EnterYourLocationSimulateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: BlocBuilder<ResidentDriverCubit, ResidentDriverState>(
        buildWhen: (previous, current) =>
            current is ResidentDriverGetMyLocationSuccessState,
        builder: (context, state) {
          return Column(
            children: [
              Text(
                state is ResidentDriverGetMyLocationSuccessState
                    ? 'letsTravel'.tr(context)
                    : 'searchYourLocation'.tr(context),

                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              if (state is ResidentDriverGetMyLocationSuccessState)
                TextField(
                  readOnly: true,
                  onTap: () =>
                      context.pushScreen(AppRoutes.enterYourLocationScreen),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'enterLocation'.tr(context),
                    suffixIcon: Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primaryColor,
                    ),
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                PulsingAvatar(
                  withImage: false,
                  imageUrl: '',
                  size: 25,
                  glowColor: AppColors.primaryColor,
                ),
            ],
          );
        },
      ),
    );
  }
}
