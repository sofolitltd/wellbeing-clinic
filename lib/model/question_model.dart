import 'scale_model.dart';

class Question {
  final int no;
  final String title;
  final String? description;
  final List<ScaleModel> options;
  final String? category;

  Question({
    required this.no,
    required this.title,
    this.description,
    required this.options,
    this.category,
  });
}
