import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:trim/appLocale/translatedWord.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/constants/asset_path.dart';
import 'package:trim/general_widgets/retry_widget.dart';
import 'package:trim/general_widgets/trim_loading_widget.dart';
import 'package:trim/modules/home/cubit/salons_cubit.dart';
import 'package:trim/modules/home/cubit/salons_states.dart';
import 'package:trim/modules/home/models/Salon.dart';
import 'package:trim/modules/home/screens/raters_screen.dart';
import 'package:trim/modules/home/screens/reserve_screen.dart';
import 'package:trim/modules/home/widgets/build_stars.dart';
import 'package:trim/modules/home/widgets/salon_logo.dart';
import 'package:trim/modules/home/widgets/salon_offers.dart';
import 'package:trim/modules/home/widgets/salon_services.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';
import 'package:trim/utils/ui/Core/Enums/DeviceType.dart';
import 'package:trim/utils/ui/Core/Models/DeviceInfo.dart';
import 'package:trim/modules/home/models/salon_detail_model.dart';
import 'package:trim/general_widgets/default_button.dart';

import '../../../constants/app_constant.dart';

class DetailsScreen extends StatelessWidget {
  static const String routeName = '/salon-detail';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: BlocConsumer<SalonsCubit, SalonStates>(
          listener: (_, state) {},
          builder: (_, state) {
            if (state is LoadingSalonDetailState) return TrimLoadingWidget();
            if (state is ErrorSalonState)
              return RetryWidget(
                  text: translatedWord('Error happened', context) +
                      ' : ' +
                      state.error,
                  onRetry: () => SalonsCubit.getInstance(context)
                      .getSalonDetails(
                          id: SalonsCubit.getInstance(context).lastSalonId));

            Salon salon = SalonsCubit.getInstance(context).salonDetail;
            return ResponsiveWidget(
              responsiveWidget: (context, deviceInfo) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        SalonLogo(
                          showBottomName: true,
                          salon: salon,
                          deviceInfo: deviceInfo,
                          height: deviceInfo.orientation == Orientation.portrait
                              ? deviceInfo.localHeight * 0.3
                              : deviceInfo.localHeight * 0.6,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 18.0),
                          height: MediaQuery.of(context).size.height * 0.14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Openions(
                                    deviceInfo: deviceInfo,
                                    salon: salon,
                                  ),
                                  flex: 2),
                              Expanded(
                                  child: availabilityTime(
                                      context, deviceInfo, salon)),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: addressWidget(
                                      context, deviceInfo, salon.address),
                                  flex: 3),
                              Expanded(
                                  child: directionWidget(
                                      context, salon, deviceInfo))
                            ],
                          ),
                        ),
                        SalonServices(
                            onItemToggled: SalonsCubit.getInstance(context)
                                .toggelSelectedService,
                            services: salon.salonServices,
                            bottomWidget: reserveButton(context, deviceInfo),
                            deviceInfo: deviceInfo),
                        SalonOffers(deviceInfo, salon.salonOffers),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget reserveButton(context, DeviceInfo deviceInfo) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: deviceInfo.localWidth / 5, vertical: 8.0),
        child: DefaultButton(
          color: Colors.black,
          textColor: Colors.white,
          onPressed: () => reserveSalon(context, deviceInfo),
          text: translatedWord('Reserve now', context), //'Reserve now',
        ));
  }

  void reserveSalon(context, DeviceInfo deviceInfo) {
    SalonsCubit.getInstance(context)
        .getAvilableDates(SalonsCubit.getInstance(context).reservationDate);
    Navigator.pushNamed(context, ReserveScreen.routeName,
        arguments: SalonDetailModel(
            showCopounWidget: true,
            showDateWidget: true,
            showAvailableTimes: true,
            showOffersWidget: true,
            showServiceWidget: false));
  }

  Widget addressWidget(
      BuildContext context, DeviceInfo deviceInfo, String address) {
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              if (address.isNotEmpty)
                ImageIcon(
                  AssetImage(pinIcon),
                ),
              Expanded(
                  child: Text(
                address.isEmpty
                    ? translatedWord("No Address is provided", context)
                    : address,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: true),
                style: TextStyle(
                  color: address.isEmpty ? Colors.red : null,
                  fontWeight: FontWeight.bold,
                  fontSize: defaultFontSize(deviceInfo),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget directionWidget(
      BuildContext context, Salon salon, DeviceInfo deviceInfo) {
    return InkWell(
      child: Card(
        elevation: 10,
        child: InkWell(
          onTap: () async {
            if (salon.lat == null ||
                salon.lat == 0 ||
                salon.lang == null ||
                salon.lang == 0) {
              Fluttertoast.showToast(
                  msg: 'Location for salon ${salon.name} is not provided');
            } else
              await MapsLauncher.launchCoordinates(salon.lat ?? 0,
                  salon.lang ?? 0, 'Google Headquarters are here');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ImageIcon(
                  AssetImage(locationIcon),
                  color: Colors.blue,
                  size: 50,
                ),
                FittedBox(
                  child: Text(
                    translatedWord('Get directions', context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: defaultFontSize(deviceInfo)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget availabilityTime(
      BuildContext context, DeviceInfo deviceInfo, Salon salon) {
    final fontSize = deviceInfo.localWidth *
        (deviceInfo.type == deviceType.mobile ? 0.14 * 0.25 : 0.11 * 0.25);
    final openFrom = salon.openFrom == "" ? 'N/A' : salon.openFrom;
    final openTo = salon.openTo == "" ? "N/A" : salon.openTo;
    final to = translatedWord('To', context);

    final String openingStatus = salon.status;
    final bool isClosed = openingStatus.toLowerCase() == 'closed';
    Widget closedWidget() {
      return Center(
        child: Text(
          openingStatus,
          style: TextStyle(
            color: Colors.red,
            fontSize: defaultFontSize(deviceInfo) * 0.85,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Widget openWidget() {
      return FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(
              translatedWord('Open', context),
              style: TextStyle(
                color: Colors.green,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('$openFrom $to $openTo',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),
          ]),
        ),
      );
    }

    return Card(elevation: 10, child: isClosed ? closedWidget() : openWidget());
  }
}

class Openions extends StatelessWidget {
  final Salon salon;

  final DeviceInfo deviceInfo;
  const Openions({Key key, this.deviceInfo, @required this.salon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RatersScreen.routeName);
      },
      child: Card(
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: BuildStars(
                  stars: salon.rate,
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 3,
                child: FittedBox(
                  child: Text(
                    '${salon.commentsCount} ' +
                        translatedWord('openions', context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: defaultFontSize(deviceInfo),
                    ),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
