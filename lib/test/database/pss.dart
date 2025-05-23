import 'package:flutter/material.dart';

import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/scale_model.dart';

class PSS {
  //
  static String title = 'Perceived Stress Scale';
  static String slug = 'perceived-Stress-scale';
  static String route = 'pss';
  static String author = 'Developed by: Cohen, Kamarck & Mermelstein\n'
      'Adapted by: Md. Nurul Islam, Professor, Department of Psychology, CU';

  //
  static String about =
      'এই স্কেলটি জীবনের পরিস্থিতিগুলোকে কতটা চাপপূর্ণ মনে করা হয় তা পরিমাপ করে। এটি মূল্যায়ন করে যে উত্তরদাতারা তাদের জীবনকে কতটা অপ্রত্যাশিত, নিয়ন্ত্রণের বাইরে এবং অতিরিক্ত চাপের মধ্যে অনুভব করছেন, বিশেষ করে গত এক মাসের মধ্যে। এই স্কেলটি গবেষণা ও চিকিৎসা ক্ষেত্রে স্ট্রেস এবং তার মানসিক সুস্থতার ওপর প্রভাব নির্ণয়ের জন্য ব্যাপকভাবে ব্যবহৃত হয়।';

  //
  static String instruction =
      'প্রশ্নে উল্লিখিত অনুভুতি এবং ভাবনাগুলো গত এক মাসে আপনার মধ্যে কি পরিমানে ঘটেছে তা পাঁচটি উত্তরের মধ্যে উপযুক্ত ঘর চিহ্নিত করুন';

  //
  static List<ItemModel> items = [
    ItemModel(
      id: 1,
      title:
          'গত এক মাসে অনাকাঙ্ক্ষিত কোন ঘটনার জন্য আপনি কতটুকু বিপর্যস্ত ছিলেন?',
      scale: scaleP,
    ),
    ItemModel(
        id: 2,
        title:
            'গত এক মাসে আপনি কতটুকু অনুভব করতে পেরেছিলেন যে আপনার জীবনের গুরুত্বপূর্ণ ঘটনাগুলো আপনি নিয়ন্ত্রণ করতে পারছেন না?',
        scale: scaleP),
    ItemModel(
      id: 3,
      title: 'গত এক মাসে আপনি কতটুকু ঘাবড়ে যাওয়া এবং চাপ অনুভব করেছিলেন?',
      scale: scaleP,
    ),
    ItemModel(
      id: 4,
      title:
          'গত এক মাসে আপনার ব্যক্তিগত সমস্যাগুলো নিয়ন্ত্রনের ক্ষেত্রে আপনি কতটুকু আত্মবিশ্বাসী ছিলেন?',
      scale: scaleN,
    ),
    ItemModel(
      id: 5,
      title:
          'গত এক মাসে আপনি কতটুকু অনুভব করেছিলেন যে চলমান ঘটনাগুলো আপনার অনুকূলে যাচ্ছে?',
      scale: scaleN,
    ),
    ItemModel(
      id: 6,
      title:
          'গত এক মাসে আপনি কতটুকু অনুভব করেছিলেন যে আপনার যা করণীয় তা আপনি করতে পারেন নি?',
      scale: scaleP,
    ),
    ItemModel(
      id: 7,
      title:
          'গত এক মাসে আপনি আপনার জীবনের বিরক্তি/তিক্ততা কতটুকু নিয়ন্ত্রন করতে পেরেছিলেন?',
      scale: scaleN,
    ),
    ItemModel(
      id: 8,
      title:
          'গত এক মাসে আপনি কতটুকু অনুভব করেছিলেন যে আপনি সবকিছুর ঊর্ধ্বে? (আপনার প্রাধান্য বেশি)',
      scale: scaleN,
    ),
    ItemModel(
      id: 9,
      title:
          'গত এক মাসে কোন কিছু আপনার নিয়ন্ত্রণের বাইরে যাওয়ার কারনে কতবার আপনি রাগান্বিত হয়েছেন?',
      scale: scaleP,
    ),
    ItemModel(
      id: 10,
      title:
          'গত এক মাসে আপনি কতটুকু অনুভব করেছিলেন যে জীবনের জটিলতাগুলো এতই বড় যে আপনি তা অতিক্রম করতে পারবেন না?',
      scale: scaleP,
    ),
  ];

