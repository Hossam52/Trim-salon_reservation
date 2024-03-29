import 'package:flutter/material.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/modules/home/widgets/build_stars.dart';
import 'package:trim/general_widgets/trim_cached_image.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';
import '../models/rater_model.dart';

class RaterItem extends StatelessWidget {
  final RateModel rater;
  const RaterItem({
    Key key,
    @required this.rater,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      responsiveWidget: (context, deviceInfo) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: TrimCachedImage(src: rater.image),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(rater.createdAt),
                          Text(
                            rater.user,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: defaultFontSize(deviceInfo)),
                          ),
                        ],
                      ),
                      BuildStars(
                          stars: rater.rate,
                          width: deviceInfo.localWidth / 1.8),
                      Container(
                        child: SingleChildScrollView(
                          child: Text(
                            rater.comment,
                            style: TextStyle(
                                fontSize: defaultFontSize(deviceInfo)),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
