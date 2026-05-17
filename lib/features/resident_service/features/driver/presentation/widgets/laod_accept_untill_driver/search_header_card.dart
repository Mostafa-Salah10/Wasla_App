import 'package:flutter/material.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'dots_loader_widget.dart';
import 'pulse_section_widget.dart';

class SearchHeaderCard extends StatelessWidget {
  const SearchHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 28,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const PulseSection(),

            const SizedBox(height: 20),

            Text(
              'waitingDriver'.tr(context),
              style: Theme.of(context).textTheme.displayMedium,
            ),

            const SizedBox(height: 18),

            const DotsLoader(),

            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.purple],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'searchNearbyDriver'.tr(context),
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
