import 'package:flutter/material.dart';

import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/scale_model.dart';

class NicotineAddiction {
  //
  static String title = 'Nicotine Addiction Scale';
  static String slug = 'nicotine-addiction-scale';
  static String route = 'nicotine-addiction';
  static String author =
      'Developed by: Heatherton, Kozlowski, Freeker and Fagerstrom\n'
      'Adapted by: Farha Deeba and Rumala Ali,ClinicalPsychology, DU';

  //

  static String about =
      'নিকোটিন আসক্তির মাত্রা নির্ধারণে ফ্যাগারস্ট্রম টেস্ট (FTNA) একটি মূল্যায়ন পদ্ধতি। এই স্কেলটি মূলত একজন ব্যক্তির ধূমপানের ঘনত্ব, ধূমপানের তাগিদ এবং ঘুম থেকে ওঠার পর কত দ্রুত ধূমপান করেন — এমন বিষয়গুলোর উপর ভিত্তি করে নির্ধারণ করে তিনি কতটা নিকোটিন নির্ভর। এটি নিকোটিন আসক্তির তীব্রতা বুঝতে সহায়তা করে এবং ব্যক্তিকেন্দ্রিক ধূমপান বন্ধের পরিকল্পনা তৈরিতে গুরুত্বপূর্ণ ভূমিকা রাখে।';

  //
  static String instruction =
      'প্রতিটি প্রশ্নের উত্তরগুলোর মধ্য থেকে যে কোন একটি চিহ্নিত করুন।';

  //
  static List<ItemModel> items = [
    ItemModel(
      id: 1,
      title: 'সকালে ঘুম থেকে ওঠার পর কতক্ষণ পর আপনি প্রথম ধূমপান করেন?',
      scale: scale1,
    ),
    ItemModel(
      id: 2,
      title:
          'ধূমপান নিষিদ্ধ এলাকায় (যেমন: সিনেমা হল, লাইব্রেরী, বাজার, মার্কেট ইত্যাদি) কি আপনি ধূমপান থেকে বিরত থাকায় অসুবিধা বোধ করেন?',
      scale: scale256,
    ),
    ItemModel(
      id: 3,
      title: 'কোন সময়ের সিগারেটটি ছাড়তে আপনার বেশি কষ্ট হয়?',
      scale: scale3,
    ),
    ItemModel(
      id: 4,
      title: 'প্রতিদিন আপনি কয়টা সিগারেট খান?',
      scale: scale4,
    ),
    ItemModel(
      id: 5,
      title:
          'দিনের অন্য সময়ের তুলনায় আপনি কি ঘুম থেকে উঠার এক ঘন্টার মধ্যে বেশী ধুমপান করেন?',
      scale: scale256,
    ),
    ItemModel(
      id: 6,
      title:
          'অসুস্থ হওয়ার কারণে আপনাকে যদি বেশির ভাগ সময় বিছানায় থাকতে হয়, তখনও কি আপনি ধুমপান করেন?',
      scale: scale256,
    ),
  ];

  //
  static List<ScaleModel> scale1 = [
    ScaleModel(3, 'ক. ৫ মিনিটের মধ্যে'),
    ScaleModel(2, 'খ. ৬-৩০ মিনিটের মধ্যে'),
    ScaleModel(1, 'গ. ৩১-৬০ মিনিটের মধ্যে'),
    ScaleModel(0, 'ঘ. ১ ঘন্টার পরে'),
  ];

  static List<ScaleModel> scale256 = [
    ScaleModel(1, 'ক. হ্যাঁ'),
    ScaleModel(0, 'খ. না'),
  ];

  static List<ScaleModel> scale3 = [
    ScaleModel(1, 'ক. সকালের প্রথম সিগারেট'),
    ScaleModel(0, 'খ. অন্যান্য যে কোন সময়ে'),
  ];

  static List<ScaleModel> scale4 = [
    ScaleModel(0, 'ক. ১০ টি অথবা তার কম'),
    ScaleModel(1, 'খ. ১১-২০ টা'),
    ScaleModel(2, 'গ. ২১-৩০ টা'),
    ScaleModel(3, 'ঘ. ৩১ টি অথবা তার বেশি'),
  ];

