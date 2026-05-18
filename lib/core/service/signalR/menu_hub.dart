import 'dart:developer';

import 'package:signalr_netcore/signalr_client.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/cache/secure_storage_helper.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';

class MenuHub {
  late HubConnection hubConnection;

  final void Function(int menuItemId, bool isAvailable)?
  onMenuItemStatusChanged;

  final void Function(int menuItemId)? onMenuItemDeleted;

  MenuHub({
    required this.onMenuItemStatusChanged,
    required this.onMenuItemDeleted,
  });

  Future<void> init({required String restaurantId}) async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://waslammka.runasp.net/menuHub',
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

      log('Menu Hub Connected');

      await joinRestaurantGroup(restaurantId);
    } catch (e) {
      toastAlert(color: AppColors.red, msg: e.toString());
    }
  }

  Future<void> joinRestaurantGroup(String restaurantId) async {
    try {
      await hubConnection.invoke('JoinRestaurantGroup', args: [restaurantId]);
    } catch (e) {
      log('Join Group Error: $e');
    }
  }

  void addListeners() {
    /// Menu Item Status Changed
    hubConnection.on('MenuItemStatusChanged', (args) {
      log('Status Changed Fired');
      if (args != null && args.isNotEmpty) {
        // final data = args[0] as Map;

        // final int menuItemId = data['menuItemId'];
        // final bool isAvailable = data['isAvailable'];

        // log(
        //   'MenuItemStatusChanged => '
        //   'ID: $menuItemId | Available: $isAvailable',
        // );

        // onMenuItemStatusChanged?.call(menuItemId, isAvailable);
      }
    });

    /// Menu Item Deleted
    hubConnection.on('MenuItemDeleted', (args) {
      if (args != null && args.isNotEmpty) {
        final data = args[0] as Map;

        final int menuItemId = data['menuItemId'];
        onMenuItemDeleted?.call(menuItemId);
      }
    });
  }

  Future<void> disconnect() async {
    await hubConnection.stop();

    log('Menu Hub Disconnected');
  }
}
