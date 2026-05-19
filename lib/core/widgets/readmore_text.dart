import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/responsive/responsive_font_size.dart';
import 'package:wasla/core/utils/app_colors.dart';

class ReadmoreText extends StatelessWidget {
  final String text;
  final int? maxLines;

  const ReadmoreText({super.key, required this.text, this.maxLines});

  TextDirection _getDirection(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _getDirection(text),
      child: ReadMoreText(
        text,
        trimLines: maxLines ?? 2,
        trimMode: TrimMode.Line,

        trimCollapsedText: "viewMore".tr(context),
        trimExpandedText: "showLess".tr(context),

        moreStyle: TextStyle(color: AppColors.primaryColor),

        lessStyle: TextStyle(color: AppColors.primaryColor),

        style: TextStyle(
          color: AppColors.gray,
          fontSize: getResponsiveFontSize(context, fontSize: 16),
        ),
      ),
    );
  }
}
