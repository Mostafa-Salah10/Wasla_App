import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wasla/core/connection/network_info.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/core/database/api/api_end_points.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/api/errors/api_exceptions.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/convert_image_to_json.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/chat/data/models/all_users_chat_model.dart';
import 'package:wasla/features/chat/data/models/chat_user_info.dart';
import 'package:wasla/features/chat/data/models/chats_msg_model.dart';
import 'package:wasla/features/chat/data/models/users_chat_msg_model.dart';
import 'package:wasla/features/chat/data/repo/chat_repo.dart';
import 'package:path/path.dart' as path;

class ChatRepoImpl extends ChatRepo {
  final ApiConsumer api;

  ChatRepoImpl({required this.api});

  @override
  Future<Either<String, Null>> sendMsg({
    required String senderId,
    required String receiverId,
    required int type,
    String? messageText,
    File? audio,
    List<File>? images,
  }) async {
    try {
      if (audio == null && images == null && messageText == null) {
        return Left('You Must Send Message');
      }

      final formData = FormData.fromMap({
        if (audio != null)
          'audio': await MultipartFile.fromFile(
            audio.path,
            filename: "${path.basenameWithoutExtension(audio.path)}.webm",
            contentType: MediaType('audio', 'webm'),
          ),
        if (images != null)
          ApiKeys.files: await convertFilesToMultipart(images),
      });

      await api.post(
        'api/Chats/Message',
        queryParameters: {
          ApiKeys.senderId: senderId,
          ApiKeys.receiverIdSend: receiverId,
          ApiKeys.type: type,
          ApiKeys.localId: 'test',

          if (messageText != null) ApiKeys.messageText: messageText,
        },
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );

      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> deleteMsg({
    required int messageId,
    required String senderId,
  }) async {
    try {
      await api.delete(
        ApiEndPoints.chatMsg,
        queryParameters: {
          ApiKeys.messageId: messageId,
          ApiKeys.senderId: senderId,
        },
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> updateMsg({
    required String senderId,
    required String messageText,
    required int messageId,
    required int type,
    required List<String> existFiles,
  }) async {
    final formData = FormData.fromMap({ApiKeys.newFiles: null});
    try {
      await api.put(
        ApiEndPoints.chatMsg,
        queryParameters: {
          ApiKeys.messageId: messageId,
          ApiKeys.senderId: senderId,
          ApiKeys.messageText: messageText,
          ApiKeys.type: type,
          ApiKeys.existFiles: existFiles.isEmpty ? null : existFiles,
        },
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> editUserBio({
    required String userId,
    required String bio,
  }) async {
    try {
      await api.put(
        ApiEndPoints.udpateUserBio,
        body: {ApiKeys.userId: userId, ApiKeys.bio: bio, ApiKeys.lan: 'en'},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Null>> deleteChat({
    required int chatId,
    required String userId,
  }) async {
    try {
      await api.delete(
        ApiEndPoints.deleteChat,
        queryParameters: {ApiKeys.chatId: chatId, ApiKeys.userId: userId},
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ChatMessagesModel>> getUserChat({
    required String senderId,
    required String receiverId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await api.get(
        ApiEndPoints.getSpeceficChat,
        queryParameters: {
          ApiKeys.senderId: senderId,
          ApiKeys.receiverId: receiverId,
          ApiKeys.pageNumberCap: pageNumber,
          ApiKeys.pageSizeCap: pageSize,
        },
      );
      if (response[ApiKeys.data] == null) {
        return Right(
          ChatMessagesModel(
            chatId: 0,
            messages: MessagesPage(
              data: [],
              pageNumber: pageNumber,
              pageSize: pageSize,
              totalCount: 0,
            ),
            receiverId: receiverId,
            senderId: senderId,
          ),
        );
      }
      return Right(ChatMessagesModel.fromJson(response[ApiKeys.data]));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<Failure, List<AllUsersChatModel>>> getAllUsers({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }

      final response = await api.get(
        ApiEndPoints.getAllUserChats,
        queryParameters: {
          ApiKeys.pageNumberCap: pageNumber,
          ApiKeys.pageSizeCap: pageSize,
        },
      );

      final String? userId = await getUserId();

      List<AllUsersChatModel> users = [];
      for (var user in response[ApiKeys.data][ApiKeys.data]) {
        if (user['id'] != userId) {
          users.add(AllUsersChatModel.fromJson(user));
        }
      }
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UsersChatMsgModel>>>
  getUsersThatHaveChatWithTheme({
    required int pageNumber,
    required int pageSize,
    required String userId,
  }) async {
    try {
      if (!await sl<NetworkInfo>().isConnected) {
        return Left(NoInternetFailure());
      }
      final response = await api.get(
        ApiEndPoints.getMyChats,
        queryParameters: {
          ApiKeys.pageNumberCap: pageNumber,
          ApiKeys.pageSizeCap: pageSize,
          ApiKeys.id: userId,
        },
      );
      List<UsersChatMsgModel> users = [];
      for (var user in response[ApiKeys.data][ApiKeys.data]) {
        users.add(UsersChatMsgModel.fromJson(user));
      }
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<String, ChatUserInfo>> getChatUserInfo({
    required String userId,
  }) async {
    try {
      final response = await api.get(
        ApiEndPoints.getProfileForSpecificChat,
        queryParameters: {ApiKeys.id: userId},
      );

      return Right(ChatUserInfo.fromJson(response[ApiKeys.data]));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, Null>> readMsgs({required String chatId}) async {
    try {
      await api.put(ApiEndPoints.chatReadMsgs + chatId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<AllUsersChatModel>>> searchForUsers({
    required String word,
  }) async {
    try {
      if (word.isEmpty) {
        return Right([]);
      }
      final response = await api.get(
        ApiEndPoints.getAllUserChats,
        queryParameters: {ApiKeys.search: word},
      );

      log('Response ${response[ApiKeys.data]}');

      List<AllUsersChatModel> users = [];
      for (var user in response[ApiKeys.data][ApiKeys.data]) {
        users.add(AllUsersChatModel.fromJson(user));
      }
      return Right(users);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  @override
  Future<Either<String, List<UsersChatMsgModel>>>
  searchForUsersThatHaveChatWithTheme({
    required String word,
    required String id,
  }) async {
    try {
      if (word.isEmpty) {
        return Right([]);
      }
      final response = await api.get(
        ApiEndPoints.getMyChats,
        queryParameters: {ApiKeys.search: word, ApiKeys.id: id},
      );

      List<UsersChatMsgModel> users = [];
      for (var user in response[ApiKeys.data][ApiKeys.data]) {
        users.add(UsersChatMsgModel.fromJson(user));
      }
      return Right(users);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }
}
