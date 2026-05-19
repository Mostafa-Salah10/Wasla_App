import 'package:flutter/material.dart';
import 'package:wasla/core/enums/payment_method.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/responsive/size_config.dart';
import 'package:wasla/core/utils/app_colors.dart';

class CustomCreditCard extends StatelessWidget {
  final PaymentMethod groupValue;
  final PaymentMethod value;
  final String image;
  final String label;

  final void Function(PaymentMethod?)? onChanged;
  const CustomCreditCard({
    super.key,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      height: SizeConfig.blockHeight * 10,
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 236, 234, 234),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(width: 0.1),
      ),
      child: Row(
        children: [
          Container(
            height: SizeConfig.blockHeight * 10,
            width: SizeConfig.blockWidth * 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(image),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),

          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
