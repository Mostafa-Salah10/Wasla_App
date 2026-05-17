import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/service/signalR/chat_hub.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/app_strings.dart';
import 'package:wasla/core/utils/assets.dart';
import 'package:wasla/core/widgets/custom_circle_with_data_list.dart';
import 'package:wasla/core/widgets/custom_details_card_widget.dart';
import 'package:wasla/core/widgets/readmore_text.dart';
import 'package:wasla/features/resident_service/features/doctor/presentation/widgets/doctor_details/custom_text_identfier_widget.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/widgets/restuarant%20details/residetn_rest_details_card_widget.dart';
import 'package:wasla/features/restaurant/home/data/models/restaurant_model.dart';
import 'package:wasla/features/reviews/presentation/widgets/add_review_widget.dart';
import 'package:wasla/features/reviews/presentation/widgets/custom_reviws_list.dart';

class ResidentRestaurantDetailsWidget extends StatelessWidget {
  const ResidentRestaurantDetailsWidget({
    super.key,
    required this.restaurant,
    required this.restaurantId,
  });
  final RestaurantModel restaurant;
  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
      children: [
        CustomDoctorDatailsCardWeiget(
          withHero: false,
          imageUrl: restaurant.gallery.first,
          child: ResidetnRestDetailsCardWidget(restaurant: restaurant),
        ),
        const SizedBox(height: 18),
        CustomCircleWithDataList(
          items: _getItemList(context),
          onTap: () async {
            final chatHub = ChatHub();
            chatHub.init();
            await context.push(
              AppRoutes.chatScreen,
              extra: {
                AppStrings.id: restaurant.id,
                AppStrings.name: restaurant.name,
                AppStrings.photo: restaurant.gallery.first,
              },
            );
            chatHub.disconnect();
          },
        ),
        const SizedBox(height: 18),
        TextDetailsIdentfierWidget(
          bigFont: true,
          leading: "aboutRestaurant".tr(context),
          trailing: "menu".tr(context),
          onTap: () {
            if (restaurant.isAvailable) {
              context.pushScreen(
                AppRoutes.residentRestaurantMenuScreen,
                arguments: restaurantId,
              );
            } else {
              toastAlert(msg: 'notAvailable'.tr(context), color: AppColors.red);
            }
          },
        ),

        const SizedBox(height: 10),
        ReadmoreText(maxLines: 2, text: restaurant.description),
        const SizedBox(height: 15),
        TextDetailsIdentfierWidget(
          bigFont: true,
          leading: "reservation".tr(context),
          trailing: "bookNow".tr(context),
          onTap: () {
            context.pushScreen(
              AppRoutes.residentRestaurantReservationScreen,
              arguments: restaurantId,
            );
          },
        ),
        const SizedBox(height: 10),
        TextDetailsIdentfierWidget(
          leading: "reviwes".tr(context),
          trailing: "seeAll".tr(context),
          onTap: () {
            context.pushScreen(AppRoutes.reviewScreen);
          },
        ),
        const SizedBox(height: 15),

        CustomAddReviweWidget(serviceProviderId: restaurantId),
        const SizedBox(height: 15),
        ReviewsList(length: 7, withShrinkWrap: true),
      ],
    );
  }

  List<CircleStatModel> _getItemList(BuildContext context) {
    return [
      CircleStatModel(
        icon: Assets.assetsImagesGroup,
        title: "resident".tr(context).toLowerCase(),
        value: "${restaurant.numberOfCompletedOrders}+",
      ),

      CircleStatModel(
        icon: Assets.assetsImagesHalfStar,
        title: "rating".tr(context).toLowerCase(),
        value: "4.7",
      ),
      CircleStatModel(
        icon: Assets.assetsImagesChatFilled,
        title: "message".tr(context).toLowerCase(),
        value: "chat",
      ),
    ];
  }
}
