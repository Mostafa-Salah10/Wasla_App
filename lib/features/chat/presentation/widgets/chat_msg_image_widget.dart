import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/functions/format_date_from_string.dart';
import 'package:wasla/core/responsive/size_config.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/cached_network_image_widget.dart';
import 'package:wasla/core/widgets/custom_directional_text_widet.dart';
import 'package:wasla/features/chat/data/models/chats_msg_model.dart';
import 'package:wasla/features/chat/presentation/manager/cubit/chat_cubit.dart';

class ChatMsgImageWidget extends StatelessWidget {
  const ChatMsgImageWidget({
    super.key,
    required this.message,
    required this.withText,
  });
  final MessageModel message;
  final bool withText;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.senderId == context.read<ChatCubit>().currentUser;
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          height: 81,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: message.files.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        width: double.infinity,
                        height: SizeConfig.screenHeight / 2,
                        padding: EdgeInsets.all(10),
                        child: CustomCachedNetworkImage(
                          imageUrl: message.files[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  child: CustomCachedNetworkImage(
                    width: 80,
                    height: 80,
                    imageUrl: message.files[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),

        Visibility(
          visible: withText,
          child: Row(
            children: [
              Expanded(
                child: CustomTextWidget(
                  text: message.messageText ?? '',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: isMe ? AppColors.whiteColor : AppColors.blackColor,
                  ),
                ),
              ),

              const SizedBox(width: 10),
              Text(
                formatDateToCustomString(message.sentAt),
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: isMe ? AppColors.whiteColor : AppColors.blackColor,
                ),
              ),
              const SizedBox(width: 5),

              Visibility(
                visible: isMe,
                child: Icon(
                  Icons.done_all_sharp,
                  color: message.readAt != null
                      ? AppColors.seenColor
                      : AppColors.whiteColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: !withText,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  formatDateToCustomString(message.sentAt),
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: isMe ? AppColors.whiteColor : AppColors.blackColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Visibility(
              visible: isMe && !withText,
              child: Icon(
                Icons.done_all_sharp,
                color: message.readAt != null
                    ? AppColors.seenColor
                    : AppColors.whiteColor,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
