import 'package:trim/modules/market/models/Category.dart';

abstract class CategoriesStates {}

class InitialState extends CategoriesStates {}

class LoadedState extends CategoriesStates {
  final List<Category> categories;
  LoadedState(this.categories);
}

class LoadingState extends CategoriesStates {}

class ErrorStateCategories extends CategoriesStates {}
