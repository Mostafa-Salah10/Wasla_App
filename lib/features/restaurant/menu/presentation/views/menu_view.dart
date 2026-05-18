import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/database/api/api_consumer.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/service/service_locator.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/app_sizes.dart';
import 'package:wasla/core/utils/assets.dart';
import 'package:wasla/core/widgets/bloc_status_handler.dart';
import 'package:wasla/features/doctor_service/features/service/presentation/widgets/custom_doc_add_service_float_button.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';
import 'package:wasla/features/restaurant/menu/presentation/widgets/menu_body.dart';
import 'package:wasla/features/restaurant/orders/data/repo/orders_repo_impl.dart';
import 'package:wasla/features/restaurant/orders/presentation/manager/cubit/orders_cubit.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  void initState() {
    super.initState();
    getMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return CustomFloatingAddButton(
            onPressed: () {
              context.pushScreen(
                AppRoutes.addMenuItemScreen,
                arguments: context.read<ResidentMenuCubit>(),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text('menu'.tr(context)),
        actions: [
          BlocProvider(
            create: (context) =>
                OrdersCubit(OrdersRepoImpl(api: sl<ApiConsumer>())),
            child: Padding(
              padding: EdgeInsets.only(right: AppSizes.marginDefault),
              child: IconButton(
                icon: Image.asset(
                  Assets.assetsImagesTakeAway,
                  color: AppColors.primaryColor,
                  height: 25,
                  width: 25,
                ),
                onPressed: () {
                  context.pushScreen(AppRoutes.orderScreen);
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocStatusHandler<ResidentMenuCubit, ResidentMenuState>(
        body: const MenuBody(),
        onRetry: () {
          context.read<ResidentMenuCubit>().onRetry();
          getMenu();
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

  void getMenu() async {
    final cubit = context.read<ResidentMenuCubit>();
    final String? restaurantId = await getUserId();
    cubit.getMenuCategories(restaurantId: restaurantId!);
    cubit.getMenuItems(restaurantId: restaurantId, categoryId: 0);
  }
}
