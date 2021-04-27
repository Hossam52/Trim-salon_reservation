import 'package:flutter/material.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/modules/payment/models/StepsCompleteOrder.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/InfoWidget.dart';
import 'package:trim/modules/payment/widgets/build_delivery_widget.dart';
import 'package:trim/modules/payment/widgets/build_details_order_price.dart';
import 'package:trim/general_widgets/default_button.dart';

class ConfirmOrderScreen extends StatefulWidget {
  static final String routeName = 'confirmOrderScreen';

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  int stepNumber = 1;
  String paymentmethod = 'online';
  Color secondaryColor = Color(0xffCBCBCD);
  bool showDetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: InfoWidget(responsiveWidget: (context, deviceInfo) {
        double fontSize = getFontSizeVersion2(deviceInfo);
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // height: deviceInfo.localHeight *
                //     (deviceInfo.orientation == Orientation.portrait
                //         ? 0.15
                //         : .35),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      leading: IconButton(
                        iconSize: deviceInfo.localWidth *
                            (deviceInfo.orientation == Orientation.portrait
                                ? 0.07
                                : 0.06),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                      title: Text(
                        'انهاء الطلب',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 4, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BuildStepOrder(
                            onPressed: () {
                              if (stepNumber != 1)
                                setState(() {
                                  stepNumber = 1;
                                });
                            },
                            label: stepsCompleteOrder[0],
                            textColor:
                                stepNumber != 1 ? secondaryColor : Colors.white,
                            color: stepNumber == 1
                                ? Colors.blue[800]
                                : Colors.white,
                            isActive: true,
                            fontSize: fontSize,
                          ),
                          SizedBox(width: 30),
                          BuildStepOrder(
                            onPressed: () {},
                            label: stepsCompleteOrder[1],
                            textColor:
                                stepNumber != 2 ? secondaryColor : Colors.white,
                            color: stepNumber == 2
                                ? Colors.blue[800]
                                : Colors.white,
                            isActive: stepNumber == 2,
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: stepNumber == 1
                        ? DeliveryWidget(
                            fontSize: fontSize,
                            secondaryColor: secondaryColor,
                            stepNumber: stepNumber,
                            deviceInfo: deviceInfo,
                            pressed: () {
                              if (stepNumber < 3) {
                                setState(() {
                                  stepNumber++;
                                });
                              }
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'اختيار طريقة الدفع',
                                style: TextStyle(fontSize: fontSize),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Radio(
                                    value: 'online',
                                    groupValue: paymentmethod,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentmethod = value;
                                      });
                                    },
                                  ),
                                  title: Text(
                                    'الدفع عن طريق البطاقة الالكترونية',
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                  subtitle: paymentmethod != 'online'
                                      ? Container()
                                      : Text('واحدة من احسن طرق الدفع حاليا'),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Radio(
                                    value: 'cash',
                                    groupValue: paymentmethod,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentmethod = value;
                                      });
                                    },
                                  ),
                                  title: Text('الدفع عند الاستلام',
                                      style: TextStyle(fontSize: fontSize)),
                                  subtitle: paymentmethod != 'cash'
                                      ? Container()
                                      : Text('يتم الدفع عند الاستلام '),
                                ),
                              ),
                              BuildDetailsOrderPrice(
                                  fontSize: fontSize,
                                  pressed: () {
                                    setState(() {
                                      if (stepNumber < 2) stepNumber++;
                                    });
                                  },
                                  deviceInfo: deviceInfo,
                                  stepNumber: stepNumber)
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BuildStepOrder extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String label;
  final double fontSize;
  final bool isActive;
  final VoidCallback onPressed;
  BuildStepOrder(
      {this.label,
      this.color,
      this.fontSize,
      this.textColor,
      this.isActive = false,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultButton(
      color: color,
      fontSize: fontSize - 5,
      textColor: textColor,
      onPressed: isActive == false ? null : onPressed,
      text: label,
    ));

    return Expanded(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize - 5, color: textColor),
        ),
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}