  //
  static ResultModel calculateResult(int score) {
    if (score.clamp(0, 2) == score) {
      return NicotineAddiction.result[0];
    } else if (score.clamp(3, 4) == score) {
      return NicotineAddiction.result[1];
    } else if (score == 5) {
      return NicotineAddiction.result[2];
    } else if (score.clamp(6, 7) == score) {
      return NicotineAddiction.result[3];
    } else if (score.clamp(8, 10) == score) {
      return NicotineAddiction.result[4];
    } else {
      return ResultModel.empty();
    }
  }

  static final List<ResultModel> result = [
    ResultModel(
      status: 'Very Low Dependence',
      color: Colors.green.shade300,
      interpretation:
          'আপনি খুব কম নিকোটিন নির্ভর। আপনার নিকোটিনের প্রয়োজন খুবই কম এবং আপনি সহজেই ধূমপান কমাতে পারেন।',
      suggestions:
          '১. আপনি যদি ধূমপান বন্ধ করতে চান, ধীরে ধীরে কমাতে শুরু করুন।\n'
          '২. ব্যায়াম ও শখের মাধ্যমে মানসিক চাপ কমানোর চেষ্টা করুন।\n'
          '৩. নিজেকে পুরস্কৃত করুন যখনই আপনি একটি সফল দিন পার করেন ধূমপান ছাড়া।',
    ),
    ResultModel(
      status: 'Low Dependence',
      color: Colors.green.shade500,
      interpretation:
          'আপনার নিকোটিন নির্ভরতা কম, তবে কখনও কখনও আপনি কিছুটা সংকটের সম্মুখীন হতে পারেন।',
      suggestions: '১. ধূমপান কমাতে একটি পরিষ্কার পরিকল্পনা তৈরি করুন।\n'
          '২. প্রয়োজনে চিকিৎসকের সাহায্য নিন।\n'
          '৩. ধূমপান মুক্ত থাকার জন্য সামাজিক সমর্থন ব্যবহার করুন।',
    ),
    ResultModel(
      status: 'Moderate Dependence',
      color: Colors.orange,
      interpretation:
          'আপনার নিকোটিন নির্ভরতা মাঝারি স্তরের। আপনি কিছুটা সমস্যায় পড়তে পারেন, তবে এটি নিয়ন্ত্রণযোগ্য।',
      suggestions: '১. ধূমপান কমানোর জন্য চিকিৎসকের পরামর্শ নিন।\n'
          '২. ধূমপান ছাড়ানোর জন্য পরবর্তী কয়েক সপ্তাহের জন্য পরিকল্পনা তৈরি করুন।\n'
          '৩. শারীরিক ও মানসিক প্রশান্তি চর্চা করুন যেমন যোগ বা মেডিটেশন।',
    ),
    ResultModel(
      status: 'High Dependence',
      color: Colors.red.shade300,
      interpretation:
          'আপনার নিকোটিন নির্ভরতা বেশ উচ্চ, এবং আপনি ধূমপান কমাতে বা বন্ধ করতে কঠিন অনুভব করছেন।',
      suggestions: '১. পেশাদার সাহায্য নিন, যেমন কাউন্সেলিং বা মেডিকেশন।\n'
          '২. ধূমপান কমানোর জন্য ধীরে ধীরে পদক্ষেপ নিন।\n'
          '৩. শারীরিক ব্যায়াম করুন এবং ধূমপান থেকে মুক্ত থাকার জন্য নিজেকে প্রস্তুত করুন।',
    ),
    ResultModel(
      status: 'Very High Dependence',
      color: Colors.red.shade800,
      interpretation:
          'আপনার নিকোটিন নির্ভরতা খুবই উচ্চ। এটি আপনার দৈনন্দিন জীবনে প্রভাব ফেলতে পারে এবং এটি দ্রুত পর্যালোচনা প্রয়োজন।',
      suggestions:
          '১. একজন বিশেষজ্ঞের সহায়তা গ্রহণ করুন, যেমন ধূমপান নিরোধের জন্য চিকিৎসা।\n'
          '২. স্বাস্থ্যের জন্য পেশাদার পরামর্শের মাধ্যমে ধূমপান ছাড়ানোর পরিকল্পনা করুন।\n'
          '৩. সামাজিক সমর্থন পেতে বন্ধু ও পরিবারের সাথে যোগাযোগ করুন।',
    ),
  ];
}
