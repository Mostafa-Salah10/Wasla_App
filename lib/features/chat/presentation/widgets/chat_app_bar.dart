import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/format_date_from_string.dart';
import 'package:wasla/core/utils/app_strings.dart';
import 'package:wasla/core/widgets/custom_circle_network_image.dart';
import 'package:wasla/features/chat/presentation/manager/cubit/chat_cubit.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatCubit>();
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) => current is ChatGetUserInfo,
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (cubit.userInfo != null) {
              context.pushScreen(
                AppRoutes.chatUserProfileScreen,
                arguments: cubit.userInfo!,
              );
            }
          },
          child: AppBar(
            toolbarHeight: 75,
            titleSpacing: 0,
            // backgroundColor: !context.isDarkMode ? Colors.white : Colors.black,
            scrolledUnderElevation: 0,
            title: Row(
              spacing: 10,
              children: [
                CircleNeworkImage(
                  imageUrl: data[AppStrings.photo],
                  isLoading: false,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data[AppStrings.name]),

                    Visibility(
                      child: Text(
                        cubit.userInfo == null
                            ? ''
                            : cubit.userInfo!.isTypeing
                            ? 'typing'.tr(context)
                            : cubit.userInfo!.isOnline
                            ? 'online'.tr(context)
                            : '${'lastSeenAt'.tr(context)} ${formatDateToCustomString(cubit.userInfo!.lastSeen)}',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: context.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
