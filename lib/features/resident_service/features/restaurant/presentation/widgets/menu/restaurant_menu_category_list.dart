import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/widgets/empty_data_widget.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restauarant_menu_item_model.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';
import 'package:wasla/features/resident_service/features/restaurant/presentation/widgets/menu/restuaratn_menu_card.dart';

class RestaurantMenuCatgoryList extends StatefulWidget {
  const RestaurantMenuCatgoryList({
    super.key,
    required this.showOrderButton,
    this.restaurantId,
  });

  final bool showOrderButton;
  final String? restaurantId;

  @override
  State<RestaurantMenuCatgoryList> createState() =>
      _RestaurantMenuCatgoryListState();
}

class _RestaurantMenuCatgoryListState extends State<RestaurantMenuCatgoryList> {
  List<MenuItem> items = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResidentMenuCubit, ResidentMenuState>(
      listener: (context, state) {
        if (state is ResidentDeleteMenuItemFailureState) {
          showToast(state.errMsg, color: Colors.red);
        } else if (state is ResidentDeleteMenuItemSuccessState) {
          showToast('menuDeleted'.tr(context));
        }
      },
      buildWhen: (previous, current) =>
          current is ResidentGetMenuCategoryItemsLoadingState ||
          current is ResidentGetMenuCategoryItemsLoadedState,
      builder: (context, state) {
        if (state is ResidentGetMenuCategoryItemsLoadingState ||
            state is ResidentMenuInitial) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),
          );
        } else if (state is ResidentGetMenuCategoryItemsLoadedState) {
          items = state.items;
        }

        if (items.isEmpty) {
          return EmptyStateWidget(
            message: 'noItemsInSystem'.tr(context),
            title: 'noItems'.tr(context),
          );
        }

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: widget.showOrderButton ? 0.70 : 0.78,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) =>
              BlocBuilder<ResidentMenuCubit, ResidentMenuState>(
                buildWhen: (previous, current) =>
                    current is ResidentUpdateMenuStatus &&
                    items.elementAt(index).id == current.menuId,
                builder: (context, state) {
                  return RestaurantMenuItemCard(
                    restaurantId: widget.restaurantId,
                    item: items.elementAt(index),
                    showOrderButton:
                        widget.showOrderButton &&
                        items.elementAt(index).isAvailable,
                  );
                },
              ),
        );
      },
    );
  }
}
