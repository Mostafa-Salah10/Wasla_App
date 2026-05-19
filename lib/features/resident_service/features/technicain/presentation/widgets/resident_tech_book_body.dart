import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/config/localization/app_localizations.dart';
import 'package:wasla/core/functions/toast_alert.dart';
import 'package:wasla/core/responsive/size_config.dart';
import 'package:wasla/core/widgets/custom_date_picker_widget.dart';
import 'package:wasla/core/widgets/general_button.dart';
import 'package:wasla/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:wasla/features/doctor_service/features/service/presentation/widgets/custom_choose_time_widget.dart';
import 'package:wasla/features/resident_service/features/technicain/presentation/manager/cubit/resident_technician_cubit.dart';

class ResidentTechnicalBookViewBody extends StatelessWidget {
  const ResidentTechnicalBookViewBody({super.key, required this.technicianId});
  final String technicianId;

  @override
  Widget build(BuildContext context) {
    final double space = SizeConfig.isTablet ? 20.0 : 14.0;
    final double vSpace = SizeConfig.isTablet ? 25.0 : 15.0;
    context.read<ResidentTechnicianCubit>().reset();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space),
      child: Column(
        children: [
          CustomDatePickerWidget(
            currentDate: DateTime.now(),
            onDateChange: (date) => context
                .read<ResidentTechnicianCubit>()
                .updateSelectedDate(date: date),
          ),
          SizedBox(height: vSpace),
          BlocBuilder<ResidentTechnicianCubit, ResidentTechnicianState>(
            buildWhen: (previous, current) =>
                current is ResidentTechnicianSelectTimeSlot,
            builder: (context, state) {
              return CustomChooseTimeWidget(
                text: 'time'.tr(context),
                dateChange: (time) {
                  context
                      .read<ResidentTechnicianCubit>()
                      .updateSelectedTimeSlot(time: time);
                },
                selectedTime: context
                    .read<ResidentTechnicianCubit>()
                    .selectedTimeSlot,
              );
            },
          ),
          SizedBox(height: vSpace),

          Form(
            key: formKey,
            child: CustomTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'fieldRequired'.tr(context);
                } else if (double.tryParse(value)! <= 0) {
                  return 'invalidPrice'.tr(context);
                }
                return null;
              },
              keyboardTyp: TextInputType.number,
              withTitle: true,
              title: 'price'.tr(context),
              hint: 'price'.tr(context),
              withBorder: true,
              onChanged: (value) {
                context.read<ResidentTechnicianCubit>().price = double.parse(
                  value,
                );
              },
            ),
          ),

          const Spacer(),
          BlocConsumer<ResidentTechnicianCubit, ResidentTechnicianState>(
            listener: (context, state) {
              if (state is ResidentBookWithTechnicianFailure) {
                showToast(state.errMsg, color: Colors.red);
              } else if (state is ResidentBookWithTechnicianSuccess) {
                showToast('bookingDone'.tr(context), color: Colors.green);
              }
            },
            builder: (context, state) {
              return GeneralButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<ResidentTechnicianCubit>().bookWithTechnician(
                      technicianId: technicianId,
                    );
                  }
                },
                text: state is ResidentBookWithTechnicianLoading
                    ? 'loading'.tr(context)
                    : 'bookNow'.tr(context),
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom > 0 ? 0 : vSpace,
          ),
        ],
      ),
    );
  }
}
