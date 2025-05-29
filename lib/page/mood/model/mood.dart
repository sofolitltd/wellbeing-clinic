import 'package:flutter/material.dart';

enum Mood {
  veryHappy('😄', Colors.green, 5.0, 'খুব আনন্দিত'),
  happy('🙂', Colors.lightGreen, 4.0, 'আনন্দিত'),
  neutral('😐', Colors.grey, 3.0, 'মিশ্র অনুভূতি'),
  sad('🙁', Colors.blue, 2.0, 'দুঃখিত'),
  verySad('😢', Colors.indigo, 1.0, 'অত্যন্ত দুঃখিত'),
  anxious('😟', Colors.deepPurple, 1.5, 'উদ্বিগ্ন'),
  angry('😠', Colors.red, 1.8, 'রাগান্বিত'),
  tired('😩', Colors.brown, 2.2, 'ক্লান্ত'),
  sick('🤒', Colors.teal, 2.5, 'অসুস্থ'),
  calm('😌', Colors.cyan, 3.5, 'শান্ত');

  final String emoji;
  final Color color;
  final double score;
  final String title;

  const Mood(this.emoji, this.color, this.score, this.title);
}
