import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/chat/data/models/real_time_msg_model.dart';
import 'package:wasla/features/chat/presentation/manager/cubit/chat_cubit.dart';
import '../../database/cache/secure_storage_helper.dart';

class ChatHub {
  late HubConnection hubConnection;

  Future<void> init() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://waslammka.runasp.net/chatHub',
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              final token = await SecureStorageHelper.get(key: ApiKeys.token);
              return token ?? '';
            },
          ),
        )
        .withAutomaticReconnect()
        .build();

    addListeners();

    try {
      await hubConnection.start();
    } catch (e) {
      // toastAlert(color: AppColors.red, msg: e.toString());
      log('Disha SignalR Connection Error: ${e.toString()}');
    }
  }

  void addListeners() {
    final chat = navigatorKey.currentContext!.read<ChatCubit>();

    //Done
    hubConnection.on("UserOnline", (data) {
      final user = data![0] as Map;
      final userId = user['userId'];
      chat.handleOnlineStatus(status: true, id: userId);
    });

    //Done
    hubConnection.on("UserOffline", (data) {
      final user = data![0] as Map;
      final userId = user['userId'];

      // final lastSeen = user['lastSeen'];
      chat.handleOnlineStatus(status: false, id: userId);
    });
    //Done
    hubConnection.on("MessagesRead", (data) {
      final info = data![0] as Map;

      final chatId = info['chatId'];
      final readerId = info['readerId'];
      final messageIds = (info['messageIds'] as List).cast<int>();

      chat.handleMessagesWhenReadIt(
        chatId: chatId,
        readerId: readerId,
        readedMessages: messageIds,
      );
    });

    //Done
    hubConnection.on("MessageDeleted", (data) {
      final dynamic messageId = data![0];

      chat.handleDeleteMsg(msgId: messageId);
    });
    //Done
    hubConnection.on("ReceiveMessage", (data) {
      final message = data![0] as Map<String, dynamic>;
      log("Disha new message");
      // log(message.toString());

      chat.handleWhenNewMsg(user: RealTimeMsgModel.fromJson(message));
    });

    //Done
    hubConnection.on("MessageUpdated", (data) {
      final message = data![0] as Map<String, dynamic>;

      final messageId = message['id'];

      final messageText = message['messageText'];

      final senderId = message['senderId'];

      final chatId = message['chatId'];

      chat.handleWhenUpdateMsg(
        msgId: messageId,
        msg: messageText,
        senderId: senderId,
        chatId: chatId.toString(),
      );
    });

    /// 🔄 Chat Updated (unread count)
    hubConnection.on("ChatUpdated", (data) {
      final info = data![0] as Map;

      final chatId = info['chatId'];
    });

    // Typing
    hubConnection.on("UserTyping", (data) {
      final map = data![0] as Map;
      final senderId = map['senderId'];
      chat.handleWhenAnotherUserIstypeTypingOrStopTyping(
        userId: senderId,
        isTyping: true,
      );
    });

    //Stop Typing by user
    hubConnection.on("UserStopTyping", (data) {
      final map = data![0] as Map;
      final senderId = map['senderId'];
      chat.handleWhenAnotherUserIstypeTypingOrStopTyping(
        userId: senderId,
        isTyping: false,
      );
    });
  }

  //  Send typing
  Future<void> sendTyping(String receiverId) async {
    try {
      await hubConnection.invoke("Typing", args: [receiverId]);
    } on Exception catch (e) {
      log('Disha Typing..... Error ${e.toString()}');
    }
  }

  ///  send Stop typing
  Future<void> stopTyping(String receiverId) async {
    try {
      await hubConnection.invoke("StopTyping", args: [receiverId]);
    } on Exception catch (e) {
      log('Disha Stop Typing..... Error ${e.toString()}');
    }
  }

  Future<void> disconnect() async {
    await hubConnection.stop();
  }
}
