import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trim/appLocale/translatedWord.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/general_widgets/no_data_widget.dart';
import 'package:trim/general_widgets/trim_cached_image.dart';
import 'package:trim/modules/market/cubit/cart_cubit.dart';
import 'package:trim/modules/market/cubit/cart_events.dart';
import 'package:trim/modules/market/cubit/cart_states.dart';
import 'package:trim/modules/market/models/cartItem.dart';
import 'package:trim/modules/payment/screens/confirm_order_screen.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';
import 'package:trim/utils/ui/Core/Enums/DeviceType.dart';
import 'package:trim/utils/ui/Core/Models/DeviceInfo.dart';
import 'package:trim/general_widgets/BuildRawMaterialButton.dart';
import 'package:trim/general_widgets/default_button.dart';

class BadgeScrren extends StatelessWidget {
  static String routeName = 'BadgeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kPadding.copyWith(bottom: 2),
          child: Column(
            children: [
              buildBackButton(context),
              Expanded(
                child: ResponsiveWidget(
                  responsiveWidget: (context, deviceInfo) {
                    return BlocConsumer<CartBloc, CartStates>(
                        listener: (ctx, state) {
                      if (state is ErrorStateCartInBadge) {
                        Fluttertoast.showToast(
                            msg: translatedWord(
                                'Please Make sure from internet connection',
                                context));
                      }
                    }, builder: (_, state) {
                      List<CartItem> cartItems =
                          BlocProvider.of<CartBloc>(context).getCartList();
                      if (cartItems.isEmpty) return EmptyDataWidget();
                      return Column(
                        children: [
                          Expanded(
                            flex: deviceInfo.orientation == Orientation.portrait
                                ? 9
                                : 7,
                            child: ListView.separated(
                              itemCount: BlocProvider.of<CartBloc>(context)
                                  .items
                                  .length,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                return ProductItem(
                                  deviceInfo: deviceInfo,
                                  cartItem: cartItems[index],
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: buildConfirmButton(deviceInfo, context),
                          )
                        ],
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Align(
        heightFactor: 1,
        alignment: Alignment.centerLeft,
        child: IconButton(
          iconSize: MediaQuery.of(context).size.width * 0.07,
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            print('success');
            Navigator.pop(context);
          },
        ), // BackButton(color: Colors.black),
      ),
    );
  }

  Widget buildConfirmButton(DeviceInfo deviceInfo, BuildContext context) {
    return Container(
      margin: deviceInfo.orientation == Orientation.portrait
          ? EdgeInsets.only(top: 15)
          : null,
      width: deviceInfo.localWidth / 1.3,
      child: DefaultButton(
        onPressed: () async {
          if (BlocProvider.of<CartBloc>(context).items.length == 0)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(translatedWord(
                    'The cart is empty please enter items', context))));
          else
            Navigator.pushNamed(context, ConfirmOrderScreen.routeName);
        },
        text: translatedWord('Confirm order', context),
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  final CartItem cartItem;
  final DeviceInfo deviceInfo;

  const ProductItem({@required this.cartItem, @required this.deviceInfo});
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  CartBloc cartBloc;
  @override
  void initState() {
    cartBloc = BlocProvider.of<CartBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.deviceInfo.orientation == Orientation.portrait
          ? widget.deviceInfo.localHeight / 4
          : widget.deviceInfo.localHeight / 1.9,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(flex: 2, child: buildProductImage(widget.deviceInfo)),
            Expanded(flex: 3, child: buildProductDetails(widget.deviceInfo)),
            Expanded(
              child: buildTrashIcon(widget.deviceInfo),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductDetails(DeviceInfo deviceInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: buildProductName(deviceInfo)),
        Expanded(child: buildTotalPrice(deviceInfo)),
        Expanded(child: buildActionButtons(deviceInfo)),
      ],
    );
  }

  Widget buildTrashIcon(DeviceInfo deviceInfo) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: IconButton(
        iconSize: deviceInfo.type == deviceType.mobile
            ? deviceInfo.localWidth * 0.09
            : deviceInfo.localWidth * 0.075,
        icon: Icon(
          Icons.delete_outline_sharp,
          color: Colors.redAccent,
        ),
        onPressed: () async {
          bool isDeleted = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(translatedWord('Are you sure to remove item ?', context)),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: translatedWord('undo', context),
              onPressed: () {
                isDeleted = false;
              },
            ),
          ));
          await Future.delayed(Duration(seconds: 3));
          if (isDeleted)
            cartBloc.add(DeleteItemEvent(
                id: widget.cartItem.id,
                rowId: widget.cartItem.rowId,
                screenId: '2'));
        },
      ),
    );
  }

  Widget buildActionButtons(DeviceInfo deviceInfo) {
    bool isEnabled = widget.cartItem.quantity == '10';
    return Row(
      children: [
        BuildRawMaterialButton(
          icon: Icons.add,
          pressed: isEnabled
              ? null
              : () {
                  cartBloc.add(
                    AddingItemEvent(
                        cartItem: CartItem(
                          rowId: widget.cartItem.rowId,
                          id: widget.cartItem.id,
                          imageName: widget.cartItem.imageName,
                          nameAr: widget.cartItem.nameAr,
                          price: widget.cartItem.price,
                          nameEn: widget.cartItem.nameEn,
                          quantity: widget.cartItem.quantity,
                        ),
                        screenId: '2'),
                  );
                },
          deviceInfo: deviceInfo,
        ),
        Text(
          '${widget.cartItem.quantity}',
          style: TextStyle(fontSize: defaultFontSize(deviceInfo) - 5),
        ),
        BuildRawMaterialButton(
          icon: Icons.remove,
          pressed: widget.cartItem.quantity == '1'
              ? null
              : () {
                  cartBloc.add(
                      DecreaseEvent(id: widget.cartItem.id, screenId: '2'));
                },
          deviceInfo: deviceInfo,
        ),
      ],
    );
  }

  Widget buildTotalPrice(DeviceInfo deviceInfo) {
    return FittedBox(
      child: Text(
        translatedWord('total price', context) +
            ': ${double.parse(widget.cartItem.price) * double.parse(widget.cartItem.quantity)}',
        style: TextStyle(
            fontSize: defaultFontSize(deviceInfo) - 13, color: Colors.green),
      ),
    );
  }

  Widget buildProductName(DeviceInfo deviceInfo) {
    return FittedBox(
      child: Text(
        isArabic ? widget.cartItem.nameAr : widget.cartItem.nameEn,
        style: TextStyle(
            fontSize: defaultFontSize(deviceInfo) - 10,
            color: Colors.lightBlue),
      ),
    );
  }

  Widget buildProductImage(DeviceInfo deviceInfo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: TrimCachedImage(
        src: widget.cartItem.imageName,
      ),
    );
  }
}
