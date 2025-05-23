import 'package:flutter/material.dart';

import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/scale_model.dart';

class SatisfactionWithLife {
  //
  static String title = 'Satisfaction with life Scale';
  static String slug = 'satisfaction-with-life-scale';
  static String route = 'satisfaction-with-life';
  static String author =
      'Developed by: Ed Diener, Robert A. Emmons, Randy J. Larsen & Sharon Griffin (1985)\n'
      'Adapted by: Flora Jesmin, Clinical Psychology, University of Dhaka';

  //
  static String about =
      'সেটিসফ্যাকশন উইথ লাইফ স্কেল (SWLS) একটি ব্যক্তির জীবনের সার্বিক সন্তুষ্টির মাত্রা পরিমাপের জন্য তৈরি করা হয়েছে। এই স্কেলটি একজন ব্যক্তি তার জীবনের সম্পর্কে যে মানসিক মূল্যায়ন করে তা মূল্যায়ন করে, যা তার জীবনের মান সম্পর্কে ধারণা দেয়। এটি ব্যক্তিগত সাফল্য, সম্পর্ক এবং সামগ্রিক জীবনের অভিজ্ঞতার মতো দিকগুলোকে কেন্দ্র করে, এবং একজন ব্যক্তির বিষয়গত মঙ্গল সম্পর্কে গুরুত্বপূর্ণ তথ্য প্রদান করে।';

  //
  static String instruction =
      'পাঁচটি বিবৃতি রয়েছে যা আপনি সমর্থন করতে পারেন আবার নাও করতে পারেন। ১-৭ পর্যন্ত স্কেল ব্যবহার করে বিবৃতিগুলোর প্রতি আপনার মতামত দিন। অনুগ্রহ করে আপনি সঠিক উত্তরটি দিতে চেষ্টা করুন।';

  //
  static List<ItemModel> items = [
    ItemModel(
      id: 1,
      title: 'জীবনের বেশির ভাগ ক্ষেত্রে আমি সফল।',
      scale: scale,
    ),
    ItemModel(
        id: 2,
        title:
            'আমার অবস্থা সর্বক্ষেত্রে সাফল্যময়। অথবা আমার অবস্থা জীবনের সর্বক্ষেত্রেই চমৎকার।',
        scale: scale),
    ItemModel(
      id: 3,
      title: 'আমি আমার এ জীবনে সন্তষ্ট।',
      scale: scale,
    ),
    ItemModel(
      id: 4,
      title: 'আমি আমার জীবনে গুরুত্বপূর্ণ যা কিছু চেয়েছি সবকিছুই আমি পেয়েছি।',
      scale: scale,
    ),
    ItemModel(
      id: 5,
      title:
          'যদি আমার সম্পূর্ণ জীবন এভাবেই চলে, তবে আমি আমার জীবনের কোনকিছুই পরিবর্তন করব না।',
      scale: scale,
    ),
  ];

  //
  static List<ScaleModel> scale = [
    ScaleModel(7, 'সম্পূর্ণভাবে একমত়'),
    ScaleModel(6, 'একমত'),
    ScaleModel(5, 'কিছুটা একমত'),
    ScaleModel(4, 'নিরপেক্ষ'),
    ScaleModel(3, 'কিছুটা দ্বিমত'),
    ScaleModel(2, 'দ্বিমত'),
    ScaleModel(1, 'সম্পূর্ণভাবে দ্বিমত'),
  ];

  //
  static ResultModel calculateResult(int score) {
    if (score.clamp(5, 9) == score) {
      return SatisfactionWithLife.result[0];
    } else if (score.clamp(10, 14) == score) {
      return SatisfactionWithLife.result[1];
    } else if (score.clamp(15, 19) == score) {
      return SatisfactionWithLife.result[2];
    } else if (score == 20) {
      return SatisfactionWithLife.result[3];
    } else if (score.clamp(21, 25) == score) {
      return SatisfactionWithLife.result[4];
    } else if (score.clamp(26, 30) == score) {
      return SatisfactionWithLife.result[5];
    } else if (score.clamp(31, 35) == score) {
      return SatisfactionWithLife.result[6];
    } else {
      return ResultModel.empty();
    }
  }

