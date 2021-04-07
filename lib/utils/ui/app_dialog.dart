//for Custom app dialogs

import 'package:flutter/material.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/constants/asset_path.dart';
import 'package:trim/modules/home/models/barber.dart';

Widget elevatedButton(String text, [Color color = Colors.blue]) {
  return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(roundedRadius))),
          ),
          onPressed: () {},
          child: Text(text)));
}

void personDetailsDialog(BuildContext context, Barber barber) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(barber.image)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(barber.name),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    child: index > barber.stars
                                        ? Icon(Icons.star_outline_sharp,
                                            size: 20)
                                        : Image.asset(
                                            starIcon,
                                            fit: BoxFit.fill,
                                            scale: 0.6,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Text('${barber.noOfRaters} Openion')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                elevatedButton('Reserve now'),
                elevatedButton('Reserve appointment', Colors.black),
              ],
            ),
          ),
        );
      });
}
