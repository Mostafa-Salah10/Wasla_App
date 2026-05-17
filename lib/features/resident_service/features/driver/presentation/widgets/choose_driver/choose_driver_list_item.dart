import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/custom_image_with_stack.dart';
import 'package:wasla/features/resident_service/features/doctor/presentation/widgets/custom_doc_list_item_desc.dart';
import 'package:wasla/features/resident_service/features/driver/data/models/choose_driver_model.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';

class ChoosedDriverListItem extends StatelessWidget {
  final ChooseDriverModel driver;
  const ChoosedDriverListItem({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? AppColors.blackColor.withOpacity(0.2)
            : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),

      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildImageWithStackWidget(imageUrl: driver.photo),
            const SizedBox(width: 18),
            Expanded(child: ChooseDriverListItemData(driver: driver)),
          ],
        ),
      ),
    );
  }
}

class ChooseDriverListItemData extends StatelessWidget {
  const ChooseDriverListItemData({super.key, required this.driver});
  final ChooseDriverModel driver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithWidget(
          title: driver.name,
          widget: ChooseDriverButton(driverId: driver.id),
        ),
        Divider(height: 20, color: AppColors.primaryColor, thickness: .1),
        Text(
          "${"price".tr(context)}: ${driver.price.toStringAsFixed(0)} ${"egb".tr(context)}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(color: AppColors.gray),
        ),
        const SizedBox(height: 10),
        ReviewPart(rating: driver.rate.toDouble()),
      ],
    );
  }
}

class ChooseDriverButton extends StatelessWidget {
  const ChooseDriverButton({super.key, required this.driverId});

  final String driverId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResidentDriverCubit, ResidentDriverState>(
      buildWhen: (previous, current) =>
          current is ResidentChooseDriverState && current.driverId == driverId,
      listenWhen: (previous, current) =>
          current is ResidentChooseDriverState && current.driverId == driverId,
      listener: (context, state) {
        if (state is ResidentChooseDriverFailure) {
          toastAlert(color: AppColors.error, msg: state.errorMessage);
        }
        if (state is ResidentChooseDriverSuccess) {
          context.pushScreen(AppRoutes.loadUntillTripScreen);
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            final cubit = context.read<ResidentDriverCubit>();
            if (state is! ResidentChooseDriverLoading) {
              cubit.chooseDriver(driverId: driverId);
            }
          },
          child: Container(
            width: 60, 
            height: 25,
            decoration: ShapeDecoration(
              color: AppColors.primaryColor,
              shape: StadiumBorder(),
            ),

            child: Center(
              child: Text(
                state is ResidentChooseDriverLoading
                    ? "loading".tr(context)
                    : "request".tr(context),
                style: TextStyle(fontSize: 12, color: AppColors.whiteColor),
              ),
            ),
          ),
        );
      },
    );
  }
}
