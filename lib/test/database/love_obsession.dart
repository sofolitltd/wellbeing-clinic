import 'package:flutter/material.dart';

import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/scale_model.dart';

class LoveObsession {
  //
  static String title = 'Love Obsession';
  static String route = 'love-obsession';
  static String author = 'Developed by: Dr. Susan Forward (1992)\n'
      'Adapted by: Unknown';
  static String about =
      'অতিরিক্ত ভালোবাসা বা অবসেসিভ লাভ ডিসঅর্ডার (OLD) একটি প্রস্তাবিত মানসিক অবস্থা, যেখানে একজন ব্যক্তি আরেকজনকে ঘিরে চরম মাত্রার আবেগ, দখল করার আকাঙ্ক্ষা ও সুরক্ষার প্রবল ইচ্ছা অনুভব করেন। অনেক ক্ষেত্রে এই ব্যক্তি প্রত্যাখ্যান বা সম্পর্কের ব্যর্থতাকে মেনে নিতে অক্ষম হন।';

  static String instruction =
      'আপনি প্রেমে অবসেসড কিনা তা জানার জন্য নিম্নোক্ত প্রশ্নগুলোর ক্ষেত্রে “হ্যাঁ” বা “না” - একটি উত্তর বেছে নিন।।';

  //
  static final List<ItemModel> items = [
    ItemModel(
      id: 1,
      title:
          'দৈহিক বা আবেগীয়ভাবে আপনার প্রেমিক/ প্রেমিকা কাছে নেই, কিন্তু তার জন্য আপনি কি সারাক্ষণ অস্থির থাকেন?',
      scale: scale,
    ),
    ItemModel(
      id: 2,
      title:
          'যদি আপনার প্রেমিক/ প্রেমিকা আপনার কাছে থাকে তবে কি সমস্ত দিন কেবল তার সঙ্গেই কাটাবেন?',
      scale: scale,
    ),
    ItemModel(
      id: 3,
      title:
          'আপনি কি বিশ্বাস করেন, যদি আপনি যথেষ্টভাবে তাকে চান তবে তিনিও আপনাকে ভালোবাসবেন?',
      scale: scale,
    ),
    ItemModel(
      id: 4,
      title:
          'আপনি কি বিশ্বাস করেন, যদি তাকে সঠিকভাবে রাজি করান যায় তবে তিনি আপনাকে গ্রহণ করবেন?',
      scale: scale,
    ),
    ItemModel(
      id: 5,
      title:
          'যখন আপনি ভালোবাসায় প্রত্যাখ্যাত হন, তখন কি কেবলই আপনার উত্তেজনা হিংসায় রূপ নেয়?',
      scale: scale,
    ),
    ItemModel(
      id: 6,
      title:
          'যখন আপনি বার বার প্রত্যাখ্যাত হন, তখন কি সে ব্যক্তির প্রতি আপনার সে ব্যক্তিকে আরো বেশি করে কাছে পেতে ইচ্ছা করে?',
      scale: scale,
    ),
    ItemModel(
      id: 7,
      title: 'তিনি ভালোবাসবেন না বলে নিজেকে পরিস্থিতির শিকার মনে হয়?',
      scale: scale,
    ),
    ItemModel(
      id: 8,
      title:
          'তার প্রতি তীব্র অনুভূতির কারণে আপনার খাওয়া, ঘুম, এবং কাজ-কর্মে ব্যাঘাত ঘটেছে?',
      scale: scale,
    ),
    ItemModel(
      id: 9,
      title:
          'আপনি কি বিশ্বাস করেন, তিনিই একমাত্র ব্যক্তি যিনি আপনার জীবনকে মূল্যবান করতে পারেন?',
      scale: scale,
    ),
    ItemModel(
      id: 10,
      title:
          'আপনি কি লক্ষ্য করেছেন, আপনি খুব বেশি পরিমাণে তাকে ডাকছেন অথবা প্রায়ই অসময়ে ডাকছেন কিংবা তার ফোনের জন্য দীর্ঘ সময় ধরে অপেক্ষা করছেন?',
      scale: scale,
    ),
    ItemModel(
      id: 11,
      title: 'আপনি কি তার বাড়ীতে যখন খুশি তখন না জানিয়েই হাজির হন?',
      scale: scale,
    ),
    ItemModel(
      id: 12,
      title:
          'আপনি কি সব সময় খোঁজ করেন, কোথায় আপনার ভালোবাসার ব্যক্তিটি থাকতে পারে? আপনি কি কখনো গোপনে তাকে অনুসরণ করেছেন?',
      scale: scale,
    ),
    ItemModel(
      id: 13,
      title: 'আপনি কি তার প্রতি বা আপনার প্রতি আক্রমণাত্মক কিছু করেছেন?',
      scale: scale,
    ),
  ];
  //
  static List<ScaleModel> scale = [
    ScaleModel(1, 'হ্যাঁ'),
    ScaleModel(0, 'না'),
  ];