  //
  static List<ScaleModel> scaleP = [
    ScaleModel(0, 'কখনই না'),
    ScaleModel(1, 'প্রায়ই না'),
    ScaleModel(2, 'মাঝে মাঝে'),
    ScaleModel(3, 'প্রায়শই'),
    ScaleModel(4, 'সব সময়'),
  ];

  static List<ScaleModel> scaleN = [
    ScaleModel(4, 'কখনই না'),
    ScaleModel(3, 'প্রায়ই না'),
    ScaleModel(2, 'মাঝে মাঝে'),
    ScaleModel(1, 'প্রায়শই'),
    ScaleModel(0, 'সব সময়'),
  ];

  //
  static ResultModel calculateResult(int score) {
    if (score.clamp(0, 13) == score) {
      return PSS.result[0]; // Low Stress
    } else if (score.clamp(14, 25) == score) {
      return PSS.result[1]; // Medium Stress
    } else if (score.clamp(26, 40) == score) {
      return PSS.result[2]; // High Stress
    } else {
      return ResultModel.empty();
    }
  }

  //
  static final List<ResultModel> result = [
    ResultModel(
      status: 'Low Stress',
      color: Colors.green,
      interpretation:
          'আপনার স্কোর ইঙ্গিত দেয় যে আপনি কম মানসিক চাপ অনুভব করছেন। তবে, আপনার মানসিক স্বাস্থ্য এবং কল্যাণ আরও উন্নত করার সুযোগ থাকতে পারে। এটি গুরুত্বপূর্ণ যে আপনি নিজেকে সময় দিন এবং আপনার মানসিক শান্তির প্রতি মনোযোগ দিন।',
      suggestions:
          '১. প্রতিদিন অন্তত কিছুটা সময় নিজের জন্য রাখুন এবং পছন্দের কাজ করুন।\n'
          '২. প্রিয়জনদের সাথে সময় কাটান এবং মানসিক সমর্থন গ্রহণ করুন।\n'
          '৩. নিয়মিত ব্যায়াম করুন এবং স্বাস্থ্যকর খাবার গ্রহণের মাধ্যমে আপনার দৈনন্দিন অভ্যাস উন্নত করুন।',
    ),
    ResultModel(
      status: 'Moderate Stress',
      color: Colors.amber,
      interpretation:
          'আপনার স্কোর মাঝারি স্তরের চাপ নির্দেশ করে। এটি বোঝায় যে আপনি চাপ মোকাবিলা করার জন্য একটি শক্ত ভিত্তি পেয়েছেন, তবে আরও উন্নতির সুযোগ রয়েছে। নিজেকে ইতিবাচক পরিবর্তনের জন্য প্রস্তুত করুন এবং ধাপে ধাপে আপনার মানসিক স্বাস্থ্য উন্নত করার জন্য উদ্যোগ নিন।',
      suggestions:
          '১. শ্বাস প্রশ্বাসের অনুশীলন বা ধ্যানের মাধ্যমে চাপ হ্রাস করার কৌশল ব্যবহার করুন।\n'
          '২. একটি ডায়েরি রাখতে পারেন যেখানে আপনি আপনার চিন্তা ও অনুভূতিগুলো লিখে রাখতে পারেন।\n'
          '৩. নতুন কোনো শখ শুরু করার কথা ভাবুন যা আপনাকে আনন্দ এবং তৃপ্তি এনে দেয়।',
    ),
    ResultModel(
      status: 'High Stress',
      color: Colors.red,
      interpretation:
          'আপনার স্কোর ইঙ্গিত দেয় যে আপনি বেশ উচ্চ মানসিক চাপ অনুভব করছেন। এটি গুরুত্বপূর্ণ যে আপনি এই চাপ মোকাবিলায় সচেতন পদক্ষেপ নিন। নিজেকে বুঝতে শিখুন এবং মানসিক শান্তি পুনরুদ্ধারে উদ্যোগী হন।',
      suggestions:
          '১. নিয়মিত ব্যায়াম, স্বাস্থ্যকর খাদ্য এবং পর্যাপ্ত ঘুম নিশ্চিত করুন।\n'
          '২. মানসিক চাপ কমানোর জন্য প্রতিদিন ধ্যানের অভ্যাস গড়ে তুলুন।\n'
          '৩. আপনার প্রিয় মানুষদের সাথে কথা বলুন এবং তাদের কাছ থেকে মানসিক সমর্থন নিন।',
    ),
  ];
}
