import 'package:flutter/material.dart';

import '../../model/extra_result_model.dart';
import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/scale_model.dart';

class DarkTriad {
  //
  static String title = 'Dark Triad Dirty Dozen';
  static String route = 'dark-triad';
  static String author = 'Developed by: K. Jonason and W.D. Webster\n'
      'Adapted by: Oli Ahmed, Lutfun Naher, Rohmotul Islam, Moslima Akter, and Shila Deb';
  static String about =
      'ডার্ক ট্রায়াড টেস্ট একটি ব্যক্তিত্ব মূল্যায়ন পদ্ধতি যা মানুষের চরিত্রের তিনটি অন্ধকার দিক — ম্যাকিয়াভেলিয়ানিজম, নার্সিসিজম, এবং সাইকোপ্যাথি — পরিমাপ করে। এই তিনটি বৈশিষ্ট্য একত্রে "ডার্ক ট্রায়াড" নামে পরিচিত। টেস্টটি মূলত বোঝার জন্য ব্যবহার করা হয় যে কেউ কতটা কৌশলী, আত্মকেন্দ্রিক বা নির্দয় আচরণ করে। এই বৈশিষ্ট্যগুলো নেতিবাচক ও ক্ষতিকর আচরণের সঙ্গে সম্পর্কিত, এবং সাধারণত ব্যক্তিত্ব বিশ্লেষণ, গবেষণা বা আত্মউন্নয়নের উদ্দেশ্যে এই টেস্টটি নেওয়া হয়।';

  static String instruction =
      'ব্যক্তিত্ব পরিমাপের কিছু উক্তি রয়েছে। প্রতিটি উক্তি আপনার ক্ষেত্রে কতুটুকু প্রযোজ্য তা ৭ মানকের যেকোন একটিতে টিক প্রদানের মাধ্যমের প্রকাশ করুন।';

  //
  static final List<ItemModel> items = [
    ItemModel(
      id: 1,
      title: 'কার্যসিদ্ধির জন্য অন্যদের ব্যবহার করার প্রবণতা আমার আছে।',
      scale: scale,
    ),
    ItemModel(
      id: 2,
      title: 'কার্যসিদ্ধির জন্য আমি মিথ্যা বা প্রতারণার আশ্রয় নিয়েছি।',
      scale: scale,
    ),
    ItemModel(
      id: 3,
      title: 'কার্যসিদ্ধির জন্য আমি চাটুকারিতার আশ্রয় নিয়েছি।',
      scale: scale,
    ),
    ItemModel(
      id: 4,
      title: 'নিজের কাজ সম্পন্ন করতে অন্যদের কাজে লাগানোর প্রবণতা আমার রয়েছে।',
      scale: scale,
    ),
    ItemModel(
      id: 5,
      title: 'আমার অনুশোচনাবোধ কম।',
      scale: scale,
    ),
    ItemModel(
      id: 6,
      title: 'আমি আমার কাজের নৈতিক ভিত্তি নিয়ে চিন্তা করি না।',
      scale: scale,
    ),
    ItemModel(
      id: 7,
      title: 'আমি নির্বিকার বা অনুভূতিহীন প্রকৃতির।',
      scale: scale,
    ),
    ItemModel(
      id: 8,
      title: 'আমি কঠিন প্রকৃতির মানুষ।',
      scale: scale,
    ),
    ItemModel(
      id: 9,
      title: 'আমি চাই অন্যরা আমার প্রশংসা করুক।',
      scale: scale,
    ),
    ItemModel(
      id: 10,
      title: 'আমি চাই অন্যরা আমার দিকে মনোযোগ দিক।',
      scale: scale,
    ),
    ItemModel(
      id: 11,
      title: 'আমি প্রতিপত্তি ও মর্যাদা লাভ করতে চাই।',
      scale: scale,
    ),
    ItemModel(
      id: 12,
      title:
          'আমার মাঝে অন্যদের থেকে বিশেষ আনুকূল্য প্রত্যাশা করার প্রবণতা রয়েছে।',
      scale: scale,
    ),
  ];

