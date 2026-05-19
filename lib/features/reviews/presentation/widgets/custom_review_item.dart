import 'package:flutter/material.dart';
import 'package:wasla/core/functions/format_date_from_string.dart';
import 'package:wasla/core/widgets/custom_directional_text_widet.dart';
import 'package:wasla/features/reviews/data/models/review_model.dart';
import 'package:wasla/core/widgets/cached_network_image_widget.dart';
import 'package:wasla/core/widgets/readmore_text.dart';
import 'package:wasla/features/reviews/presentation/widgets/custom_rating_widget.dart';
import 'package:wasla/features/reviews/presentation/widgets/build__more_comment_widget.dart';

class CustomReviewItem extends StatelessWidget {
  const CustomReviewItem({super.key, required this.reviewModel});
  final ReviewModel reviewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          children: [
            _leading(),
            const SizedBox(width: 10),
            Expanded(child: _title(context)),
            CustomRatingWidget(
              rating: reviewModel.rating.toString(),
              isSelected: false,
            ),
            const SizedBox(width: 10),
            BuildMoreCommentWidget(reviewModel: reviewModel),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ReadmoreText(maxLines: 2, text: reviewModel.comment),
        ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        CustomTextWidget(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: reviewModel.reviewerName,
          style: Theme.of(
            context,
          ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          formatDateToCustomString(reviewModel.createdAt),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  ClipOval _leading() {
    return ClipOval(
      child: CustomCachedNetworkImage(
        imageUrl: reviewModel.userImageUrl,
        height: 44,
        width: 44,
      ),
    );
  }
}
