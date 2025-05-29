import 'package:flutter/material.dart';

enum Mood {
  veryHappy('😄', Colors.green, 5, 'খুব আনন্দিত'),
  happy('🙂', Colors.lightGreen, 4, 'আনন্দিত'),
  neutral('😐', Colors.grey, 3, 'মিশ্র অনুভূতি'),
  sad('🙁', Colors.blue, 2, 'দুঃখিত'),
  verySad('😢', Colors.indigo, 1, 'অত্যন্ত দুঃখিত'),
  anxious('😟', Colors.deepPurple, 2, 'উদ্বিগ্ন'),
  angry('😠', Colors.red, 2, 'রাগান্বিত'),
  tired('😩', Colors.brown, 2, 'ক্লান্ত'),
  sick('🤒', Colors.teal, 2, 'অসুস্থ'),
  calm('😌', Colors.cyan, 4, 'শান্ত');

  final String emoji;
  final Color color;
  final int score;
  final String title;

  const Mood(this.emoji, this.color, this.score, this.title);
}
