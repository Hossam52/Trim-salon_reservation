import 'package:flutter/material.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/modules/home/models/Salon.dart';
import 'package:trim/modules/home/widgets/favorite_container.dart';
import 'package:trim/utils/ui/Core/Models/DeviceInfo.dart';
import 'package:trim/general_widgets/trim_cached_image.dart';

class SalonLogo extends StatefulWidget {
  final double height;
  final DeviceInfo deviceInfo;
  final Salon salon;
  final bool showBottomName;
  const SalonLogo(
      {Key key,
      @required this.height,
      @required this.deviceInfo,
      @required this.salon,
      @required this.showBottomName})
      : super(key: key);

  @override
  _SalonLogoState createState() => _SalonLogoState();
}

class _SalonLogoState extends State<SalonLogo> {
  bool isPortrait;
  @override
  Widget build(BuildContext context) {
    isPortrait =
        widget.deviceInfo.orientation == Orientation.portrait ? true : false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: widget.height,
        alignment: Alignment.center,
        child: Stack(
          children: [
            TrimCachedImage(src: widget.salon.image),
            Positioned(
                left: widget.deviceInfo.localWidth * (isPortrait ? 0.08 : 0.06),
                child: FavoriteContainer(
                  salonId: widget.salon.id,
                  deviceInfo: widget.deviceInfo,
                  isFavorite: widget.salon.isFavorite,
                )),
            widget.showBottomName
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: buildSalonNameWidget())
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildSalonNameWidget() {
    return Container(
      width: double.infinity,
      color: Colors.grey.withAlpha(150),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.salon.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: defaultFontSize(widget.deviceInfo))),
      ),
    );
  }
}
