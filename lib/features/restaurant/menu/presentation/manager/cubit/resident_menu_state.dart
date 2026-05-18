part of 'resident_menu_cubit.dart';

sealed class ResidentMenuState {
  const ResidentMenuState();
}

final class ResidentMenuInitial extends ResidentMenuState {}

////Update States
final class ResidentMenuSelectCategory extends ResidentMenuState {}
final class ResidentMenuToggleAvailability extends ResidentMenuState {}

final class ResidentMenuUpdateMenuImage extends ResidentMenuState {}

///Basics State
final class ResidentMenuNetworkState extends ResidentMenuState {}

final class ResidentMenuFailureState extends ResidentMenuState {}

final class ResidentMenuOnRetryState extends ResidentMenuState {}

////get menu categories

final class ResidentGetMenuCateroriesLoadingState extends ResidentMenuState {}

final class ResidentGetMenuCateroriesLoadedState extends ResidentMenuState {
  final List<RestaurantMenuCategoryModel> categories;

  const ResidentGetMenuCateroriesLoadedState(this.categories);
}

////get menu category items

final class ResidentGetMenuCategoryItemsLoadingState
    extends ResidentMenuState {}

final class ResidentGetMenuCategoryItemsLoadedState extends ResidentMenuState {
  final List<MenuItem> items;

  const ResidentGetMenuCategoryItemsLoadedState(this.items);
}

///add or update menu item

final class ResidentAddOrUpdateMenuItemLoadingState extends ResidentMenuState {}

final class ResidentAddOrUpdateMenuItemFailureState extends ResidentMenuState {
  final String errMsg;

  ResidentAddOrUpdateMenuItemFailureState({required this.errMsg});
}

final class ResidentAddOrUpdateMenuItemSuccessState extends ResidentMenuState {}

/// delete menu item

final class ResidentDeleteMenuItemFailureState extends ResidentMenuState {
  final String errMsg;
  ResidentDeleteMenuItemFailureState({required this.errMsg});
}

final class ResidentDeleteMenuItemSuccessState extends ResidentMenuState {}

////add To Menu To Cart

abstract final class MenuCart extends ResidentMenuState {
  final int menuId;
  MenuCart({required this.menuId});
}

final class AddMenuToCartFailureState extends MenuCart {
  final int id;
  final String errMsg;
  AddMenuToCartFailureState({required this.errMsg, required this.id})
    : super(menuId: id);
}

final class AddMenuToCartLaodingState extends MenuCart {
  final int id;
  AddMenuToCartLaodingState({required this.id}) : super(menuId: id);
}

final class AddMenuToCartSuccessState extends MenuCart {
  final int id;
  AddMenuToCartSuccessState({required this.id}) : super(menuId: id);
}
