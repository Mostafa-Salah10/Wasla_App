import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/enums/msg_type_enum.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/service/signalR/chat_hub.dart';
import 'package:wasla/features/chat/data/models/all_users_chat_model.dart';
import 'package:wasla/features/chat/data/models/chat_user_info.dart';
import 'package:wasla/features/chat/data/models/chats_msg_model.dart';
import 'package:wasla/features/chat/data/models/real_time_msg_model.dart';
import 'package:wasla/features/chat/data/models/users_chat_msg_model.dart';
import 'package:wasla/features/chat/data/repo/chat_repo.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  ChatCubit(this.chatRepo) : super(ChatInitial());

  bool isSend = false;

  final TextEditingController messageController = TextEditingController();
  final TextEditingController messageUpdateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  int allUsersPageNumber = 1;
  int allUsersPageSize = 10;
  bool allUserEndOfPagination = false;
  int allChatsOfUserPageNumber = 1;
  int allChatsOfUserPageSize = 10;
  bool allChatsOfUserEndOfPagination = false;
  String currentUser = '';
  String currentResceiver = '';
  int chatPageNumber = 1;
  int chatPageSize = 10;
  bool chatEndOfPagination = false;
  int selectedMsgId = -1;
  String currentChatId = '';
  File? audio;
  List<File> images = [];
  ChatUserInfo? userInfo;
  List<UsersChatMsgModel> allChatsOfUser = [];
  List<AllUsersChatModel> allUsers = [];
  List<MessageModel> messages = [];
  bool isRecording = false;
  double targetOffsetDx = 0.0;
  Timer? _searchTimer;
  bool isEdit = false;

  ChatHub? chatHub;

  Timer? typingTimer;

  bool userIsTyping = false;
  final FocusNode msgFocusNode = FocusNode();
  MessageModel? editedMsg;
  void onRetry() {
    emit(ChatOnRetryState());
  }

  void updateTargetOffest({required double dx}) {
    targetOffsetDx = dx.abs().clamp(0, 100);
    emit(ChatRecordChangePosition());
  }

  void changeRecordingState({required bool isRecording}) async {
    this.isRecording = isRecording;
    emit(ChatRecorded());
  }

  void pickImages({required List<File> files}) {
    images.addAll(files);
    isSend = true;

    emit(ChatPickImages());
  }

  void removeImage({required File file}) {
    images.remove(file);
    if (images.isEmpty && messageController.text.isEmpty) {
      isSend = false;
    } else {
      isSend = true;
    }
    emit(ChatPickImages());
  }

  void getCurrentUser() async {
    final String? user = await getUserId();
    currentUser = user!;
  }

  void whenUserTyping() async {
    if (messageController.text.characters.isEmpty && images.isEmpty) {
      isSend = false;
      emit(ChatWhenUserTyping());
    } else if (messageController.text.characters.length == 1) {
      isSend = true;
      emit(ChatWhenUserTyping());
    } else if (messageController.text.characters.isEmpty && images.isNotEmpty) {
      isSend = true;
      emit(ChatWhenUserTyping());
    }

    final String receiverId = currentResceiver;

    if (userIsTyping == false) {
      ////start typing
      userIsTyping = true;
      chatHub = ChatHub();
      await chatHub!.init();
      chatHub!.sendTyping(receiverId);
    }
    if (typingTimer?.isActive ?? false) {
      typingTimer?.cancel();
    }
    typingTimer = Timer(const Duration(seconds: 1), () async {
      userIsTyping = false;

      ///stop typing
      await chatHub!.stopTyping(receiverId);
      chatHub!.disconnect();
    });
  }

  void whenUserUpdate({required MessageModel message}) {
    messageController.text = message.messageText ?? '';
    msgFocusNode.requestFocus();
    isEdit = true;
    editedMsg = message;
    emit(ChatWhenUserTyping());
    isSend = true;
  }

  void whenUserCloseUpating() {
    isSend = false;
    isEdit = false;
    editedMsg = null;
    messageController.text = '';
    msgFocusNode.unfocus();
    emit(ChatWhenUserTyping());
  }

  //Done
  Future<void> getAllUsers({required bool fromPagination}) async {
    if (allUserEndOfPagination ||
        fromPagination && state is ChatGetAllUsersLoadigFromPagination) {
      return;
    }

    if (fromPagination) {
      emit(ChatGetAllUsersLoadigFromPagination());
    } else {
      emit(ChatGetAllUsersLoadig());
    }

    final result = await chatRepo.getAllUsers(
      pageNumber: allUsersPageNumber,
      pageSize: allUsersPageSize,
    );
    result.fold(
      (error) {
        if (error is NoInternetFailure) {
          emit(ChatNetworkState());
        } else {
          emit(ChatFailureState());
        }
      },
      (users) {
        if (users.isEmpty) {
          allUserEndOfPagination = true;
          emit(ChatGetAllUsersSuccess(allUsers: allUsers));
        } else {
          allUsersPageNumber++;
          allUsers.addAll(users);
          emit(ChatGetAllUsersSuccess(allUsers: allUsers));
        }
      },
    );
  }

  //Done
  Future<void> getAllChatsOfUser({required bool fromPagination}) async {
    if (allChatsOfUserEndOfPagination ||
        fromPagination && state is ChatGetChatsOfUserLoadigFromPagination) {
      return;
    }

    if (fromPagination) {
      emit(ChatGetChatsOfUserLoadigFromPagination());
    } else {
      emit(ChatGetAllChatsOfUserLoadig());
    }

    final String? userId = await getUserId();

    final result = await chatRepo.getUsersThatHaveChatWithTheme(
      pageNumber: allChatsOfUserPageNumber,
      pageSize: allChatsOfUserPageSize,
      userId: userId!,
    );
    result.fold(
      (error) {
        if (error is NoInternetFailure) {
          emit(ChatNetworkState());
        } else {
          emit(ChatFailureState());
        }
      },
      (chats) {
        if (chats.isEmpty) {
          allChatsOfUserEndOfPagination = true;
          emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
        } else {
          allChatsOfUserPageNumber++;
          allChatsOfUser.addAll(chats);
          emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
        }
      },
    );
  }

  //Done
  Future<void> getChat({
    required bool fromPagination,
    required String recieverId,
  }) async {
    if (chatEndOfPagination ||
        fromPagination && state is ChatGetCahtLoadigFromPagination) {
      return;
    }

    if (fromPagination) {
      emit(ChatGetCahtLoadigFromPagination());
    } else {
      emit(ChatGetCahtOfUserLoadig());
    }

    final String? userId = await getUserId();
    final result = await chatRepo.getUserChat(
      pageNumber: chatPageNumber,
      pageSize: chatPageSize,
      senderId: userId!,
      receiverId: recieverId,
    );

    result.fold(
      (error) {
        emit(ChatGetCahtFailure(errorMessage: error));
      },
      (success) {
        currentChatId = success.chatId.toString();
        if (success.messages.data.isEmpty) {
          chatEndOfPagination = true;

          emit(ChatGetCahtOfUserSuccess(messages: messages));
        } else {
          chatPageNumber++;
          messages.addAll(success.messages.data);

          emit(ChatGetCahtOfUserSuccess(messages: messages));
        }
      },
    );
  }

  //Done
  Future<void> deleteMsg({required MessageModel msg}) async {
    MessageModel message = msg;
    int index = messages.indexOf(message);
    messages.remove(message);
    emit(ChatDeleteMsg());

    final result = await chatRepo.deleteMsg(
      messageId: message.messageId,
      senderId: message.senderId,
    );

    result.fold((err) {
      if (index != -1) {
        messages.insert(index, message);
        emit(ChatDeleteMsg());
      }
    }, (success) {});
  }

  //Done
  Future<void> updateMsg({required MessageModel msg}) async {
    MessageModel message = msg;
    final String oldText = message.messageText ?? '';
    message.messageText = messageController.text;
    emit(ChatUpdateMsg(msgId: message.messageId));

    final result = await chatRepo.updateMsg(
      messageId: message.messageId,
      senderId: message.senderId,
      existFiles: message.files,
      messageText: messageController.text,
      type: 1,
    );

    result.fold(
      (err) {
        message.messageText = oldText;
        emit(ChatUpdateMsg(msgId: message.messageId));
      },
      (success) {
        isEdit = false;
        resetMsg();
        emit(ChatWhenUserTyping());
      },
    );
  }

  //Done
  Future<void> deleteChat({required UsersChatMsgModel user}) async {
    UsersChatMsgModel oldUser = user;
    int index = allChatsOfUser.indexOf(user);
    allChatsOfUser.remove(user);
    emit(ChatDeleteChat());

    final result = await chatRepo.deleteChat(
      chatId: user.chatId,
      userId: currentUser,
    );

    result.fold((err) {
      if (index != -1) {
        allChatsOfUser.insert(index, oldUser);
        emit(ChatDeleteChat());
      }
    }, (success) {});
  }

  //Done
  Future<void> getUserInfo({required String id}) async {
    final result = await chatRepo.getChatUserInfo(userId: id);
    result.fold((err) {}, (success) {
      userInfo = success;
      emit(ChatGetUserInfo());
    });
  }

  //Done
  Future<void> readMsgs({required String chatId}) async {
    final result = await chatRepo.readMsgs(chatId: chatId);
    result.fold((err) {}, (success) {
      for (var user in allChatsOfUser) {
        if (user.chatId.toString() == chatId) {
          user.unreadMessageCount = 0;
          selectedMsgId = user.messageId;
          emit(ChatReadMsgs());
        }
      }
    });
  }

  Future<void> sendMsg({required int type}) async {
    final MessageType msgType = MessageType.values[type];
    switch (msgType) {
      case MessageType.text:
        log('Send Ya Disha');
        await chatRepo.sendMsg(
          receiverId: userInfo!.id,
          type: type + 1,
          senderId: currentUser,
          messageText: messageController.text,
        );
        resetMsg();
        emit(ChatPickImages());
        return;
      case MessageType.image:
        List<File> files = images;
        images = [];
        isSend = false;
        emit(ChatPickImages());
        await chatRepo.sendMsg(
          receiverId: userInfo!.id,
          type: type + 1,
          senderId: currentUser,
          images: files,
        );

        return;
      case MessageType.audio:
        await chatRepo.sendMsg(
          receiverId: userInfo!.id,
          type: type + 1,
          senderId: currentUser,
          audio: audio,
        );
        resetMsg();
        return;

      case MessageType.mixed:
        List<File> files = images;
        images = [];
        String val = messageController.text;
        messageController.clear();
        isSend = false;
        emit(ChatPickImages());
        await chatRepo.sendMsg(
          receiverId: userInfo!.id,
          type: type + 1,
          senderId: currentUser,
          images: files,
          messageText: val,
        );
        return;
    }
  }

  resetMsg() {
    messageController.clear();
    images = [];
    audio = null;
    isSend = false;
  }

  ///Done
  handleOnlineStatus({required bool status, required String id}) async {
    if (currentUser != id && userInfo != null) {
      if (status) {
        //online
        if (id == userInfo!.id) {
          userInfo!.isOnline = true;
          emit(ChatGetUserInfo());
        }
      } else {
        //offline
        if (id == userInfo!.id) {
          userInfo!.isOnline = false;
          userInfo!.lastSeen = DateTime.now();
          emit(ChatGetUserInfo());
        }
      }
    }
  }

  handleMessagesWhenReadIt({
    required int chatId,
    required String readerId,
    required List<int> readedMessages,
  }) {
    if (chatId.toString() == currentChatId) {
      for (var msg in messages) {
        if (readedMessages.contains(msg.messageId)) {
          msg.readAt = DateTime.now();
        }
      }
      emit(ChatReadMsgs());
    }

    ///update reading if this msg is last

    for (var user in allChatsOfUser) {
      if (user.senderId == currentUser &&
          readedMessages.contains(user.messageId)) {
        user.readAt = DateTime.now();
        selectedMsgId = user.messageId;
        emit(ChatReadMsgs());
      }
    }
  }

  //Done
  handleDeleteMsg({required int msgId}) {
    for (var msg in messages) {
      if (msg.messageId == msgId && msg.senderId != currentUser) {
        messages.remove(msg);
        emit(ChatDeleteMsg());
      }

      ///todo: check if this is last msg or no
      for (var user in allChatsOfUser) {
        if (user.messageId == msgId) {
          if (user.senderId == currentUser) {
            user.messageText = ' You Delete This Message';
          } else {
            user.messageText = '${user.name} Delete This Message';
          }
          selectedMsgId = user.messageId;
          emit(ChatDeleteMsg());
        }
      }
    }
  }

  //Done
  handleWhenNewMsg({required RealTimeMsgModel user}) {
    ///when bug more than one hub are work at the same time
    bool isDuplicate = messages.any((msg) => msg.messageId == user.id);
    if (isDuplicate) return;

    //when i in chat and there exist messages with this chat
    if (user.chatId.toString() == currentChatId.toString()) {
      messages.insert(0, _getNewMsg(user));
      readMsgs(chatId: currentChatId);
      emit(ChatGetCahtOfUserSuccess(messages: messages));
    }
    //when the new chat and i start it
    else if (currentResceiver == user.receiverId &&
        user.senderId == currentUser) {
      currentChatId = user.chatId.toString();
      messages.insert(0, _getNewMsg(user));
      readMsgs(chatId: currentChatId);
      emit(ChatGetCahtOfUserSuccess(messages: messages));
    }
    ///when i in the chat and new user start it
    else if (user.senderId == currentResceiver &&
        user.receiverId == currentUser) {
      messages.insert(0, _getNewMsg(user));
      //me in chat
      if (currentResceiver.isNotEmpty) {
        currentChatId = user.chatId.toString();
        readMsgs(chatId: currentChatId);
      }
      emit(ChatGetCahtOfUserSuccess(messages: messages));
    }

    //when chat exist in the current list
    for (var chat in allChatsOfUser) {
      if (chat.chatId == user.chatId) {
        int numOfUnreadMsgs = chat.unreadMessageCount + 1;
        allChatsOfUser.remove(chat);
        allChatsOfUser.insert(
          0,
          UsersChatMsgModel.fromMap(
            user,
            numOfUnreadMsgs,
            currentUser == user.senderId,
          ),
        );
        emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
        return;
      }
    }
    // new chat
    allChatsOfUser.insert(
      0,
      UsersChatMsgModel.fromMap(user, 1, currentUser == user.senderId),
    );

    emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
  }

  MessageModel _getNewMsg(RealTimeMsgModel user) {
    return MessageModel(
      messageText: user.messageText,
      receiverId: user.receiverId,
      senderId: user.senderId,
      audio: user.audio,
      messageId: user.id,
      isMine: user.isMine,
      type: user.type,
      sentAt: user.sentAt,
      readAt: user.readAt,
      isEdited: user.isEdited,
      files: user.files,
    );
  }

  //Done
  handleWhenUpdateMsg({
    required String msg,
    required int msgId,
    required String senderId,
    required String chatId,
  }) {
    if (chatId == currentChatId.toString()) {
      for (var message in messages) {
        if (message.messageId == msgId && message.senderId != currentUser) {
          message.messageText = msg;
          emit(ChatUpdateMsg(msgId: msgId));
        }
      }
    }

    ///when this msg is last msg:
    for (var chat in allChatsOfUser) {
      if (chat.messageId == msgId) {
        chat.messageText = msg;
        selectedMsgId = msgId;
        emit(ChatUpdateMsg(msgId: msgId));
      }
    }
  }

  handleWhenAnotherUserIstypeTypingOrStopTyping({
    required String userId,
    required bool isTyping,
  }) {
    ///outside the chat
    for (var chat in allChatsOfUser) {
      if (chat.senderId == userId) {
        if (isTyping) {
          chat.isTyping = true;
        } else {
          chat.isTyping = false;
        }
        emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
      }
    }

    if (currentResceiver == userId) {
      if (isTyping) {
        userInfo!.isTypeing = true;
      } else {
        userInfo!.isTypeing = false;
      }
      emit(ChatGetUserInfo());
    }
  }

  ////Searching
  Future<void> searchForAllUsers({required String query}) async {
    if (_searchTimer == null || _searchTimer!.isActive) {
      _searchTimer?.cancel();
    }

    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        emit(ChatGetAllUsersSuccess(allUsers: allUsers));
      } else {
        final result = await chatRepo.searchForUsers(word: query);

        result.fold((err) {
          emit(ChatGetAllUsersSuccess(allUsers: allUsers));
        }, (users) => emit(ChatGetAllUsersSuccess(allUsers: users)));
      }
    });
  }

  Future<void> searchForUsersThatHaveChatWithTheme({
    required String query,
  }) async {
    if (_searchTimer == null || _searchTimer!.isActive) {
      _searchTimer?.cancel();
    }

    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
      } else {
        final result = await chatRepo.searchForUsersThatHaveChatWithTheme(
          word: query,
          id: currentUser,
        );

        result.fold(
          (err) {
            emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
          },
          (chats) {
            emit(ChatGetChatsOfUserSuccess(allChats: chats));
          },
        );
      }
    });
  }

  void whenAllUsersSearchCancelled() {
    emit(ChatGetAllUsersSuccess(allUsers: allUsers));
  }

  void whenUserChatsSearchCancelled() {
    emit(ChatGetChatsOfUserSuccess(allChats: allChatsOfUser));
  }

  ////Searching
}
