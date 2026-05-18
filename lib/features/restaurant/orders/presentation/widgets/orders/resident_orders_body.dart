import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/service/signalR/order_hub.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/core/utils/app_sizes.dart';
import 'package:wasla/core/widgets/empty_data_widget.dart';
import 'package:wasla/features/restaurant/orders/data/model/resident_order_model.dart';
import 'package:wasla/features/restaurant/orders/presentation/widgets/orders/resident_restaurant_orders_list.dart';
import 'package:wasla/features/restaurant/orders/presentation/manager/cubit/orders_cubit.dart';

class ResidentRestaurantOrdersBody extends StatefulWidget {
  const ResidentRestaurantOrdersBody({super.key});

  @override
  State<ResidentRestaurantOrdersBody> createState() =>
      _ResidentRestaurantOrdersBodyState();
}

class _ResidentRestaurantOrdersBodyState
    extends State<ResidentRestaurantOrdersBody> {
  List<ResidentOrderModel> orders = [];

  late final OrderHub restaurantHub;
  @override
  void initState() {
    super.initState();
    restaurantHub = OrderHub(
      onOrderStatusChanged: (orderId, status) {
        context.read<OrdersCubit>().markOrderAsOnTheWay(
          orderId: orderId,
          status: status,
        );
      },
    );
    restaurantHub.init();
  }

  @override
  void dispose() {
    restaurantHub.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.marginDefault),
      child: BlocBuilder<OrdersCubit, OrdersState>(
        buildWhen: (previous, current) =>
            current is GetOrdersForResidetntLoadingState ||
            current is GetOrdersForResidetntLoadedState,
        builder: (context, state) {
          if (state is GetOrdersForResidetntLoadingState ||
              state is OrdersInitial) {
            return Center(
              child: SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50.0,
              ),
            );
          } else if (state is GetOrdersForResidetntLoadedState) {
            orders = state.orders;
          }

          return orders.isEmpty
              ? EmptyStateWidget(
                  title: 'noOrders'.tr(context),
                  message: 'noOrdersAtTheMoment'.tr(context),
                )
              : ResidentOrdersPaginationList(orders: orders);
        },
      ),
    );
  }
}
