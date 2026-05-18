import 'package:flutter/material.dart';
import 'package:wasla/core/utils/app_sizes.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/widgets/menu/menu_category.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/widgets/menu/restaurant_menu_category_list.dart';
import 'package:wasla/features/restaurant/menu/presentation/widgets/restauant_status_widget.dart';

class MenuBody extends StatelessWidget {
  const MenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.marginDefault),
      child: Column(
        children: [
          SizedBox(height: AppSizes.paddingSizeSmall),
          const ResidnetRestaurantMenuCategory(),
          SizedBox(height: AppSizes.paddingSizeDefault),
          const RestauantStatusWidget(),
          SizedBox(height: AppSizes.paddingSizeDefault),
          Expanded(child: RestaurantMenuCatgoryList(showOrderButton: false)),
          SizedBox(height: AppSizes.paddingSizeDefault),
        ],
      ),
    );
  }
}
