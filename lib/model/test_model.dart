import '/model/item_model.dart';

//
class TestModel {
  final String category;
  final String title;
  final String route;
  final String about;
  final String instruction;
  final String author;
  final List<ItemModel> items;

  TestModel({
    required this.category,
    required this.title,
    required this.route,
    required this.about,
    required this.instruction,
    required this.author,
    required this.items,
  });
}
