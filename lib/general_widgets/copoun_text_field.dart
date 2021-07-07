import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trim/appLocale/getWord.dart';
import 'package:trim/constants/api_path.dart';
import 'package:trim/utils/services/rest_api_service.dart';

class CoupounTextField extends StatelessWidget {
  final bool enabled;
  final TextEditingController controller;
  final void Function(bool correctCopon, int discount) updateUi;
  const CoupounTextField(
      {Key key,
      @required this.enabled,
      @required this.controller,
      @required this.updateUi})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(child: Text(getWord('Coupone', context))),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextFormField(
                onEditingComplete: () async {
                  FocusScope.of(context).unfocus();
                  try {
                    FocusScope.of(context).unfocus();
                    if (controller.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: getWord('Pleas Enter coupoun code', context));
                    } else {
                      final response =
                          await DioHelper.postData(url: couponeUrl, body: {
                        'code': controller.text,
                      });
                      if (!response.data['success']) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(isArabic
                                ? 'الكوبون غير متاح'
                                : 'Coupone not  available')));
                        Fluttertoast.showToast(
                            msg: isArabic
                                ? 'الكوبون غير متاح'
                                : response.data['message']);
                      } else {
                        updateUi(true,
                            int.tryParse(response.data['data']['price']) ?? 0);
                      }
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: getWord(
                            'Please Make sure from internet connection',
                            context));
                  }
                },
                controller: controller,
                decoration: InputDecoration(
                  hintText: getWord('coupon code', context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}