import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/app_sizes.dart';
import 'package:wasla/core/widgets/general_button.dart';
import 'package:wasla/features/profile/presentation/widgets/custom_switch_button.dart';
import 'package:wasla/features/profile/presentation/widgets/profile_item.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restauarant_menu_item_model.dart';
import 'package:wasla/features/restaurant/menu/presentation/manager/cubit/resident_menu_cubit.dart';
import 'package:wasla/features/restaurant/menu/presentation/widgets/add%20menu/add_menu_category.dart';
import 'package:wasla/features/restaurant/menu/presentation/widgets/add%20menu/add_menu_form.dart';
import 'package:wasla/features/restaurant/menu/presentation/widgets/add%20menu/add_menu_image.dart';

class AddMenuItemBody extends StatelessWidget {
  const AddMenuItemBody({super.key, this.menu});
  final MenuItem? menu;

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      setAvailability(menu!.isAvailable, context);
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.marginDefault,
        vertical: AppSizes.paddingSizeEight,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                AddMenuForm(menu: menu),
                SizedBox(height: AppSizes.paddingSizeDefault),
                AddMenuCategory(
                  categoryId: isEdit
                      ? context.read<ResidentMenuCubit>().currentCategoryId
                      : null,
                  menuId: menu?.id,
                ),
                SizedBox(height: AppSizes.paddingSizeDefault),
                BlocBuilder<ResidentMenuCubit, ResidentMenuState>(
                  buildWhen: (previous, current) =>
                      current is ResidentMenuToggleAvailability,
                  builder: (context, state) {
                    return Visibility(
                      visible: isEdit,
                      child: CustomSwitchButtonWithTitle(
                        title: 'availablity'.tr(context),
                        trailing: CustomSwitchButton(
                          withouteTransilate: true,
                          onChanged: (value) {
                            context
                                .read<ResidentMenuCubit>()
                                .changeMenuAvailability(menuIsAvailable: value);
                          },
                          value: context
                              .read<ResidentMenuCubit>()
                              .menuIsAvailable,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSizes.paddingSizeDefault),
                const AddMenuImage(),
              ],
            ),
          ),
          SizedBox(height: AppSizes.paddingSizeDefault),
          BlocConsumer<ResidentMenuCubit, ResidentMenuState>(
            listener: (context, state) {
              if (state is ResidentAddOrUpdateMenuItemSuccessState) {
                if (isEdit) {
                  showToast('menuUpdated'.tr(context), color: AppColors.green);
                } else {
                  showToast('menuAdded'.tr(context), color: AppColors.green);
                  Navigator.pop(context);
                }
              } else if (state is ResidentAddOrUpdateMenuItemFailureState) {
                showToast(state.errMsg, color: Colors.red);
              }
            },
            builder: (context, state) {
              final cubit = context.read<ResidentMenuCubit>();
              return GeneralButton(
                onPressed: () {
                  if (cubit.addMenuFormKey.currentState!.validate() &&
                      state is! ResidentAddOrUpdateMenuItemLoadingState) {
                    if (isEdit) {
                      cubit.updateMenu(menuItem: menu!);
                    } else {
                      cubit.addMenuItem();
                    }
                  }
                },
                text: state is ResidentAddOrUpdateMenuItemLoadingState
                    ? 'loading'.tr(context)
                    : isEdit
                    ? 'updateMenu'
                    : 'addMenu'.tr(context),
              );
            },
          ),
          SizedBox(height: AppSizes.paddingSizeDefault),
        ],
      ),
    );
  }

  bool get isEdit => menu != null;

  void setAvailability(bool value, BuildContext context) {
    context.read<ResidentMenuCubit>().changeMenuAvailability(
      menuIsAvailable: value,
    );
  }
}
