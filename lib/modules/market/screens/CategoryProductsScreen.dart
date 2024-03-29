import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trim/appLocale/translatedWord.dart';
import 'package:trim/constants/app_constant.dart';
import 'package:trim/general_widgets/no_data_widget.dart';
import 'package:trim/general_widgets/trim_loading_widget.dart';
import 'package:trim/general_widgets/trim_cached_image.dart';
import 'package:trim/modules/market/cubit/cart_cubit.dart';
import 'package:trim/modules/market/cubit/cart_events.dart';
import 'package:trim/modules/market/cubit/cart_states.dart';
import 'package:trim/modules/market/cubit/procucts_category_states.dart';
import 'package:trim/modules/market/cubit/products_category_cubit.dart';
import 'package:trim/modules/market/cubit/products_category_events.dart';
import 'package:trim/modules/market/cubit/search_bloc.dart';
import 'package:trim/modules/market/models/Product.dart';
import 'package:trim/modules/market/models/cartItem.dart';
import 'package:trim/modules/market/widgets/cart.dart';
import 'package:trim/utils/ui/Core/BuilderWidget/responsive_widget.dart';
import 'package:trim/utils/ui/Core/Models/DeviceInfo.dart';
import 'package:trim/general_widgets/BuildRawMaterialButton.dart';
import 'package:trim/general_widgets/BuildSearchWidget.dart';

class CategoryProductsScreen extends StatefulWidget {
  static final routeName = 'categoryProductScreen';

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  ProductsCategoryBloc productsBloc;
  CartBloc cartCubit;
  SearchBloc searchBloc;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    productsBloc = BlocProvider.of<ProductsCategoryBloc>(context);
    cartCubit = BlocProvider.of<CartBloc>(context);
    super.initState();
  }

  Map<String, dynamic> categoryDetails = {};
  int categoryId;
  String categorytitle;
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      searchBloc = BlocProvider.of<SearchBloc>(context);
      categoryDetails =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      categoryId = categoryDetails['value'];
      categorytitle = categoryDetails['key'];
      productsBloc.add(FetchDataFromApi(categoryId: categoryId));
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  TextEditingController textEditingController = TextEditingController();
  String searchedString;
  bool isCategory;
  @override
  Widget build(BuildContext context) {
    isCategory = true;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Cart(),
            )
          ],
          centerTitle: true,
          title: Text(categorytitle),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ResponsiveWidget(
              responsiveWidget: (context, deviceInfo) {
                return Column(
                  children: [
                    BuildSearchWidget(
                      onChanged: (value) async {
                        productsBloc.add(Searchedproducts(
                            categoryId: categoryId, searchedWord: value));
                      },
                    ),
                    Expanded(
                      child: BlocBuilder<ProductsCategoryBloc,
                          ProductsCategoryStates>(builder: (_, state) {
                        if (state is InitialState ||
                            state is LoadingStateProductsCategory)
                          return TrimLoadingWidget();
                        else if (state is ErrorStateProductsCategory)
                          return Center(
                              child: buildRefershIndicatorProducts(
                                  child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Container(
                                        height: deviceInfo.localHeight * 0.5,
                                        child: Text(translatedWord(
                                            'Please Make sure from internet connection',
                                            context)),
                                      ))));
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildRefershIndicatorProducts(
                            child: buildProducts(deviceInfo),
                          ),
                        );
                      }),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }

  Widget buildRefershIndicatorProducts({Widget child}) {
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          productsBloc.add(FetchDataFromApi(categoryId: categoryId));
        });
  }

  Widget buildProducts(DeviceInfo deviceInfo) {
    bool isSearch = searchBloc.searchedProducts.isEmpty;
    return BlocConsumer<CartBloc, CartStates>(
      listener: (_, state) {
        isCategoryScreen = true;
        if (state is ErrorStateCart) {
          if (isCategoryScreen) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(translatedWord(
                    'Please Make sure from internet connection', context)),
              ),
            );
          }
        }
      },
      builder: (_, state) {
        if (productsBloc.products.length == 0) return EmptyDataWidget();
        return GridView.builder(
            itemCount: isSearch
                ? productsBloc.products.length
                : searchBloc.searchedProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 7,
              mainAxisSpacing: 10,
              childAspectRatio: 0.47,
            ),
            itemBuilder: (context, index) {
              return BuildProductItem(
                deviceInfo: deviceInfo,
                prodcut: isSearch
                    ? productsBloc.products[index]
                    : searchBloc.searchedProducts[index],
              );
            });
      },
    );
  }
}

class BuildProductItem extends StatefulWidget {
  final DeviceInfo deviceInfo;
  final Product prodcut;
  BuildProductItem({this.deviceInfo, this.prodcut});

  @override
  _BuildProductItemState createState() => _BuildProductItemState();
}

class _BuildProductItemState extends State<BuildProductItem> {
  double fontSize = 0;
  CartBloc cartCubit;
  bool inCategory;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fontSize = defaultFontSize(widget.deviceInfo);
    cartCubit = BlocProvider.of<CartBloc>(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              offset: Offset(0, 2),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 3, child: buildProductImage()),
          Expanded(flex: 2, child: buildProductName()),
          Expanded(child: buildProductPrice()),
          Expanded(child: buildProductActions()),
        ],
      ),
    );
  }

  Widget buildProductActions() {
    bool isEnabled = cartCubit.items.containsKey(widget.prodcut.productId);
    if (isEnabled)
      isEnabled =
          (cartCubit.items[widget.prodcut.productId].quantity ?? '0') == '10';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BuildRawMaterialButton(
          icon: Icons.add,
          pressed: isEnabled
              ? null
              : () async {
                  cartCubit.add(
                    AddingItemEvent(
                        cartItem: CartItem(
                          id: widget.prodcut.productId,
                          imageName: widget.prodcut.productImage,
                          nameAr: widget.prodcut.nameAr,
                          price: widget.prodcut.productPrice,
                          nameEn: widget.prodcut.nameEn,
                        ),
                        screenId: '1'),
                  );
                },
          deviceInfo: widget.deviceInfo,
        ),
        Text(
          '${cartCubit.items.containsKey(widget.prodcut.productId) ? cartCubit.items[widget.prodcut.productId].quantity : 0}',
          style: TextStyle(fontSize: fontSize),
        ),
        BuildRawMaterialButton(
          icon: Icons.remove,
          pressed: () {
            cartCubit.add(
                DecreaseEvent(id: widget.prodcut.productId, screenId: '1'));
          },
          deviceInfo: widget.deviceInfo,
        ),
      ],
    );
  }

  Widget buildProductPrice() {
    return BlocBuilder<CartBloc, CartStates>(
        builder: (_, state) => Text(
            '${cartCubit.items.containsKey(widget.prodcut.productId) ? (double.parse(cartCubit.items[widget.prodcut.productId].price)).toStringAsFixed(2) : double.parse(widget.prodcut.productPrice).toStringAsFixed(2)}',
            style: TextStyle(fontSize: fontSize, color: Colors.green)));
  }

  Widget buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: TrimCachedImage(
        src: widget.prodcut.productImage,
      ),
    );
  }

  Widget buildProductName() {
    return Text(
      isArabic ? widget.prodcut.nameAr : widget.prodcut.nameEn,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(fontSize: fontSize - 4, fontWeight: FontWeight.bold),
    );
  }
}
