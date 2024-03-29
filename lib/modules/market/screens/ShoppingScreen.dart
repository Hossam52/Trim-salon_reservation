import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trim/appLocale/translatedWord.dart';
import 'package:trim/general_widgets/trim_loading_widget.dart';
import 'package:trim/modules/market/cubit/cart_cubit.dart';
import 'package:trim/modules/market/cubit/cart_events.dart';
import 'package:trim/modules/market/cubit/categories_cubit.dart';
import 'package:trim/modules/market/cubit/categories_events.dart';
import 'package:trim/modules/market/cubit/categories_states.dart';
import 'package:trim/modules/market/models/Category.dart';
import 'package:trim/modules/market/screens/CategoryProductsScreen.dart';
import 'package:trim/modules/market/widgets/cart.dart';
import 'package:trim/modules/market/widgets/category_item.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';
import 'package:trim/utils/ui/Core/Enums/DeviceType.dart';
import 'package:trim/utils/ui/Core/Models/DeviceInfo.dart';
import 'package:trim/general_widgets/BuildSearchWidget.dart';

class ShoppingScreen extends StatefulWidget {
  static final routeName = 'shoppingScreen';

  const ShoppingScreen({
    Key key,
  }) : super(key: key);

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  CartBloc cartBloc;
  AllCategoriesBloc allCategoriesBloc;
  @override
  void initState() {
    cartBloc = BlocProvider.of<CartBloc>(context);
    allCategoriesBloc = BlocProvider.of<AllCategoriesBloc>(context);
    allCategoriesBloc.add(CategoriesFetchDataFromApi());
    cartBloc.add(CartItemsEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ResponsiveWidget(
            responsiveWidget: (context, deviceInfo) {
              print(deviceInfo.type);
              return Container(
                height: deviceInfo.localHeight,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: buildHeader(),
                    ),
                    Expanded(
                      child: BlocBuilder<AllCategoriesBloc, CategoriesStates>(
                          builder: (_, state) {
                        if (state is LoadingState || state is InitialState)
                          return TrimLoadingWidget();
                        else if (state is LoadedState) {
                          List<Category> categoriess = state.categories;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: buildRefershIndicatorCategories(
                              child: buildCategories(deviceInfo, categoriess),
                            ),
                          );
                        } else
                          return buildRefershIndicatorCategories(
                              child: Center(
                                  child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Container(
                              height: deviceInfo.localHeight * 0.5,
                              child: Text(translatedWord(
                                  'Please Make sure from internet connection',
                                  context)),
                            ),
                          )));
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildRefershIndicatorCategories({Widget child}) {
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          allCategoriesBloc.add(CategoriesFetchDataFromApi());
        });
  }

  Widget buildCategories(DeviceInfo deviceInfo, List<Category> categoriess) {
    return GridView.builder(
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          //  widget.setCategoryIndex(index);
          Navigator.pushNamed(
            context,
            CategoryProductsScreen.routeName,
            arguments: {
              'key': isArabic
                  ? categoriess[index].nameAr
                  : categoriess[index].nameEn,
              'value': categoriess[index].id
            },
          );
        },
        child:
            CategoryItem(category: categoriess[index], deviceInfo: deviceInfo),
      ),
      itemCount: categoriess.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          childAspectRatio: deviceInfo.type == deviceType.mobile ? 0.78 : 1.4,
          mainAxisSpacing: 10),
    );
  }

  Row buildHeader() {
    return Row(
      children: [
        Cart(),
        Expanded(
          child: BuildSearchWidget(
            onChanged: (value) async {
              allCategoriesBloc.add(SearchedCategories(searchedWord: value));
            },
          ),
        ),
      ],
    );
  }
}
