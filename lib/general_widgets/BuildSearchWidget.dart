import 'package:flutter/material.dart';
import 'package:trim/appLocale/translatedWord.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';

class BuildSearchWidget extends StatelessWidget {
  final Future Function(String value) onChanged;
  final String initialText;
  BuildSearchWidget({this.onChanged, this.initialText});
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = initialText;
    return Form(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: ResponsiveWidget(
          responsiveWidget: (_, deviceInfo) => TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: defaultFontSize(deviceInfo) * 0.8),
              contentPadding: const EdgeInsets.all(0),
              hintText: translatedWord('Search for', context) + ' ...',
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
                size: defaultFontSize(deviceInfo),
              ),
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
