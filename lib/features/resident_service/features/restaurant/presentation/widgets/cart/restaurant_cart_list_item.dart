import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/custom_image_with_stack.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restaurant_cart_model.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/manager/cubit/cart/restaurant_cart_cubit.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/widgets/cart/cart_category_pill.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/widgets/cart/cart_quantity_stepper.dart';

class RestaurantCartListItem extends StatelessWidget {
  const RestaurantCartListItem({super.key, required this.item});

  final RestaurantCartModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            BuildImageWithStackWidget(imageUrl: item.imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CartCategoryPill(isAvailable: item.isAvailable),
                  const SizedBox(height: 4),
                  Text(
                    item.menuItemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  BlocBuilder<RestaurantCartCubit, RestaurantCartState>(
                    buildWhen: (previous, current) =>
                        current is RestaurantCartUpadteQuantityState &&
                        current.itemId == item.cartItemId,
                    builder: (context, state) {
                      return Text(
                        '${item.totalPrice.toStringAsFixed(0)} ${'egb'.tr(context)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _DeleteButton(item),
                const SizedBox(height: 13),
                CartQuantityStepper(item: item),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton(this.cartModel);
  final RestaurantCartModel cartModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<RestaurantCartCubit>().removeItemFromCart(cartModel);
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE24B4A).withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 18,
          color: Color(0xFFE24B4A),
        ),
      ),
    );
  }
}
