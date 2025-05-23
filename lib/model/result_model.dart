import 'package:flutter/material.dart';

class ResultModel {
  final String? title;
  final String status;
  final Color color;
  final String interpretation;
  final String suggestions;

  ResultModel({
    this.title,
    required this.status,
    required this.color,
    required this.interpretation,
    required this.suggestions,
  });

  static ResultModel empty() {
    return ResultModel(
      title: '',
      status: '',
      color: Colors.transparent,
      interpretation: '',
      suggestions: '',
    );
  }
}
