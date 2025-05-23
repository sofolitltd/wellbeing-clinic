import 'package:flutter/material.dart';

import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/scale_model.dart';

class Insomnia {
  //
  static String title = 'Insomnia';
  static String slug = 'Insomnia';
  static String route = 'insomnia';
  static String author = 'Developed by: Charles M. Morin (1993)\n'
      'Adapted by: Md. Sayeed Akhter & Naima Nigar, University of Dhaka (2014)';

  //
  static String about =
      'ঘুমের সমস্যা বা ইনসমনিয়ার মাত্রা নির্ধারণে এই স্কেলটি ব্যবহৃত হয়। এটি ঘুমে যাওয়ার সমস্যা, ঘুম ধরে রাখার অসুবিধা এবং সামগ্রিক ঘুমের গুণগত মান মূল্যায়ন করে। এই স্কেলটি ঘুমের ঘাটতির কারণে দৈনন্দিন জীবনে কী ধরনের প্রভাব পড়ছে তা বোঝাতে সহায়তা করে এবং প্রয়োজনে চিকিৎসা বা পরামর্শ গ্রহণের প্রয়োজনীয়তা চিহ্নিত করতে সাহায্য করে।';

  //
  static String instruction =
      'অনুগ্রহ করে, গত ২ সপ্তাহকে বিবেচনায় রেখে নিচের প্রশ্নগুলোর উত্তর দিন। প্রতিটি প্রশ্নের জন্য যে উত্তরটি আপনাকে সর্বোত্তমভাবে বর্ণনা করে এমন উত্তরটিতে ক্লিক করুন।';

  //
  static List<ItemModel> items = [
    ItemModel(
      id: 1,
      title: 'ঠিক সময়ে ঘুমাতে সমস্যা হচ্ছে কিনা?',
      scale: scale123,
    ),
    ItemModel(
      id: 2,
      title: 'বারবার ঘুম ভেঙ্গে যাচ্ছে কিনা?',
      scale: scale123,
    ),
    ItemModel(
      id: 3,
      title: 'স্বাভাবিকের চেয়ে অল্প সময় ঘুমাচ্ছেন কিনা?',
      scale: scale123,
    ),
    ItemModel(
      id: 4,
      title: 'আপনার ঘুমের বর্তমান অবস্থা নিয়ে আপনি কতটুকু সন্তুষ্ট?',
      scale: scale4,
    ),
    ItemModel(
      id: 5,
      title:
          'আপনার ঘুমের সমস্যা যে জীবনকে একটু একটু করে পরিবর্তন করে ফেলছে তা অন্যদের কাছে কতটা লক্ষণীয় বলে মনে করেন?',
      scale: scale5,
    ),
    ItemModel(
      id: 6,
      title: 'আপনার বর্তমান ঘুমের সমস্যা নিয়ে আপনি কতটা চিন্তিত বা উদ্বিগ্ন?',
      scale: scale6,
    ),
    ItemModel(
      id: 7,
      title:
          'আপনার ঘুমের সমস্যা দিনের স্বাভাবিক কাজকর্মে, চিন্তাভাবনায়, বা স্মৃতিশক্তিতে কতখানি প্রভাব ফেলছে বলে মনে করেন?',
      scale: scale7,
    ),
  ];

  // 123
  static List<ScaleModel> scale123 = [
    ScaleModel(0, 'একেবারেই না'),
    ScaleModel(1, 'খুব সামান্য'),
    ScaleModel(2, 'মাঝে মাঝে'),
    ScaleModel(3, 'প্রায় সময়'),
    ScaleModel(4, 'সব সময়'),
  ];

  // 4
  static List<ScaleModel> scale4 = [
    ScaleModel(0, 'খুব সন্তুষ্ট'),
    ScaleModel(1, 'সন্তুষ্ট'),
    ScaleModel(2, 'মোটামুটি সন্তুষ্ট'),
    ScaleModel(3, 'অসন্তুষ্ট'),
    ScaleModel(4, 'খুব অসন্তুষ্ট'),
  ];

  // 5
  static List<ScaleModel> scale5 = [
    ScaleModel(0, 'একেবারেই লক্ষণীয় নয়'),
    ScaleModel(1, 'সামান্য'),
    ScaleModel(2, 'কিছুটা'),
    ScaleModel(3, 'অনেক'),
    ScaleModel(4, 'খুব বেশি লক্ষণীয়'),
  ];

  // 6
  static List<ScaleModel> scale6 = [
    ScaleModel(0, 'একেবারেই চিন্তিত নয়'),
    ScaleModel(1, 'সামান্য'),
    ScaleModel(2, 'কিছুটা'),
    ScaleModel(3, 'অনেক'),
    ScaleModel(4, 'খুব চিন্তিত'),
  ];

