import 'package:flutter/material.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/utils/app_colors.dart';

class CartCategoryPill extends StatelessWidget {
  const CartCategoryPill({super.key, required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAvailable ? 'available'.tr(context) : 'unAvailable'.tr(context),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
