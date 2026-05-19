import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/enums/technician_booking_status.dart';
import 'package:wasla/core/functions/format_date_from_string.dart';
import 'package:wasla/core/functions/format_time_with_intl.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/features/technicant/features/booking/data/models/technicain_booking_model.dart';
import 'package:wasla/features/technicant/features/booking/presentation/manager/cubit/technician_booking_cubit.dart';
import 'package:wasla/features/technicant/features/booking/presentation/widgets/technicain_booking_cancel_button.dart';

class TechnicianBookingListItemData extends StatelessWidget {
  const TechnicianBookingListItemData({super.key, required this.technician});
  final TechnicainBookingModel technician;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context),
        _buildSpecialityWidget(context),
        _buildDateAndTimeWidget(context),
      ],
    );
  }

  Row _buildSpecialityWidget(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            technician.residentPhone,
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: AppColors.gray),
          ),
        ),
        Text(
          " |  ${technician.status.name.tr(context)} ",
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(color: AppColors.gray),
        ),
      ],
    );
  }

  Row _buildTitleWidget(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            technician.residentName,
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Visibility(
          visible: technician.status == TechnicianBookingStatus.pending,
          child: BlocListener<TechnicianBookingCubit, TechnicianBookingState>(
            listenWhen: (previous, current) =>
                current is TechnicianBookingActionState &&
                current.bookingId == technician.bookingId,
            listener: (context, state) {
              if (state is TechincainAcceptBookingSuccessState) {
                showToast(
                  'bookingAcceptedSuccess'.tr(context),
                  color: AppColors.green,
                );
              }

              if (state is TechincainAcceptBookingFailureState) {
                showToast(state.errorMessage, color: AppColors.red);
              }
            },
            child: TechnicianBookingCancelOrAcceptButton(
              isCancel: false,
              text: "accept".tr(context),
              color: AppColors.primaryColor,
              onTap: () {
                context.read<TechnicianBookingCubit>().acceptBooking(
                  bookingId: technician.bookingId,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _buildDateAndTimeWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "${formatDateBooking(technician.bookingDate)} | ${formatDateTimeWithIntl(technician.bookingDate)}",
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: AppColors.gray),
              ),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "${'price'.tr(context)} : ${technician.price} ${"egb".tr(context)}",
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: AppColors.gray),
              ),
            ],
          ),
        ),
        Visibility(
          visible:
              technician.status == TechnicianBookingStatus.pending ||
              technician.status == TechnicianBookingStatus.accepted,
          child: BlocListener<TechnicianBookingCubit, TechnicianBookingState>(
            listenWhen: (previous, current) =>
                current is TechnicianBookingActionState &&
                current.bookingId == technician.bookingId,
            listener: (context, state) {
              if (state is TechincainCancelBookingSuccessState) {
                showToast(
                  'bookingCaceledSuccess'.tr(context),
                  color: AppColors.green,
                );
              }

              if (state is TechincainCancelBookingFailureState) {
                showToast(state.errorMessage, color: AppColors.red);
              }
            },
            child: TechnicianBookingCancelOrAcceptButton(
              isCancel: true,
              text: "cancel".tr(context),
              color: AppColors.red,
              onTap: () {
                context.read<TechnicianBookingCubit>().cancelBooking(
                  bookingId: technician.bookingId,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
