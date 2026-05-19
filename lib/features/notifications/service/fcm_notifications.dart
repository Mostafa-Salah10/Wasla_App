import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:wasla/core/database/api/api_end_points.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/enums/notifications_routes.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/features/chat/presentation/manager/cubit/chat_cubit.dart';
import 'package:wasla/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:wasla/features/notifications/service/local_notificatons.dart';

class FcmNotifications {
  static late FirebaseMessaging messaging;
  static late String deviceToken;
  static late String accessToken;

  static const backendToken = '61f689b8f7b8902af0813aba362ccee141862b08';
  static const firebaseProjectId = 'wasla-39f17';

  static Future<void> init() async {
    messaging = FirebaseMessaging.instance;
    //request permission of device (enabled by default in android)
    await messaging.requestPermission();
    // getDeviceToken();
    FirebaseMessaging.onMessage.listen(handleForgroundNotifications);
    // getAccessToken();
  }

  //get Token of Device
  static Future<void> getDeviceToken() async {
    String token = await messaging.getToken() ?? 'null';
    deviceToken = token;
    debugPrint("************ Token ******************");
    debugPrint("************ $token ******************");
    debugPrint("************ Token ******************");
  }

  //handle notifications when app is forground
  static void handleForgroundNotifications(RemoteMessage message) {
    final int routeIndex = int.parse(message.data['type']);
    final route = NotificationRoute.fromInt(routeIndex);
    if (route != NotificationRoute.rideAccepted) {
      if (route == NotificationRoute.messageReceived) {
        final cubit = navigatorKey.currentContext?.read<ChatCubit>();
        final String referenceId = message.data['refrenceId'];
        List<String> parts = referenceId.split(',');
        String receiverId = parts[1].trim();

        if (receiverId != cubit?.currentResceiver) {
          LocalNotifications.showNormalNotificaton(message: message);
        }
      } else {
        LocalNotifications.showNormalNotificaton(message: message);
      }
    }

    navigateToRouteRealTime(message: message);
    navigatorKey.currentContext
        ?.read<NotificationCubit>()
        .getLastSeenNotificationsCount();
  }

