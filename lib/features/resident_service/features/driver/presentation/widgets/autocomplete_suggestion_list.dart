import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/features/resident_service/features/driver/presentation/manager/cubit/resident_driver_cubit.dart';

class AutocompleteSuggestionList extends StatelessWidget {
  const AutocompleteSuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResidentDriverCubit, ResidentDriverState>(
      buildWhen: (previous, current) =>
          current is ResidentDriverSearchToPlaceState,
      builder: (context, state) {
        final cubit = context.read<ResidentDriverCubit>();
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey.shade300, height: 30),
          itemCount: cubit.searchedPlaces.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              if (cubit.isFromField) {
                cubit.fromController.text = cubit.searchedPlaces[index].name;
              } else {
                cubit.toController.text = cubit.searchedPlaces[index].name;
              }

              cubit.resetSearchedList(place: cubit.searchedPlaces[index]);
            },
            child: Row(
              spacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.location_on_outlined,
                    size: 23,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    cubit.searchedPlaces.isEmpty
                        ? ''
                        : cubit.searchedPlaces[index].name,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
