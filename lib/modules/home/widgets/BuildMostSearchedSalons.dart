import 'package:flutter/material.dart';
import 'package:trim/modules/home/cubit/home_cubit.dart';
import 'package:trim/modules/home/cubit/salons_cubit.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';
import 'package:trim/general_widgets/trim_cached_image.dart';

class BuildMostSearchedSalons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mostSearcedList = HomeCubit.getInstance(context).mostSearchedSalons;
    return ResponsiveWidget(
      responsiveWidget: (context, deviceInfo) {
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(2),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              SalonsCubit.getInstance(context).navigateToSalonDetailScreen(
                  context, mostSearcedList[index].id);
              return;
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: TrimCachedImage(src: mostSearcedList[index].image),
            ),
          ),
          itemCount: mostSearcedList.length < 6 ? mostSearcedList.length : 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 4,
            childAspectRatio:
                (deviceInfo.localWidth / (deviceInfo.localHeight) / 1.5),
          ),
        );
      },
    );
  }
}