  //subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
  }

  //unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
  }

  //get Access key of app
  static Future<void> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "wasla-39f17",
      "private_key_id": "61f689b8f7b8902af0813aba362ccee141862b08",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDH1Wp2Ogdb7y34\n35Osh9xDzvvwYC+tUgTx1Wl9SIHzXFhgl2qMAqh65HdYNDtMhGUfJ7QQAQP/Nz1c\nVqUC7N4FXAgl/bjthqYNTxgWCMc+uJ/lpR0solbFMX3xejf0gTtzo1ikUl+hZUAF\nrZGTehZSMTF7hCVUJmOgAZIOlLaRMlDrcS/Cbr8ATmLxQU5axOSAa72DLBbQFNGX\n1a2h5Z+pk15jD2NVJEI2gXlQMdfS30gaOdSXBRbJSzAJjUAKa1M878t6rlsNuyf5\nW+q1HJrqfU9Yb25mH9ia0986A9AQ9yFq4OsbcH5MD/op1E827MgrZKGkGZ2OiLtX\nqqqifgLNAgMBAAECggEALcHl/01ZSwlQ9whG2b5ARvyZvthfgmnh/PgXkBruuqle\nCTwSpx2is4Ul+Ln5DBPSzdf7CKEa57Ef6UljvnA7hHGm4gAffLAUzL5cLwtyiB+h\naWWt8P75LG0hQA5yypde5CM2lGXSRPQYvVQZnfHaM5bVFEnVfFfP/x7s8U7HISbD\nAd7bgR5qFa7q1/Yj1mPeNVJchOqWqZgX6AZWGS7I9naSmvY1IHZWBIbaVeHVJczS\nEnfPVNwynK/vDKnROAyjZAqEQ31sLi3JyTEeZI+Ze351pedPvmFf6G84aTeAo9jJ\nWwQflCcKFQH2pDENlwba+e0PnmMY8/idiDLHbwb8xwKBgQDyTEa5f9AgY7CHEns6\nEI/J19RnrtkEdw9gujTFKiwCiO+1lgcJfKYTJa+A1OlJDVylTYK9SW5hzM1h+r9z\n7BZPFk2QTha7hvaTheKIx80LThi2xfUSOVxHXvaDfx4f6FWNZZTf8XlxElIhYUWS\nSVYh2PHejSvtVsJHPiXH3PoYWwKBgQDTImNbVSOKvp2gy8dNa74SRUvksjIRtHRg\nmQMS1YTY0ntLxH9lyMX+xfMCHbXffmY1djw3bDw1P5fibvgj9X6f80C05FoCu6Bo\nAxJ88iFSMihFn7DpwUnaXsY4VUj+GuiB2O9Mm2yclRWutm3EIl7s7yMYMM2/YeS1\nRPArWoD59wKBgGJY1YgrueW7sQZSWRQrbsGlykA/dzTZwrMnQY4Z3P02ad3RxI90\nOdChxkfLo9kUBFvQR1XffV9TCrZPWfCKjk+RpPAC0jVRxboBaP7N4otJKrzdQukf\nwTXy9KpRKYAYBMm8xp3TXNCpeA62dc+31q8saJhFwuO2CGt0bU9fgV/rAoGAOeEd\nd7Y5Thm/QItckZ7NtliE26b2DuB3XtvTeeBK0N2yqyys+Aw4KwW8/oGCkEgoYNOO\n4mqrfrV2P77IC6OLGPIodO58tm8VJC5jbRk7hTr2y09hwlMYmeKNWHgY0IAz6RS9\nVTTua2Z7US/1m2UIvM85wbHvVV3SwtapOFlRLjUCgYByZzqpqNx7wAu3uWqOjVl2\n6/opsUHKqUJYShO0cYQYfBFoB6Yjwy/xFkdVth1PKQI44z1F48UCN8SyioIXTDUF\neULg7k4WVDjudu9hJ0H3Ubya3KdwTZ1f/AAwkxHXbDi0CnTcXVbXPRjSbf6747sU\n55tyoOCxiHrhu2uylUD7KQ==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@wasla-39f17.iam.gserviceaccount.com",
      "client_id": "104620692256830060312",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40wasla-39f17.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    // auth.AccessCredentials credentials =

    await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    // accessToken = credentials.accessToken.data;
    // debugPrint("************ Access Token ******************");
    // debugPrint(
    //   "************ ${credentials.accessToken.data} ******************",
    // );
    // debugPrint("************ Access Token ******************");
  }

  //send notification from device
  static Future<dynamic> sendNotification({
    required String title,
    required String body,
  }) async {
    final Map<String, dynamic> message = {
      ApiKeys.message: {
        ApiKeys.token: deviceToken,
        ApiKeys.notification: {ApiKeys.title: title, ApiKeys.body: body},
        ApiKeys.data: {"route": "Any Thing"},
      },
    };
    final http.Response response = await http.post(
      Uri.parse(ApiEndPoints.fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully');
    } else {
      debugPrint('Failed to send notification');
    }
  }

  static Future<void> whenTappedOnBackgroundNotificaton() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationRoute route = NotificationRoute.fromInt(
        int.parse(message.data['type']),
      );
      navigateToRightRoute(
        route: route,
        referenceId: message.data['refrenceId'],
      );
    });
  }

  static Future<void> whenTappedOnTerminatedNotificaton() async {
    RemoteMessage? message = await FirebaseMessaging.instance
        .getInitialMessage();

    if (message != null) {
      NotificationRoute route = NotificationRoute.fromInt(
        int.parse(message.data['type']),
      );
      navigateToRightRoute(
        
        route: route,
        referenceId: message.data['refrenceId'],
      );
    }
  }
}

//handle notificaiton in background and trminated
@pragma('vm:entry-point')
Future<void> handleBackgroundAndTerminatedNotifications(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();
  navigateToRouteRealTime(message: message);
  navigatorKey.currentContext
      ?.read<NotificationCubit>()
      .getLastSeenNotificationsCount();
}
