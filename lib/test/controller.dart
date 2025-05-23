import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../model/extra_result_model.dart';
import '../model/result_model.dart';
import 'database/dark_triad.dart';
import 'database/depression.dart';
import 'database/gad.dart';
import 'database/hopelessness.dart';
import 'database/insomnia.dart';
import 'database/internet_addiction.dart';
import 'database/love_obsession.dart';
import 'database/nicotine_addiction.dart';
import 'database/ocd.dart';
import 'database/pss.dart';
import 'database/satisfaction_with_life.dart';
import 'database/self_esteem.dart';
import 'database/social_anxiety.dart';
import 'database/wellbeing.dart';
import 'test_list.dart';

class TestController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxList<int?> selectedOptions = <int?>[].obs;
  RxInt itemsLength = 0.obs;
  RxBool canGoNext = false.obs;
  Map<int, int> scoreMap = {};
  RxBool isProcessing = false.obs;

  final BuildContext context;
  final String route;

  TestController(this.context, this.route);

  void setItemsLength(int length) {
    itemsLength.value = length;
    selectedOptions.assignAll(List<int?>.filled(length, null));
  }

  void onBackPressed() {
    if (isProcessing.value) return;
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }

    canGoNext.value = selectedOptions[currentIndex.value] != null;
  }

  void onNextPressed({
    required String title,
    required int selectedOption,
  }) async {
    if (isProcessing.value) {
      debugPrint("Already processing, ignoring tap.");
      return;
    }

    selectedOptions[currentIndex.value] = selectedOption;

    await Future.delayed(const Duration(milliseconds: 300));

    if (currentIndex.value < itemsLength.value - 1) {
      currentIndex.value++;

      canGoNext.value = selectedOptions[currentIndex.value] != null;
    } else {
      if (selectedOptions[currentIndex.value] == null) {
        Get.snackbar(
            "Incomplete", "Please answer the last question before submitting.");
        canGoNext.value = false;
        return;
      }

      if (selectedOptions.contains(null)) {
        // if (Get.isDialogOpen!) Get.back();
        Get.snackbar(
            "Incomplete", "Please answer all questions before submitting.");
        // isProcessing.value = false;
        return;
      }

      isProcessing.value = true;
      debugPrint("Starting result calculation process...");

      //
      Get.dialog(
        Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                      height: 150, width: 150, "assets/animation.json"),
                  SizedBox(height: 12),
                  Text("Calculating ...", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      await Future.delayed(const Duration(milliseconds: 1500));

      final test = testList.firstWhereOrNull((test) => test.route == route);
      if (test == null) {
        if (Get.isDialogOpen!) Get.back();
        Get.snackbar("Error", "Test not found.");
        isProcessing.value = false;
        return;
      }

      for (int i = 0; i < itemsLength.value; i++) {
        scoreMap[test.items[i].id] = selectedOptions[i]!;
      }
      log(scoreMap.toString());

      if (route == 'dark-triad') {
        final extra = DarkTriad.calculateResult(scoreMap);

        if (Get.isDialogOpen!) Get.back();
        Get.offNamed('/tests/$route/results',
            arguments: ExtraResultModel(
              title: title,
              route: route,
              resultModels: extra.resultModels,
              scores: extra.scores,
              scoreMap: scoreMap,
            ));
      } else {
        final score =
            selectedOptions.fold(0, (prev, element) => prev + (element ?? 0));
        log(score.toString());

        final resultModel = switch (route) {
          'wellbeing' => Wellbeing.calculateResult(score),
          'internet-addiction' => InternetAddiction.calculateResult(score),
          'social-anxiety' => SocialAnxiety.calculateResult(score),
          'depression' => Depression.calculateResult(score),
          'love-obsession' => LoveObsession.calculateResult(score, scoreMap),
          'general-anxiety-disorder' => GAD.calculateResult(score),
          'self-esteem' => SelfEsteem.calculateResult(score),
          'hopelessness' => Hopelessness.calculateResult(score),
          'insomnia' => Insomnia.calculateResult(score),
          'pss' => PSS.calculateResult(score),
          'ocd' => OCD.calculateResult(score),
          'satisfaction-with-life' =>
            SatisfactionWithLife.calculateResult(score),
          'nicotine-addiction' => NicotineAddiction.calculateResult(score),
          _ => ResultModel.empty(),
        };

        if (Get.isDialogOpen!) Get.back();
        Get.offNamed('/tests/$route/result', arguments: {
          'title': title,
          'route': route,
          'result': resultModel,
          'scoreMap': scoreMap,
          'score': score,
        });
      }
      isProcessing.value = false;
    }
  }
}
