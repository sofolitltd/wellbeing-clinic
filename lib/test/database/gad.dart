import 'package:flutter/material.dart';

import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/scale_model.dart';

class GAD {
  //
  static String title = 'General Anxiety Disorder ';
  static String route = 'general-anxiety-disorder';
  static String author =
      'Developed by: Dr. Robert L. Spitzer, Dr. Kurt Kroenke, et al. (2006)\n'
      'Adapted by: ASM Redwan, Md Rezaul Karim, Ramendra Kumar Singha Royle, & Ahmed Riad Chowdhury\n';
  static String about =
      'জেনারেলাইজড অ্যাংজাইটি ডিজঅর্ডার (GAD) টেস্ট একটি মনোবৈজ্ঞানিক মূল্যায়ন পদ্ধতি, যা সাধারণ উদ্বেগজনিত অসুস্থতার লক্ষণ ও তার মাত্রা পরিমাপের জন্য তৈরি করা হয়েছে। এতে সাধারণত এমন কিছু প্রশ্ন থাকে, যা উদ্বেগের বিভিন্ন দিক বিশ্লেষণ করে। এই টেস্টের মাধ্যমে একজন ব্যক্তির উদ্বেগ কতটা তীব্র বা দীর্ঘস্থায়ী, তা বোঝা যায়।';

  static String instruction =
      'গত ২ সপ্তাহে কত ঘন ঘন আপনি নিম্নলিখিত সমস্যাগুলো অনুভব করেছেন?';

  //
  static final List<ItemModel> items = [
    ItemModel(
      id: 1,
      title: 'নার্ভাস, উদ্বিগ্ন বা ভেঙ্গে পড়া অনুভব করেছি',
      scale: scale,
    ),
    ItemModel(
      id: 2,
      title: 'উদ্বেগকে থামাতে বা নিয়ন্ত্রণ করতে পারছি না',
      scale: scale,
    ),
    ItemModel(
      id: 3,
      title: 'বিভিন্ন বিষয় নিয়ে খুব বেশি চিন্তিত',
      scale: scale,
    ),
    ItemModel(
      id: 4,
      title: 'আরাম করতে পারছি না/ নির্ভার হতে পারছি না',
      scale: scale,
    ),
    ItemModel(
      id: 5,
      title: 'এতটা অস্থির যে চুপ করে বসে থাকা কষ্টকর',
      scale: scale,
    ),
    ItemModel(
      id: 6,
      title: 'সহজে বিরক্ত হচ্ছি',
      scale: scale,
    ),
    ItemModel(
      id: 7,
      title: 'ভয় লাগছে যেন ভয়ঙ্কর কিছু ঘটবে',
      scale: scale,
    ),
  ];

  //
  static List<ScaleModel> scale = [
    ScaleModel(0, 'গত দুই সপ্তাহের কোনদিনই না'),
    ScaleModel(1, 'গত দুই সপ্তাহের কিছু কিছু দিন'),
    ScaleModel(2, 'গত দুই সপ্তাহের প্রায় অর্ধেকটা সময় জুড়ে'),
    ScaleModel(3, 'গত দুই সপ্তাহের প্রায় প্রতিদিন'),
  ];

  // cal
  static ResultModel calculateResult(int totalScore) {
    if (totalScore <= 4) {
      return GAD.result[0]; // Minimal Anxiety
    } else if (totalScore <= 9) {
      return GAD.result[1]; // Mild Anxiety
    } else if (totalScore <= 14) {
      return GAD.result[2]; // Moderate Anxiety
    } else {
      return GAD.result[3]; // Severe Anxiety
    }
  }

