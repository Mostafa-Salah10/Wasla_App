import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/service/signalR/menu_hub.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/bloc_status_handler.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/widgets/menu/resident_menu_body.dart';

class ResidentMenuView extends StatefulWidget {
  const ResidentMenuView({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<ResidentMenuView> createState() => _ResidentMenuViewState();
}

class _ResidentMenuViewState extends State<ResidentMenuView> {
  late final MenuHub menuHub;
  @override
  void initState() {
    menuHub = MenuHub(
      onMenuItemStatusChanged: (menuId, availabiltiy) {},
      onMenuItemDeleted: (menuId) {
        final cubit = context.read<ResidentMenuCubit>();
        cubit.onMenuDeleted(menuId: menuId);
      },
    );

    menuHub.init(restaurantId: widget.restaurantId);
    getMenu();
    super.initState();
  }

  @override
  void dispose() {
    menuHub.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('menu'.tr(context)),
        actions: [
          IconButton(
            onPressed: () {
              context.pushScreen(
                AppRoutes.restaurantCartScreen,
                arguments: widget.restaurantId,
              );
            },
            icon: Icon(Icons.shopping_cart, color: AppColors.primaryColor),
          ),
        ],
      ),
      body: BlocStatusHandler<ResidentMenuCubit, ResidentMenuState>(
        body: ResidentMenuBody(restaurantId: widget.restaurantId),
        onRetry: () {
          getMenu();
          context.read<ResidentMenuCubit>().onRetry();
        },
        isNetwork: (state) => state is ResidentMenuNetworkState,
        isError: (state) => state is ResidentMenuFailureState,
        buildWhen: (previous, current) =>
            current is ResidentMenuNetworkState ||
            current is ResidentMenuFailureState ||
            current is ResidentMenuOnRetryState,
      ),
    );
  }

  void getMenu() {
    final cubit = context.read<ResidentMenuCubit>();
    cubit.getMenuCategories(restaurantId: widget.restaurantId);
    cubit.getMenuItems(restaurantId: widget.restaurantId, categoryId: 0);
  }
}
