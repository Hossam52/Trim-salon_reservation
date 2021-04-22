import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/modules/home/models/Salon.dart';
import 'package:trim/utils/ui/Core/Models/DeviceInfo.dart';

class SalonLogo extends StatefulWidget {
  final double height;
  //final String imagePath;
  //final bool isFavorite;
  final DeviceInfo deviceInfo;
  //final String salonName;
  final Salon salon;
  final bool showBottomName;
  const SalonLogo(
      {Key key,
      @required this.height,
      // @required this.imagePath,
      // @required this.isFavorite,
      @required this.deviceInfo,
      // @required this.salonName,
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
    print(widget.deviceInfo.localWidth);
    // final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;
    isPortrait =
        widget.deviceInfo.orientation == Orientation.portrait ? true : false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: widget.height,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Image.asset(
              widget.salon.imagePath,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Positioned(
              left: widget.deviceInfo.localWidth * (isPortrait ? 0.08 : 0.06),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isPortrait ? 30 : 35),
                      bottomRight: Radius.circular(isPortrait ? 30 : 35)),
                  child: buildFavoriteContainer(widget.deviceInfo.screenWidth,
                      widget.deviceInfo.screenHeight)),
            ),
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

  Widget buildFavoriteContainer(double screenWidth, double screenHeight) {
    final favoriteContainerHeight = widget.height / (isPortrait ? 3.3 : 2.7);
    // final favoriteContainerWidth = screenWidth * 0.13;

    final availableWidth = widget.deviceInfo.localWidth;

    return Container(
      height: favoriteContainerHeight,
      width: availableWidth * 0.09,
      alignment: Alignment.center,
      color: Color(0xffDDD8E1),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: availableWidth * 0.06,
        icon: Icon(
            widget.salon.isFavorite != null && widget.salon.isFavorite
                ? Icons.favorite
                : Icons.favorite_border_outlined,
            color: Color(0xff4678A3)),
        onPressed: () {},
      ),
    );
  }

  Widget buildSalonNameWidget() {
    return Container(
      width: double.infinity,
      color: Colors.grey.withAlpha(150),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.salon.salonName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getFontSize(widget.deviceInfo))),
      ),
    );
  }
}