  // cal
  static ResultModel calculateResult(int score, Map<int, int> resultMap) {
    if (score > 6.5) {
      if (resultMap[12] == 1 || resultMap[13] == 1) {
        return LoveObsession.result[2];
      } else {
        return LoveObsession.result[1];
      }
    } else {
      return LoveObsession.result[0];
    }
  }

  //
  static final List<ResultModel> result = [
    ResultModel(
      status: 'No Love Obsession',
      color: Colors.greenAccent.shade400,
      interpretation:
          'আপনি Love Obsession-এ ভুগছেন না। আপনার কারো প্রতি আকর্ষণ একটি স্বাভাবিক মাত্রায় রয়েছে যা সুস্থ সম্পর্কের ইঙ্গিত দেয়।',
      suggestions:
          '1. আপনার ইতিবাচক এবং সুস্থ সম্পর্ক বজায় রাখার জন্য নিজের মানসিক এবং শারীরিক স্বাস্থ্যের যত্ন নিন।\n'
          '2. সময় সময় নিজের লক্ষ্য ও শখের উপর ফোকাস করুন।\n'
          '3. পারস্পরিক সম্মান এবং স্বাধীনতা বজায় রাখার জন্য সচেতন থাকুন।',
    ),
    ResultModel(
      status: 'Love Obsession',
      color: Colors.amber,
      interpretation:
          'আপনার মধ্যে Love Obsession-এর লক্ষণ বিদ্যমান। আপনি কারো প্রতি প্রবল আকর্ষণ অনুভব করছেন এবং সেই ব্যক্তির উপর কিছুটা অসঙ্গত অধিকারবোধ প্রদর্শন করছেন, যা আপনার মানসিক স্বাস্থ্যে প্রভাব ফেলতে পারে।',
      suggestions:
          '1. নিজের অনুভূতিগুলোকে পর্যবেক্ষণ করার জন্য সময় দিন এবং এগুলো নিয়ে নিকটজনের সাথে কথা বলুন।\n'
          '2. অতিরিক্ত নির্ভরশীলতা এড়ানোর জন্য নিজের স্বাধীনতা ও আত্মসম্মান তৈরি করুন।\n'
          '3. মানসিক চাপ বা উদ্বেগ কমানোর জন্য একজন মানসিক স্বাস্থ্য বিশেষজ্ঞের পরামর্শ নিন।',
    ),
    ResultModel(
      status: 'Excessive Love Obsession',
      color: Colors.red,
      interpretation:
          'আপনার মধ্যে Excessive Love Obsession-এর লক্ষণ বিদ্যমান। আপনি কারো প্রতি অপ্রতিরোধ্য আকর্ষণ অনুভব করছেন এবং সেই ব্যক্তির উপর অসঙ্গত অধিকারবোধ তৈরি করার চেষ্টা করছেন, যা আপনার মানসিক স্বাস্থ্যের জন্য ক্ষতিকারক।',
      suggestions:
          '1. তৎক্ষণাৎ মানসিক স্বাস্থ্য বিশেষজ্ঞ বা কাউন্সেলরের শরণাপন্ন হন।\n'
          '2. আত্ম-পর্যালোচনার মাধ্যমে নিজের আচরণ ও আবেগকে বোঝার চেষ্টা করুন।\n'
          '3. নিজের আত্মনির্ভরশীলতা এবং ইতিবাচক চিন্তা উন্নত করতে ধ্যান, যোগব্যায়াম বা থেরাপি গ্রহণ করুন।',
    ),
  ];
}
