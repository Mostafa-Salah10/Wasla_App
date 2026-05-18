import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/app_strings.dart';
import 'package:wasla/core/widgets/cached_network_image_widget.dart';
import 'package:wasla/core/widgets/edit_delete_bottom_sheet.dart';
import 'package:wasla/core/widgets/general_button.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restauarant_menu_item_model.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';

class RestaurantMenuItemCard extends StatelessWidget {
  final MenuItem item;
  final bool showOrderButton;
  final String? restaurantId;

  const RestaurantMenuItemCard({
    super.key,
    required this.item,
    this.showOrderButton = false,
    this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = item.discountPrice > 0;
    final cubit = context.read<ResidentMenuCubit>();

    return InkWell(
      onLongPress: () {
        if (!showOrderButton) {
          showModalBottomSheet(
            context: context,
            builder: (_) => DeleteUpdateBottomSheet(
              onEdit: () => context.pushScreen(
                AppRoutes.updateMenuItemScreen,
                arguments: {AppStrings.item: item, AppStrings.cubit: cubit},
              ),
              onDelete: () => cubit.deleteMenu(menuId: item.id),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.shade200,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode
                  ? Colors.black
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomCachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(
                      label: item.isAvailable
                          ? 'available'.tr(context)
                          : 'unAvailable'.tr(context),
                      color: item.isAvailable
                          ? const Color(0xFF1D9E75)
                          : const Color(0xFFD85A30),
                      bgColor: item.isAvailable
                          ? const Color(0xFFE1F5EE)
                          : const Color(0xFFFAECE7),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.preparationTime} ${'min'.tr(context)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            hasDiscount
                                ? '${(item.price - item.discountPrice).toStringAsFixed(0)} ${'egb'.tr(context)}'
                                : '${item.price.toStringAsFixed(0)} ${'egb'.tr(context)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1),
                          child: Text(
                            '${item.price.toStringAsFixed(0)} ${'egb'.tr(context)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            if (showOrderButton)
              BlocConsumer<ResidentMenuCubit, ResidentMenuState>(
                buildWhen: (previous, current) =>
                    current is MenuCart && current.menuId == item.id,
                listenWhen: (previous, current) =>
                    current is MenuCart && current.menuId == item.id,

                listener: (context, state) {
                  if (state is AddMenuToCartFailureState) {
                    showToast(state.errMsg, color: Colors.red);
                  } else if (state is AddMenuToCartSuccessState) {
                    showToast(
                      'menuAddedToCart'.tr(context),
                      color: AppColors.green,
                    );
                  }
                },
                builder: (context, state) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: GeneralButton(
                      fontSize: 13,
                      height: 25,
                      text: state is AddMenuToCartLaodingState
                          ? 'loading'.tr(context)
                          : 'orderNow'.tr(context),
                      onPressed: () {
                        if (state is! AddMenuToCartLaodingState) {
                          context.read<ResidentMenuCubit>().addMenuItemToCart(
                            menuId: item.id,
                            restaurantId: restaurantId!,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const _Badge({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
