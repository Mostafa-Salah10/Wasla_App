import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/enums/social_enums.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/assets.dart';
import 'package:wasla/features/social_media/data/models/social_post_model.dart';
import 'package:wasla/features/social_media/presentation/manager/cubit/social_media_cubit.dart';
import 'package:wasla/features/social_media/presentation/widgets/comment_bottom_sheet.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({super.key, required this.post});
  final SocialPostModel post;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SocialMediaCubit>();
    return BlocBuilder<SocialMediaCubit, SocialMediaState>(
      buildWhen: (previous, current) =>
          current is ToggleReactionState ||
          current is DeleteCommentLoading ||
          current is DeleteCommentFailure ||
          current is GetCommentsLoading && post.postId == cubit.selectedPostId,
      builder: (context, state) {
        return Row(
          children: [
            InkWell(
              onTap: () async {
                cubit.toggleReaction(
                  reactionType: ReactionType.love,
                  targetType: TargetType.post,
                  item: post,
                );
              },
              child: Image.asset(
                post.isLoved
                    ? Assets.assetsImagesFavourite
                    : Assets.assetsImagesHeartOutline,
                height: 20,
                color: post.isLoved
                    ? AppColors.primaryColor
                    : context.isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                context.pushScreen(
                  AppRoutes.reactionsScreen,
                  arguments: post.postId,
                );
              },
              child: _buildTextNumber(context, num: post.numberOfReacts),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => CommentBottomSheet(postId: post.postId),
                );
              },
              child: Image.asset(
                Assets.assetsImagesComment,
                height: 20,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            _buildTextNumber(context, num: post.numberofComments),

            const Spacer(),
            InkWell(
              onTap: () {
                cubit.toggleReaction(
                  reactionType: ReactionType.save,
                  targetType: TargetType.post,
                  item: post,
                );
              },
              child: Image.asset(
                post.isSaved
                    ? Assets.assetsImagesSaveFilled
                    : Assets.assetsImagesSaveOutlined,
                height: 20,
                color: post.isSaved
                    ? AppColors.primaryColor
                    : context.isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            _buildTextNumber(context, num: post.numberOfSaves),
          ],
        );
      },
    );
  }

  Text _buildTextNumber(BuildContext context, {required int num}) {
    return Text(
      num.toString(),
      style: Theme.of(
        context,
      ).textTheme.labelSmall!.copyWith(color: Colors.grey),
    );
  }
}