  static final List<ResultModel> result = [
    ResultModel(
      status: 'Minimal Anxiety',
      color: Colors.greenAccent.shade400,
      interpretation:
          'আপনার তেমন কোনো দুশ্চিন্তা নেই। সামান্য দুশ্চিন্তা থাকলেও আপনি তা কাটিয়ে উঠতে পারেন। সাধারণত এই পর্যায়ের দুশ্চিন্তা দৈনন্দিন জীবনের স্বাভাবিক চাপ থেকে আসে এবং এটি আপনার কার্যক্রমে খুব বেশি প্রভাব ফেলে না।',
      suggestions:
          'নিয়মিত স্বাস্থ্যকর জীবনযাপন বজায় রাখুন, যথাযথ ঘুম, সুষম আহার ও নিয়মিত ব্যায়াম করুন। মেডিটেশন বা শ্বাসপ্রশ্বাসের অনুশীলন করে মানসিক চাপ কমাতে পারেন। বন্ধু ও পরিবারের সঙ্গে সময় কাটানোও সহায়ক।',
    ),
    ResultModel(
      status: 'Mild Anxiety',
      color: Colors.yellow,
      interpretation:
          'আপনি কিছুটা দুশ্চিন্তায় ভুগছেন। মনোযোগে সমস্যা হতে পারে, খিটখিটে মেজাজ বা অস্থিরতা দেখা দিতে পারে। মাঝে মাঝে ঘুমের ব্যাঘাত বা অতিরিক্ত চিন্তা অনুভব করতে পারেন, যা আপনার দৈনন্দিন কাজের মাঝে বিঘ্ন ঘটাতে পারে।',
      suggestions:
          'ধীরে ধীরে শিথিল হওয়ার কৌশল ও সেল্ফ-কেয়ার চর্চা করুন। নিয়মিত হাঁটা, যোগব্যায়াম, অথবা প্রিয় শখে সময় দিন। মানসিক চাপ কমানোর জন্য ধ্যান, গভীর শ্বাসপ্রশ্বাসের অনুশীলন করতে পারেন। প্রয়োজনে কাউন্সেলর বা trusted ব্যক্তির সঙ্গে আলোচনা করুন।',
    ),
    ResultModel(
      status: 'Moderate Anxiety',
      color: Colors.amber,
      interpretation:
          'আপনি দুশ্চিন্তায় ভুগছেন এবং এটি আপনার দৈনন্দিন জীবনে প্রভাব ফেলছে। অনিদ্রা, শ্বাসকষ্ট, হৃৎস্পন্দন দ্রুত হওয়া, বা মনোযোগ হারানোর মত শারীরিক ও মানসিক উপসর্গ দেখা দিতে পারে। কাজের গুণগত মান কমে যেতে পারে এবং সামাজিক সম্পর্কেও প্রভাব পড়তে পারে।',
      suggestions:
          'একজন পরামর্শদাতার সঙ্গে কথা বলার কথা ভাবতে পারেন। প্রয়োজনে চিকিৎসকের পরামর্শ নিয়ে মানসিক স্বাস্থ্য সংক্রান্ত পেশাদার সহায়তা নিন। নিয়মিত ব্যায়াম চালিয়ে যান এবং জীবনযাত্রায় মানসিক চাপ কমানোর জন্য পরিবর্তন আনুন। স্বাস্থ্যের জন্য পর্যাপ্ত বিশ্রাম ও পুষ্টিকর খাদ্যগ্রহণ নিশ্চিত করুন।',
    ),
    ResultModel(
      status: 'Severe Anxiety',
      color: Colors.red,
      interpretation:
          'আপনি প্রচণ্ড দুশ্চিন্তায় আছেন, যা আপনার মানসিক ও শারীরিক স্বাস্থ্যে বিরূপ প্রভাব ফেলতে পারে। আপনি হয়তো নিয়ন্ত্রণ হারাচ্ছেন, অতিরিক্ত ভয় বা আতঙ্ক অনুভব করছেন, যা আপনার দৈনন্দিন কাজকর্ম সম্পাদনে বিঘ্ন ঘটাচ্ছে। এই অবস্থায় অবিলম্বে চিকিৎসা প্রয়োজন।',
      suggestions:
          'অবিলম্বে একজন মানসিক স্বাস্থ্য বিশেষজ্ঞের সাহায্য নিন। প্রয়োজনে ওষুধ গ্রহণ এবং মনোবিদের পরামর্শ গ্রহণ অত্যন্ত গুরুত্বপূর্ণ। পরিবারের বা নিকটজনের সহযোগিতা নিন এবং নিজেকে চাপের মধ্যে একা ফেলে রাখবেন না। জরুরি অবস্থায় মানসিক স্বাস্থ্য হেল্পলাইন বা বিশেষায়িত কেন্দ্রে যোগাযোগ করুন।',
    ),
  ];
}