  // 7
  static List<ScaleModel> scale7 = [
    ScaleModel(0, 'একেবারেই প্রভাব ফেলছে না'),
    ScaleModel(1, 'সামান্য'),
    ScaleModel(2, 'কিছুটা'),
    ScaleModel(3, 'অনেক'),
    ScaleModel(4, 'অনেক বেশি প্রভাব ফেলছে'),
  ];

  //
  static ResultModel calculateResult(int score) {
    if (score.clamp(0, 7) == score) {
      return Insomnia.result[0];
    } else if (score.clamp(8, 14) == score) {
      return Insomnia.result[1];
    } else if (score.clamp(15, 21) == score) {
      return Insomnia.result[2];
    } else if (score.clamp(22, 28) == score) {
      return Insomnia.result[3];
    } else {
      return ResultModel.empty();
    }
  }

  //
  static final List<ResultModel> result = [
    ResultModel(
      status: 'Absence of Insomnia',
      color: Colors.green,
      interpretation:
          'আপনার ঘুমে কোনো সমস্যা নেই। আপনার ঘুমাতে যেতে বা ঘুমের মধ্যে তেমন কোনো অসুবিধা হয় না।',
      suggestions: '১. স্বাস্থ্যকর ঘুমের রুটিন বজায় রাখুন।\n'
          '২. চাপের স্তর নিয়ন্ত্রণে রাখুন, যেমন ধ্যান বা মাইন্ডফুলনেসের মতো শিথিলকরণ কৌশল অনুশীলন করুন।\n'
          '৩. প্রতিদিন পর্যাপ্ত সময় ধরে শারীরিক কার্যকলাপ করুন, যা আপনার ঘুমের গুণগত মান বাড়াতে সাহায্য করবে।',
    ),
    ResultModel(
      status: 'Mild Insomnia',
      color: Colors.amber,
      interpretation:
          'আপনার সামান্য ইনসমনিয়া আছে। আপনাকে ঠিকভাবে ঘুমাতে যথেষ্ট বেগ পেতে হয়। এছাড়াও দিনে আপনি পরিমিত ঘুমাতে পারছেন না।',
      suggestions:
          '১. একটি নির্দিষ্ট ঘুমের সময়সূচী তৈরি করার চেষ্টা করুন, প্রতিদিন একই সময়ে বিছানায় যাওয়ার এবং উঠার জন্য।\n'
          '২. শোয়ার আগে ক্যাফেইন বা উত্তেজক কার্যকলাপ এড়িয়ে চলুন।\n'
          '৩. ঘুমানোর আগে শিথিলকরণ কৌশল অনুশীলন করুন যেমন গভীর শ্বাস প্রশ্বাস বা প্রগ্রেসিভ মাসল রিলাক্সেশন।',
    ),
    ResultModel(
      status: 'Moderate Insomnia',
      color: Colors.orange,
      interpretation:
          'আপনার প্রায়ই অনিদ্রাজনিত সমস্যায় ভুগছেন। অপরিমিত ঘুম এবং ঘুমাতে যেতে আপনার অনেক বেগ পেতে হচ্ছে। এর ফলে আপনার সামাজিক এবং কর্মক্ষেত্রে অসুবিধা হচ্ছে।',
      suggestions:
          '১. বিছানায় যাওয়ার এক ঘণ্টা আগে স্ক্রীন টাইম (ফোন, কম্পিউটার) সীমিত করার চেষ্টা করুন।\n'
          '২. অনিদ্রার জন্য কগনিটিভ বিহেভিয়ারাল থেরাপি (CBT-I) অনুশীলন করার কথা ভাবুন।\n'
          '৩. নিয়মিত শারীরিক কার্যকলাপে অংশগ্রহণ করুন, তবে ঘুমানোর কাছাকাছি তীব্র ব্যায়াম এড়িয়ে চলুন।',
    ),
    ResultModel(
      status: 'Severe Insomnia',
      color: Colors.red,
      interpretation:
          'আপনি প্রচন্ড অনিদ্রায় ভুগছেন। আপনার পরিমিত এবং ভালো ঘুম হচ্ছে না। এর ফলে আপনার সামাজিক এবং কর্মক্ষেত্র ব্যাপকভাবে ব্যাহত হচ্ছে।',
      suggestions:
          '১. একটি ঘুম বিশেষজ্ঞ বা থেরাপিস্টের কাছ থেকে পেশাদার সহায়তা নিন, কারণ অনিদ্রার কারণগুলি মূল্যায়ন করা প্রয়োজন।\n'
          '২. স্বল্পমেয়াদী উপশমের জন্য স্বাস্থ্যসেবার পেশাদারের মাধ্যমে ওষুধ নেওয়ার পরামর্শ দেওয়া হতে পারে।\n'
          '৩. একটি শান্ত, অন্ধকার, এবং শান্তিপূর্ণ শোয়ার পরিবেশ তৈরি করুন। আপনার দৈনিক রুটিনে শিথিলকরণ কৌশল অন্তর্ভুক্ত করুন এবং মাইন্ডফুলনেস অনুশীলন করতে পারেন।',
    ),
  ];
}
