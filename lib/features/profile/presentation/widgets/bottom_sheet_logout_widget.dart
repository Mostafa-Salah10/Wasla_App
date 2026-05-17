import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/cache/secure_storage_helper.dart';
import 'package:wasla/core/database/cache/shared_preferences_helper.dart';
import 'package:wasla/core/enums/service_role.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/get_right_route.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/app_strings.dart';
import 'package:wasla/core/widgets/general_button.dart';
import 'package:wasla/core/widgets/under_line_widget.dart';
import 'package:wasla/features/auth/presentation/manager/cubit/auth_cubit.dart';
import 'package:wasla/features/driver/features/trip/presentation/manager/cubit/driver_trip_cubit.dart';
import 'package:wasla/features/notifications/service/fcm_notifications.dart';

class BottomSheetLogoutWidget extends StatelessWidget {
  const BottomSheetLogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          UnderLineWidget(),
          _buildTextWidget(context),
          const Divider(thickness: 0.3),
          _buildTextDescWidget(context),
          const SizedBox(),
          _buildButtons(context),
        ],
      ),
    );
  }

  Text _buildTextWidget(BuildContext context) => Text(
    "logout".tr(context),
    style: Theme.of(
      context,
    ).textTheme.headlineMedium!.copyWith(color: Colors.red),
  );

  Text _buildTextDescWidget(BuildContext context) {
    return Text(
      "logout_desc".tr(context),
      style: Theme.of(
        context,
      ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w900),
    );
  }

  Row _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GeneralButton(
            onPressed: () {
              context.popScreen();
            },
            text: "cancel".tr(context),
            height: 45,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLogOutFailure) {
                toastAlert(color: AppColors.red, msg: state.errMsg);
              } else if (state is AuthLogOutSuccess) {}
            },
            builder: (acceptContext, state) {
              return GeneralButton(
                onPressed: () async {
                  final router = GoRouter.of(context);
                  final driverTripCubit = context.read<DriverTripCubit>();

                  acceptContext.popScreen();

                  final String? userId = await getUserId();
                  final String? role =
                      SharedPreferencesHelper.get(key: ApiKeys.role) as String?;

                  if (role == ServiceRole.driver.name) {
                    driverTripCubit.stopDriverLocationTimer(driverId: userId!);
                  }

                  FcmNotifications.unsubscribeFromTopic('User_$userId');
                  FcmNotifications.unsubscribeFromTopic('All');

                  resetDataInSpecificRole(context);

                  await SharedPreferencesHelper.removeKeys(
                    keys: [ApiKeys.role, AppStrings.isSingedIn],
                  );

                  await SecureStorageHelper.clear();

                  router.go(AppRoutes.signInScreen);
                },
                text: "yes_logout".tr(context),
                height: 45,
                fontSize: 15,
              );
            },
          ),
        ),
      ],
    );
  }
}
