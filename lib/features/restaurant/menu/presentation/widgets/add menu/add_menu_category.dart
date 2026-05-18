
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/features/auth/data/models/drop_down_menu_item.dart';
import 'package:wasla/features/auth/presentation/widgets/custom_drop_down_menu.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restaurant_menu_category_model.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';

class AddMenuCategory extends StatefulWidget {
  const AddMenuCategory({super.key, this.categoryId, this.menuId});
  final int? categoryId;
  final int? menuId;
  @override
  State<AddMenuCategory> createState() => _AddMenuCategoryState();
}

class _AddMenuCategoryState extends State<AddMenuCategory> {
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  List<RestaurantMenuCategoryModel> categories = [];
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResidentMenuCubit>();
    return BlocBuilder<ResidentMenuCubit, ResidentMenuState>(
      buildWhen: (previous, current) =>
          current is ResidentGetMenuCateroriesLoadedState,
      builder: (context, state) {
        if (state is ResidentGetMenuCateroriesLoadedState) {
          categories = state.categories;
          if (categories.isNotEmpty) {
            cubit.addMenuCategoryId = state.categories.first.id;
          }
          if (widget.categoryId != null) {
            if (widget.categoryId == 0) {
              //all
              cubit.addMenuCategoryId = cubit.getCategoryIdByItem(
                menuId: widget.menuId!,
              );
            } else {
              cubit.addMenuCategoryId = widget.categoryId!;
            }
          }
        }

        return CustomDropDownMenu(
          initialSelection: widget.categoryId != null
              ? cubit.addMenuCategoryId.toString()
              : categories.isNotEmpty
              ? categories.first.id.toString()
              : null,
          items: categories
              .map(
                (category) => DropDownItem(
                  label: category.nameValue,
                  value: category.id.toString(),
                ),
              )
              .toList(),
          onSelecte: (category) {
            cubit.addMenuCategoryId = int.parse(category!);
          },
        );
      },
    );
  }

  void getCategories() async {
    final cubit = context.read<ResidentMenuCubit>();
    final String? restaurantId = await getUserId();
    cubit.getMenuCategories(restaurantId: restaurantId!);
  }
}
