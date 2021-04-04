import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/InfoWidget.dart';
import 'package:trim/utils/ui/Core/Enums/DeviceType.dart';
import 'package:trim/utils/ui/Core/Models/DeviceInfo.dart';

class TrimStarsScreen extends StatelessWidget {
  static final String routeName = 'TrimStarsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: InfoWidget(
            responsiveWidget: (context, deviceInfo) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: (deviceInfo.localHeight / 11),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                print('Enter Here');
                              },
                              child: Container(
                                  width: deviceInfo.localWidth,
                                  height: deviceInfo.orientation ==
                                          Orientation.portrait
                                      ? deviceInfo.localHeight / 4.5
                                      : deviceInfo.localHeight / 2.5,
                                  child: buildTrimStarItem()),
                            )),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

double getFontSize(DeviceInfo deviceInfo) {
  return deviceInfo.type == deviceType.mobile
      ? 20
      : deviceInfo.type == deviceType.tablet
          ? 35
          : 45;
}

Widget buildTrimStarItem() {
  return InfoWidget(
    responsiveWidget: (context, deviceInfo) {
      print(deviceInfo.type);
      return Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/1.jpg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'احمد محمد',
                      style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: getFontSize(deviceInfo)),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      height: deviceInfo.orientation == Orientation.portrait
                          ? deviceInfo.localHeight / 6
                          : deviceInfo.localHeight / 5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          padding: EdgeInsets.zero,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.all(2),
                                child: Image.asset(
                                  'assets/icons/star.png',
                                  fit: BoxFit.fill,
                                ),
                              )),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Text(
                            'واحد من افضل الصالونات من حيث العناية والنظافة',
                            style: TextStyle(fontSize: getFontSize(deviceInfo)),
                            textDirection: TextDirection.rtl,
                          ),
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
