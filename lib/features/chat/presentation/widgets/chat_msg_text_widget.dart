import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/functions/format_date_from_string.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/custom_directional_text_widet.dart';
import 'package:wasla/features/chat/data/models/chats_msg_model.dart';
import 'package:wasla/features/chat/presentation/manager/cubit/chat_cubit.dart';

class ChatMsgTextWiget extends StatelessWidget {
  const ChatMsgTextWiget({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.senderId == context.read<ChatCubit>().currentUser;
    return Row(
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
    );
  }
}
