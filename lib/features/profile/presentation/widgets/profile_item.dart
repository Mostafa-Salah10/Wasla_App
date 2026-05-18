import 'package:flutter/material.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/features/profile/data/models/profile_item_model.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({super.key, required this.profileItemModel, this.trailing});
  final ProfileItemModel profileItemModel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            profileItemModel.image,
            height: 22,
            width: 22,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 16),
          Text(
            profileItemModel.title.tr(context),
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          trailing ??
              Icon(
                Icons.arrow_forward_ios,
                color: context.isDarkMode ? Colors.white : Colors.black,
                size: 16,
              ),
        ],
      ),
    );
  }
}

class CustomSwitchButtonWithTitle extends StatelessWidget {
  const CustomSwitchButtonWithTitle({
    super.key,
    required this.title,
    required this.trailing,
  });
  final Widget trailing;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        trailing,
      ],
    );
  }
}