  static final List<ResultModel> result = [
    ResultModel(
      status: 'Completely Dissatisfied',
      color: Colors.red,
      interpretation:
          'আপনি বর্তমানে আপনার জীবন নিয়ে চরম অসন্তুষ্ট। আপনার অনুভূতি এবং মানসিক স্বাস্থ্য খারাপ হতে পারে। জীবন থেকে আনন্দ বা পূর্ণতা অনুভব করছেন না।',
      suggestions:
          '১. আপনার অনুভূতি নিয়ে একটি পেশাদার মনোবিশ্লেষকের সাথে আলোচনা করুন।\n'
          '২. প্রতিদিন ছোট ছোট লক্ষ্য নির্ধারণ করুন যা আপনাকে সফলতা এনে দেবে।\n'
          '৩. জীবনের ইতিবাচক দিকগুলির প্রতি মনোযোগ দিন, ছোট সুখের মুহূর্তগুলিকে স্বীকার করুন।',
    ),
    ResultModel(
      status: 'Dissatisfied',
      color: Colors.red,
      interpretation:
          'আপনি আপনার জীবন নিয়ে অসন্তুষ্ট। কিছু দিক ভালো হতে পারে, তবে আপনি অনুভব করছেন যে আরো কিছু প্রয়োজন।',
      suggestions:
          '১. আপনার অনুভূতি নিয়ে খোলামেলা আলোচনা করুন, পরিবারের সদস্য বা বন্ধুদের সাথে কথা বলুন।\n'
          '২. মানসিক চাপ কমানোর জন্য শারীরিক ও মানসিক প্রশান্তি পদ্ধতি অনুসরণ করুন।\n'
          '৩. নিজের জীবনের উদ্দেশ্য ও লক্ষ্য পুনর্বিবেচনা করুন এবং নতুন পথ খুঁজুন।',
    ),
    ResultModel(
      status: 'A little Dissatisfied',
      color: Colors.red,
      interpretation:
          'আপনি কিছুটা অসন্তুষ্ট তবে পুরোপুরি না। কিছু জিনিস আপনার জন্য কাজ করছে, তবে কিছু অংশে উন্নতি প্রয়োজন।',
      suggestions:
          '১. আপনার জীবনের উন্নতির জন্য একটি নির্দিষ্ট পরিকল্পনা তৈরি করুন।\n'
          '২. অতিরিক্ত চাপ থেকে মুক্তি পাওয়ার জন্য সময় দিন নিজেকে।\n'
          '৩. বন্ধুবান্ধব এবং পরিবারের সাথে সময় কাটান, তারা আপনার অনুভূতিকে ভালো করতে সাহায্য করতে পারে।',
    ),
    ResultModel(
      status: 'Neutral',
      color: Colors.orange,
      interpretation:
          'আপনি জীবন সম্পর্কে নিরপেক্ষ অনুভব করছেন। কিছু দিক ভালো তবে কিছু কিছু ক্ষেত্রে অনিশ্চয়তা বা হতাশা থাকতে পারে।',
      suggestions: '১. নিজের লক্ষ্য এবং অগ্রগতি পর্যালোচনা করুন।\n'
          '২. ছোট দিকগুলির প্রতি মনোযোগ দিন যাতে জীবনকে আরো উপভোগ্য বানানো যায়।\n'
          '৩. শখ বা নতুন কিছু শেখার মাধ্যমে নিজেকে ব্যস্ত রাখুন।',
    ),
    ResultModel(
      status: 'A little Satisfied',
      color: Colors.green.shade300,
      interpretation:
          'আপনি আপনার জীবন নিয়ে কিছুটা সন্তুষ্ট। কিছু দিক ভালো এবং আপনি উন্নতির জন্য প্রস্তুত।',
      suggestions:
          '১. আপনার ইতিবাচক অনুভূতিগুলি বজায় রাখুন এবং সেগুলিকে আরও শক্তিশালী করুন।\n'
          '২. জীবনকে আরও উপভোগ্য করার জন্য নতুন চ্যালেঞ্জ নিন।\n'
          '৩. পরিবার এবং বন্ধুদের সাথে গভীর সম্পর্ক তৈরি করুন।',
    ),
    ResultModel(
      status: 'Satisfied',
      color: Colors.green.shade500,
      interpretation:
          'আপনি আপনার জীবন নিয়ে সন্তুষ্ট। আপনি আপনার কাজের ফল এবং সম্পর্ক নিয়ে খুশি। কিন্তু কিছু দিক আরও ভালো হতে পারে।',
      suggestions: '১. আত্মবিশ্বাসী হন এবং নিজের সাফল্য উদযাপন করুন।\n'
          '২. আপনার জীবনের নতুন দিকগুলি আরও উন্নত করার জন্য নতুন সুযোগ সন্ধান করুন।\n'
          '৩. আপনার ভালো অনুভূতিগুলি অন্যদের সাথে শেয়ার করুন এবং তাদের সাহায্য করুন।',
    ),
    ResultModel(
      status: 'Completely Satisfied',
      color: Colors.green.shade800,
      interpretation:
          'আপনি আপনার জীবনে পূর্ণ সন্তুষ্টি অনুভব করছেন। আপনার সম্পর্ক, কর্মজীবন এবং ব্যক্তিগত জীবন সকল দিকেই আপনি সুখী এবং পরিপূর্ণ।',
      suggestions:
          '১. আপনার জীবনযাত্রা এবং অভ্যন্তরীণ শান্তির প্রতি কৃতজ্ঞতা প্রকাশ করুন।\n'
          '২. নিজের জীবনের উন্নতির জন্য নতুন লক্ষ্য নির্ধারণ করুন।\n'
          '৩. অন্যদের সাহায্য করুন যাতে তারা আপনার মতো সন্তুষ্টি অনুভব করতে পারে।',
    ),
  ];
}
