// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../model/extra_result_model.dart';
// import '../model/result_model.dart';
// import 'database/depression.dart';
// import 'database/gad.dart';
// import 'database/hopelessness.dart';
// import 'database/insomnia.dart';
// import 'database/internet_addiction.dart';
// import 'database/love_obsession.dart';
// import 'database/nicotine_addiction.dart';
// import 'database/ocd.dart';
// import 'database/pss.dart';
// import 'database/satisfaction_with_life.dart';
// import 'database/self_esteem.dart';
// import 'database/social_anxiety.dart';
// import 'database/wellbeing.dart';
// import 'test_list.dart';
//
// class TestController extends GetxController {
//   RxInt currentIndex = 0.obs;
//   RxList<int?> selectedOptions = <int?>[].obs;
//   RxInt itemsLength = 0.obs;
//   RxBool canGoNext = false.obs;
//   int score = 0;
//   Map<int, int> resultMap = {};
//
//   final BuildContext context;
//   final String route;
//
//   TestController(this.context, this.route);
//
//   void setItemsLength(int length) {
//     itemsLength.value = length;
//     selectedOptions.assignAll(List<int?>.filled(length, null));
//   }
//
//   void onBackPressed() {
//     if (currentIndex.value > 0) {
//       currentIndex.value--;
//     }
//     canGoNext.value = true;
//   }
//
//   void onNextPressed(
//       {required String title, required int selectedOption}) async {
//     selectedOptions[currentIndex.value] = selectedOption;
//     await Future.delayed(const Duration(milliseconds: 300));
//
//     if (currentIndex.value < itemsLength.value - 1) {
//       currentIndex.value++;
//     } else {
//       for (int i = 0; i < itemsLength.value; i++) {
//         resultMap[testList
//             .firstWhere((test) => test.route == route)
//             .items[i]
//             .id] = selectedOptions[i]!;
//       }
//
//       //
//       print('resultMap: $resultMap');
//       ResultModel resultModel = generateResult();
//
//       //
//       ExtraResultModel extra = ExtraResultModel(
//         title: title,
//         route: route,
//         score: score,
//         resultModels: [resultModel],
//         resultMap: resultMap,
//       );
//
//       //
//       Get.offNamed('/tests/$route/result', arguments: extra);
//     }
//   }
//
//   // Calculate result based on selected options
//   ResultModel generateResult() {
//     //
//     score = selectedOptions.fold(
//         0, (previousValue, element) => previousValue + (element ?? 0));
//     print('score: $score');
//
//     //
//     switch (route) {
//       case 'wellbeing':
//         return Wellbeing.calculateResult(score);
//       case 'internet-addiction':
//         return InternetAddiction.calculateResult(score);
//       case 'social-anxiety':
//         return SocialAnxiety.calculateResult(score);
//       case 'depression':
//         return Depression.calculateResult(score);
//       case 'love-obsession':
//         return LoveObsession.calculateResult(score, resultMap);
//       case 'gad':
//         return GAD.calculateResult(score);
//       case 'self-esteem':
//         return SelfEsteem.calculateResult(score);
//       // case 'dark-triad':
//       //   List<ResultModel> results = DarkTriad.calculateResult(resultMap);
//       //   return results[0];
//       case 'hopelessness':
//         return Hopelessness.calculateResult(score);
//       case 'insomnia':
//         return Insomnia.calculateResult(score);
//       case 'pss':
//         return PSS.calculateResult(score);
//       case 'ocd':
//         return OCD.calculateResult(score);
//       case 'satisfaction-with-life':
//         return SatisfactionWithLife.calculateResult(score);
//       case 'nicotine-addiction':
//         return NicotineAddiction.calculateResult(score);
//
//       default:
//         return ResultModel.empty();
//     }
//   }
// }
