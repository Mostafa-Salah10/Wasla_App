import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/error/failure.dart';
import 'package:wasla/core/functions/get_user_id.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restauarant_menu_item_model.dart';
import 'package:wasla/features/resident_service/features/restaurant/data/models/restaurant_menu_category_model.dart';
import 'package:wasla/features/restaurant/menu/data/repo/resident_menu_repo.dart';

part 'resident_menu_state.dart';

class ResidentMenuCubit extends Cubit<ResidentMenuState> {
  ResidentMenuCubit(this.menu) : super(ResidentMenuInitial());

  final ResidentMenuRepo menu;

  List<RestauarantMenuItemModel> allCategoriesItems = [];

  int currentCategoryId = 0;
  int addMenuCategoryId = 0;
  File? menuImage;

  String menuNameAr = '', menuNameEn = '';
  double discount = 0, price = 0;
  int preparationTime = 0;
  bool menuIsAvailable = true;

  void changeMenuAvailability({required bool menuIsAvailable}) {
    this.menuIsAvailable = menuIsAvailable;
    emit(ResidentMenuToggleAvailability());
  }

  final addMenuFormKey = GlobalKey<FormState>();

  void onRetry() {
    emit(ResidentMenuOnRetryState());
  }

  void updateMenuImage({required File image}) {
    menuImage = image;
    emit(ResidentMenuUpdateMenuImage());
  }

  void selectMenuCategory({required int categoryId}) {
    if (categoryId != currentCategoryId) {
      currentCategoryId = categoryId;
      emit(ResidentMenuSelectCategory());
      filterItemsByCategory(categoryId: categoryId);
    }
  }

  Future<void> getMenuCategories({required String restaurantId}) async {
    emit(ResidentGetMenuCateroriesLoadingState());
    final result = await menu.getMenuCategories(restaurantId: restaurantId);
    result.fold((failure) {
      if (failure is NoInternetFailure) {
        emit(ResidentMenuNetworkState());
      } else {
        emit(ResidentMenuFailureState());
      }
    }, (categories) => emit(ResidentGetMenuCateroriesLoadedState(categories)));
  }

  Future<void> getMenuItems({
    required String restaurantId,
    required int categoryId,
  }) async {
    allCategoriesItems.clear();
    emit(ResidentGetMenuCategoryItemsLoadingState());
    final result = await menu.getMenuItems(restaurantId: restaurantId);
    result.fold(
      (failure) {
        if (failure is NoInternetFailure) {
          emit(ResidentMenuNetworkState());
        } else {
          emit(ResidentMenuFailureState());
        }
      },
      (items) {
        allCategoriesItems = items;

        filterItemsByCategory(categoryId: categoryId);
      },
    );
  }

  void filterItemsByCategory({required int categoryId}) {
    if (categoryId == 0) {
      List<MenuItem> allItems = [];
      for (var element in allCategoriesItems) {
        allItems.addAll(element.items);
      }

      emit(ResidentGetMenuCategoryItemsLoadedState(allItems));
      return;
    }

    List<MenuItem> filteredItems = [];
    for (var element in allCategoriesItems) {
      if (element.categoryId == categoryId) {
        filteredItems.addAll(element.items);
      }
    }
    emit(ResidentGetMenuCategoryItemsLoadedState(filteredItems));
  }

  Future<void> addMenuItem() async {
    if (menuImage == null) return;
    final String? restaurantId = await getUserId();
    emit(ResidentAddOrUpdateMenuItemLoadingState());
    final result = await menu.addMenu(
      restaurantId: restaurantId!,
      nameAr: menuNameAr,
      nameEn: menuNameEn,
      price: price,
      categoryId: addMenuCategoryId,
      image: menuImage!,
      discount: discount,
      preparationTime: preparationTime,
    );
    result.fold(
      (failure) {
        emit(ResidentAddOrUpdateMenuItemFailureState(errMsg: failure));
      },
      (success) async {
        final String? restaurantId = await getUserId();
        await getMenuItems(
          restaurantId: restaurantId!,
          categoryId: currentCategoryId,
        );
        emit(ResidentAddOrUpdateMenuItemSuccessState());
        reset();
      },
    );
  }

  Future<void> updateMenu({required MenuItem menuItem}) async {
    emit(ResidentAddOrUpdateMenuItemLoadingState());
    final result = await menu.updateMenu(
      isAvailable: menuIsAvailable,
      id: menuItem.id,
      nameAr: menuNameAr.isEmpty ? menuItem.name : menuNameAr,
      nameEn: menuNameEn.isEmpty ? menuItem.name : menuNameEn,
      price: price == 0 ? menuItem.price : price,
      categoryId: addMenuCategoryId,
      image: menuImage,
      discount: discount == 0 ? menuItem.discountPrice : discount,
      preparationTime: preparationTime == 0
          ? menuItem.preparationTime
          : preparationTime,
    );
    result.fold(
      (failure) {
        emit(ResidentAddOrUpdateMenuItemFailureState(errMsg: failure));
      },
      (success) async {
        final String? restaurantId = await getUserId();
        await getMenuItems(
          restaurantId: restaurantId!,
          categoryId: currentCategoryId,
        );
        emit(ResidentAddOrUpdateMenuItemSuccessState());
        reset();
      },
    );
  }

  Future<void> deleteMenu({required int menuId}) async {
    final result = await menu.deleteMenu(id: menuId);
    result.fold(
      (failure) {
        emit(ResidentDeleteMenuItemFailureState(errMsg: failure));
      },
      (success) async {
        for (var category in allCategoriesItems) {
          category.items.removeWhere((menu) {
            return menu.id == menuId;
          });
        }
        emit(ResidentDeleteMenuItemSuccessState());
        filterItemsByCategory(categoryId: currentCategoryId);
      },
    );
  }

  int getCategoryIdByItem({required int menuId}) {
    for (var category in allCategoriesItems) {
      for (var item in category.items) {
        if (item.id == menuId) {
          return category.categoryId;
        }
      }
    }
    return 0;
  }

  Future<void> addMenuItemToCart({
    required int menuId,
    required String restaurantId,
  }) async {
    emit(AddMenuToCartLaodingState(id: menuId));
    final String? residentId = await getUserId();
    final result = await menu.addMenuToCart(
      menuId: menuId,
      residentId: residentId!,
      restaurantId: restaurantId,
    );
    result.fold(
      (failure) {
        emit(AddMenuToCartFailureState(errMsg: failure, id: menuId));
      },
      (success) {
        emit(AddMenuToCartSuccessState(id: menuId));
      },
    );
  }

  void reset() {
    menuImage = null;
    menuNameAr = '';
    menuNameEn = '';
    discount = 0;
    price = 0;
    preparationTime = 0;
    addMenuCategoryId = 0;
  }
}
