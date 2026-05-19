import 'package:flutter/material.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/cached_network_image_widget.dart';
import 'package:wasla/features/gym/features/packages/data/models/gym_package_model.dart';
import 'package:wasla/features/resident_service/features/booking/presentation/widgets/gym_package_item_content.dart';

class GymPackageItem extends StatelessWidget {
  const GymPackageItem({super.key, required this.model, this.withBookingButton});
  final GymPackageModel model;
  final bool ?withBookingButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.black : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(child: CustomCachedNetworkImage(imageUrl: model.photoUrl)),
              Expanded(
                flex: 2,
                child: Transform.translate(
                  offset: Offset(0, -10),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomCachedNetworkImage(
                      imageUrl: model.photoUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PackageItemContent(
                    withBookingButton: withBookingButton,
                    model: model),
                ),
              ),
            ],
          ),

          model.precentage == 0
              ? const SizedBox()
              : Container(
                  width: 40,
                  height: 35,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),

                  child: Center(
                    child: Text(
                      "${model.precentage}%",
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
