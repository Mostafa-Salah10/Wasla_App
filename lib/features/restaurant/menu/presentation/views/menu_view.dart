import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/config/routes/app_routes.dart';
import 'package:wasla/core/extensions/custom_navigator_extension.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/core/widgets/bloc_status_handler.dart';
import 'package:wasla/features/doctor_service/features/service/presentation/widgets/custom_doc_add_service_float_button.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';
import 'package:wasla/features/restaurant/menu/presentation/widgets/menu_body.dart';

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
      appBar: AppBar(title: Text('menu'.tr(context))),
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
