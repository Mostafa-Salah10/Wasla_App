import 'package:flutter/material.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/utils/app_sizes.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/widgets/choose_driver/choose_driver_body.dart';

class ChooseDriverView extends StatelessWidget {
  const ChooseDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('selectDriver'.tr(context))),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.marginDefault,
          vertical: AppSizes.paddingSizeSmall,
        ),
        child: ChooseDriverBody(),
      ),
    );
  }
}
