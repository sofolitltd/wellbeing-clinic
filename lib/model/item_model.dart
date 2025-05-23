import 'scale_model.dart';

class ItemModel {
  final int id;
  final String title;
  final List<ScaleModel> scale;

  ItemModel({
    required this.id,
    required this.title,
    required this.scale,
  });
}
