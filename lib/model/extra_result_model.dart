// model/extra_result_model.dart

import 'result_model.dart';

class ExtraResultModel {
  final String title;
  final String route;
  final List<ResultModel> resultModels;
  final List<int> scores;
  final Map<int, int> scoreMap;

  ExtraResultModel({
    required this.title,
    required this.route,
    required this.resultModels,
    required this.scores,
    required this.scoreMap,
  });
}