  //
  static List<ScaleModel> scale = [
    ScaleModel(1, 'দৃঢ় ভাবে অসম্মতি'),
    ScaleModel(2, 'অসম্মতি'),
    ScaleModel(3, 'সামান্য অসম্মতি'),
    ScaleModel(4, 'অসম্মতি বা সম্মতি কোনটি নয়'),
    ScaleModel(5, 'সামান্য সম্মতি'),
    ScaleModel(6, 'সম্মতি'),
    ScaleModel(7, 'দৃঢ় ভাবে সম্মতি'),
  ];

  // cal
  static ExtraResultModel calculateResult(Map<int, int> resultMap) {
    List<int> values = resultMap.values.toList();

    int sum1 = values.getRange(0, 4).fold(0, (prev, e) => prev + e);
    int sum2 = values.getRange(4, 8).fold(0, (prev, e) => prev + e);
    int sum3 = values.getRange(8, 12).fold(0, (prev, e) => prev + e);

    print('Sum 1-4: $sum1');
    print('Sum 5-8: $sum2');
    print('Sum 9-12: $sum3');

    ResultModel machiavellianismResult = sum1 >= 20 ? result1[0] : result1[1];
    ResultModel psychopathyResult = sum2 >= 20 ? result2[0] : result2[1];
    ResultModel narcissismResult = sum3 >= 20 ? result3[0] : result3[1];

    return ExtraResultModel(
      title: 'Dark Triad',
      route: 'dark-triad',
      resultModels: [
        machiavellianismResult,
        psychopathyResult,
        narcissismResult,
      ],
      scores: [sum1, sum2, sum3],
      scoreMap: resultMap,
    );
  }

  //
  static final List<ResultModel> result1 = [
    ResultModel(
      title: 'Machiavellianism',
      status: 'Machiavellianism Exist',
      color: Colors.red.shade400,
      interpretation:
          'আপনার উত্তর বিশ্লেষণ করে বোঝা যায় যে আপনি প্রভাব, নিয়ন্ত্রণ এবং কৌশল ব্যবহার করে নিজের উদ্দেশ্য হাসিলের প্রবণতা রাখেন। আপনি পরিস্থিতি এবং মানুষকে কাজে লাগিয়ে ফল অর্জনের চেষ্টা করতে পারেন। এটি প্রায়শই সামাজিক বিশ্বাস ও সম্পর্কের ক্ষেত্রে জটিলতা তৈরি করে।',
      suggestions:
          'আপনার মধ্যে নেতৃত্ব ও কৌশলগত চিন্তার ক্ষমতা আছে, তবে তা যেন নৈতিকতার সীমার মধ্যে থাকে। আত্মসমালোচনা চর্চা করুন এবং মানসিক গঠনে সততা, সহমর্মিতা ও সামাজিক দায়িত্ববোধ তৈরি করার চেষ্টা করুন। বিশ্বস্ত সম্পর্ক গড়ে তোলার জন্য কাউন্সেলিং বা আচরণগত থেরাপির সহায়তা নিতে পারেন।',
    ),
    ResultModel(
      title: 'Machiavellianism',
      status: 'Machiavellianism Not Exist',
      color: Colors.green.shade400,
      interpretation:
          'আপনার উত্তরগুলো দেখায় যে আপনি সাধারণত অন্যদের প্রতি শ্রদ্ধাশীল এবং সম্পর্কের ক্ষেত্রে বিশ্বাসযোগ্য ও সৎ। আপনি নৈতিকতা ও আন্তরিকতাকে গুরুত্ব দেন।',
      suggestions:
          'এই ইতিবাচক গুণাবলি ধরে রাখা অত্যন্ত গুরুত্বপূর্ণ। ভবিষ্যতেও সম্পর্ক ভিত্তিক সিদ্ধান্ত নিতে এই মূল্যবোধগুলো অনুসরণ করুন এবং দলগত কাজ বা নেতৃত্বে আরও সহানুভূতিশীল হোন।',
    ),
  ];

