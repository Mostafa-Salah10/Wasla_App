import 'package:flutter/material.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/utils/assets.dart';
import 'package:wasla/core/responsive/size_config.dart';

class CustomNotFoundWidget extends StatelessWidget {
  const CustomNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(Assets.assetsImagesNoFound, width: 300, height: 300),
          Text(
            "notFound".tr(context),
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontSize: SizeConfig.textSize * 3,
            ),
          ),
          SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
            "sorrySearch".tr(context),
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(fontSize: SizeConfig.textSize * 2),
          ),
        ],
      ),
    );
  }
}
