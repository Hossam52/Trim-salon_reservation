import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:trim/constants/asset_path.dart';
import 'package:trim/modules/home/models/Salon.dart';
import 'package:trim/modules/home/models/availableCities.dart';
import 'package:trim/modules/home/widgets/build_stars.dart';
import 'package:trim/widgets/BuildAlertDialog.dart';
import 'package:trim/modules/home/screens/salon_detail_screen.dart';
import 'package:trim/widgets/BuildSearchWidget.dart';
import 'package:trim/widgets/default_button.dart';

class SalonsScreen extends StatefulWidget {
  static final String routeName = 'salonScreen';
  @override
  _SalonsScreenState createState() => _SalonsScreenState();
}

class _SalonsScreenState extends State<SalonsScreen> {
  String selectedCity = 'all';
  List<Salon> filterSalonsData = [];
  List<Salon> filterSalons() {
    filterSalonsData = salonsData
        .where((element) => element.salonLocation == selectedCity)
        .toList();
    return filterSalonsData;
  }

  Future<void> showCities(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return BuildAlertDialog(
            child: BuildCitiesRadio(),
          );
        }).then((value) {
      if (value != null) //selected one
        selectedCity = value;

      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, bool>;
    bool hasBackButton = arguments != null ? arguments['hasBackButton'] : null;
    return Scaffold(
      appBar: hasBackButton != null
          ? AppBar(
              backgroundColor: Colors.blue[800],
              title: Text('All Salons'),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await showCities(context);
                      setState(() {
                        filterSalons();
                      });
                    },
                    child: Image.asset('assets/icons/settings-icon.png'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: Colors.cyan, width: 1)),
                      ),
                    ),
                  ),
                  BuildSearchWidget(
                    pressed: () {},
                  ),
                ],
              ),
              Container(
                child: Expanded(
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: selectedCity != 'all'
                          ? filterSalonsData.length
                          : salonsData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.84,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemBuilder: (context, index) => BuildItemGrid(
                            salon: selectedCity != 'all'
                                ? filterSalonsData[index]
                                : salonsData[index],
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildItemGrid extends StatelessWidget {
  final Salon salon;
  BuildItemGrid({this.salon});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('pressed');
        Navigator.pushNamed(context, SalonDetailScreen.routeName,
            arguments: salon);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/${salon.imagePath}.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FittedBox(
                      child: Container(
                        child: Text(
                          salon.salonName,
                          style: TextStyle(
                              color: Colors.cyan,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.9),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).scale(14),
                      child: BuildStars(
                          stars: salon.salonRate,
                          width: MediaQuery.of(context).size.width / 2),
                    ),
                    Text(
                      salon.salonStatus ? 'Open now' : 'Closed now',
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.9),
                          color: salon.salonStatus ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BuildCitiesRadio extends StatefulWidget {
  @override
  _BuildCitiesRadioState createState() => _BuildCitiesRadioState();
}

class _BuildCitiesRadioState extends State<BuildCitiesRadio> {
  String selectedCity = availableCities[0];
  List<Widget> buildSelectedCity() {
    List<Widget> widgets = [];
    for (String city in availableCities) {
      widgets.add(
        ListTile(
          onTap: () {
            setState(() {
              selectedCity = city;
            });
          },
          leading: Radio<String>(
            value: city,
            groupValue: selectedCity,
            onChanged: (value) {
              setState(() {
                selectedCity = value;
              });
            },
          ),
          title: Text(city),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...buildSelectedCity(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: DefaultButton(
              text: 'Search now',
              onPressed: () {
                Navigator.pop(context, selectedCity);
              },
              color: Colors.black,
            )),
      ],
    );
  }
}
