import 'package:flutter/material.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/features/resident_service/features/home/data/models/category_service_model.dart';

class CustomServiceCategoryItem extends StatelessWidget {
  const CustomServiceCategoryItem({super.key, required this.service});

  final CategoryServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: service.color.withOpacity(0.1),
          child: Image.asset(service.img, color: service.color, height: 23),
        ),
        Text(
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          service.name.tr(context),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
