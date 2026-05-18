import 'package:signalr_netcore/signalr_client.dart';
import 'package:wasla/core/database/api/api_keys.dart';
import 'package:wasla/core/database/cache/secure_storage_helper.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';

class OrderHub {
  late HubConnection hubConnection;
  final void Function(int orderId, int status)? onOrderStatusChanged;

  OrderHub({required this.onOrderStatusChanged});

  Future<void> init() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://waslammka.runasp.net/orderHub',
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
      toastAlert(color: AppColors.red, msg: e.toString());
    }
  }

  void addListeners() {
    hubConnection.on('OrderStatusChanged', (args) {
      if (args != null && args.isNotEmpty) {
        int orderId = args[0] as int;
        int status = args[1] as int;

        onOrderStatusChanged!(orderId, status);
      }
    });
  }

  Future<void> disconnect() async {
    await hubConnection.stop();
  }
}
