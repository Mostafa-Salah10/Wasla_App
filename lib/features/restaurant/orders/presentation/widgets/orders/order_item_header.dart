import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/features/restaurant/orders/data/model/base_order_model.dart';
import 'package:wasla/features/restaurant/orders/data/model/resident_order_model.dart';
import 'package:wasla/features/restaurant/orders/data/model/restaurant_order_model.dart';
import 'package:wasla/features/restaurant/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:wasla/features/restaurant/orders/presentation/widgets/orders/order_status_badge.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader({
    super.key,
    required this.order,
    required this.formatedDate,
  });

  final BaseOrderModel order;
  final String formatedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'order'.tr(context),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.9,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#${order.id}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<OrdersCubit, OrdersState>(
                buildWhen: (previous, current) =>
                    current is ChangeOrderStatusState &&
                    current.orderId == order.id,
                builder: (context, state) {
                  return OrderStatusBadge(status: order.status);
                },
              ),
              InkWell(
                onTap: () {
                  context.read<OrdersCubit>().toggleOrderDetails(
                    orderId: order.id,
                  );
                },
                child: Transform.translate(
                  offset: context.isArabic
                      ? const Offset(-12, 0)
                      : const Offset(12, 0),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetaItem(
                  label: isRestaurantOrder
                      ? 'customer'.tr(context)
                      : 'restaurant'.tr(context),
                  value: isRestaurantOrder
                      ? (order as OrderModel).residentName
                      : (order as ResidentOrderModel).restaurantName,
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: _MetaItem(
                    label: 'createdAt'.tr(context),
                    value: formatedDate,
                  ),
                ),
              ),
              if (isRestaurantOrder)
                Expanded(
                  flex: 1,
                  child: _MetaItem(
                    label: 'phone'.tr(context),
                    value: (order as OrderModel).residentPhone,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool get isRestaurantOrder => order is OrderModel;
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          value,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
