import 'package:flutter/material.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/assets.dart';

class ServiceItemDescription extends StatelessWidget {
  const ServiceItemDescription({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rating,
    this.isFavourite = false,
    this.showFavourite = true,
    this.onFavouritePressed,
  });

  final String title;
  final String subtitle;
  final double rating;
  final bool isFavourite;
  final bool showFavourite;
  final VoidCallback? onFavouritePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithFavouriteWidget(
          title: title,
          isFavourite: isFavourite,
          showFavourite: showFavourite,
          onFavouritePressed: onFavouritePressed,
        ),
        Divider(height: 20, color: AppColors.primaryColor, thickness: .1),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(color: AppColors.gray),
        ),
        const SizedBox(height: 10),
        ReviewPart(rating: rating),
      ],
    );
  }
}

class ReviewPart extends StatelessWidget {
  const ReviewPart({super.key, required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: AppColors.primaryColor, size: 18),
        const SizedBox(width: 6),
        Text(
          '${rating.toStringAsFixed(1)}  reviews',
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(color: AppColors.gray),
        ),
      ],
    );
  }
}

class TitleWithFavouriteWidget extends StatelessWidget {
  const TitleWithFavouriteWidget({
    super.key,
    required this.title,
    this.isFavourite = false,
    this.showFavourite = true,
    this.onFavouritePressed,
  });

  final String title;
  final bool isFavourite;
  final bool showFavourite;
  final VoidCallback? onFavouritePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (showFavourite) ...[
          const SizedBox(width: 10),
          InkWell(
            onTap: onFavouritePressed,
            child: Image.asset(
              isFavourite
                  ? Assets.assetsImagesFavourite
                  : Assets.assetsImagesHeartOutline,
              width: 20,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ],
    );
  }
}

class TitleWithWidget extends StatelessWidget {
  const TitleWithWidget({super.key, required this.title, required this.widget});

  final String title;

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        widget
      ],
    );
  }
}