  static final List<ResultModel> result2 = [
    ResultModel(
      title: 'Psychopathy',
      status: 'Psychopathy Exist',
      color: Colors.red.shade400,
      interpretation:
          'আপনার উত্তরের মাধ্যমে বোঝা যায়, আপনি আবেগগতভাবে অনেকটা বিচ্ছিন্ন এবং ঝুঁকি নিতে আগ্রহী হতে পারেন। সহানুভূতির ঘাটতি এবং অপরাধবোধহীন আচরণ কিছু ক্ষেত্রে দেখা যেতে পারে, যা ব্যক্তি ও পেশাগত জীবনে সমস্যা তৈরি করতে পারে।',
      suggestions:
          'আপনার আবেগ চর্চার সুযোগ রয়েছে। থেরাপির মাধ্যমে আপনি সহানুভূতি, আত্মনিয়ন্ত্রণ ও সামাজিক দায়িত্ব সম্পর্কে সচেতন হতে পারেন। mindfulness, CBT বা সংবেদনশীলতা ভিত্তিক প্রশিক্ষণ এই বিষয়ে সহায়ক হতে পারে। পাশাপাশি, আবেগ প্রকাশের স্বাস্থ্যকর পদ্ধতি চর্চা করুন যেমন ডায়েরি লেখা বা রোল-প্লে থেরাপি।',
    ),
    ResultModel(
      title: 'Psychopathy',
      status: 'Psychopathy Not Exist',
      color: Colors.green.shade400,
      interpretation:
          'আপনি আবেগগতভাবে সংবেদনশীল এবং অন্যদের অনুভূতি বুঝতে সক্ষম। এই ধরণের বৈশিষ্ট্য মানসিক সুস্থতা ও সম্পর্ক উন্নয়নের জন্য অত্যন্ত গুরুত্বপূর্ণ।',
      suggestions:
          'এই ইতিবাচক বৈশিষ্ট্যগুলো ধরে রাখুন এবং অন্যদের আবেগ বুঝে দায়িত্বশীল আচরণ করুন। যদি ভবিষ্যতে চ্যালেঞ্জ আসে, আত্মসমালোচনা ও অভ্যন্তরীণ নিয়ন্ত্রণের মাধ্যমে তা মোকাবিলা করুন।',
    ),
  ];

  static final List<ResultModel> result3 = [
    ResultModel(
      title: 'Narcissism',
      status: 'Narcissism Exist',
      color: Colors.red.shade400,
      interpretation:
          'আপনার উত্তরগুলো ইঙ্গিত দেয় যে আপনি নিজের গুরুত্ব ও কৃতিত্ব নিয়ে অত্যধিক সচেতন এবং আপনি অন্যদের তুলনায় নিজেকে প্রাধান্য দিতে পছন্দ করেন। এই মনোভাব আত্মবিশ্বাসের উৎস হতে পারে, তবে এটি যদি অতিরিক্ত হয়, তাহলে তা সম্পর্কের ভারসাম্য নষ্ট করতে পারে এবং একাকিত্ব তৈরি করতে পারে।',
      suggestions:
          'নিজের মূল্য বোঝা ভালো, তবে সেটি অন্যদের খাটো করে নয়। সহানুভূতি, শ্রদ্ধা ও বিনয় চর্চা করুন। আয়নায় নিজের আচরণ পর্যবেক্ষণ করুন এবং মাঝে মাঝে নিজেকে প্রশ্ন করুন—“আমি কি অন্যদের অনুভূতি ও মতামত যথাযথভাবে বিবেচনা করছি?”। গ্রুপ থেরাপি বা ইন্টারপারসোনাল থেরাপি এতে সহায়ক হতে পারে।',
    ),
    ResultModel(
      title: 'Narcissism',
      status: 'Narcissism Not Exist',
      color: Colors.green.shade400,
      interpretation:
          'আপনি নিজের আত্মসম্মান বজায় রাখেন, তবে অন্যদের সাথে সম্পর্কের ক্ষেত্রে ভারসাম্যপূর্ণ ও শ্রদ্ধাশীল আচরণ করেন। এটি মানসিক সুস্থতা এবং সমাজে ইতিবাচক অবদান রাখার ইঙ্গিত।',
      suggestions:
          'এই ইতিবাচক গুণাবলি ধরে রাখার জন্য আত্মবিশ্বাস ও বিনয়কে একত্রে বজায় রাখুন। পারস্পরিক শ্রদ্ধা, সহযোগিতা ও যোগাযোগ দক্ষতার উন্নয়ন অব্যাহত রাখলে ব্যক্তিগত ও পেশাগত সাফল্য বৃদ্ধি পাবে।',
    ),
  ];
}
