import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/item_model.dart';
import '../../utils/set_tab_title.dart';
import '../controller.dart';
import '../test_list.dart';

class TestDetails extends StatefulWidget {
  const TestDetails({
    super.key,
  });

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  @override
  Widget build(BuildContext context) {
    String route = Get.parameters['route'] ?? '';
    // Find the test using the route parameter from the dynamic route.
    final test = testList.firstWhere((test) => test.route == route);
    final List<ItemModel> testItems = List<ItemModel>.from(test.items);
    final TestController controller = Get.put(TestController(context, route))
      ..setItemsLength(testItems.length);

    //
    setTabTitle('${test.title} Details', context);

    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          test.title,
        ),
        // automaticallyImplyLeading: kIsWeb ? false : true,
      ),
      body: Obx(() {
        double progressPercentage =
            (controller.currentIndex.value + 1) / testItems.length;
        Color progressColor = getProgressColor(progressPercentage);

        return Container(
          padding:
              // (MediaQuery.of(context).size.width > 800)
              //     ? EdgeInsets.symmetric(
              //         vertical: 16, horizontal: Get.size.width * .2)
              //     :
              const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  spreadRadius: 2,
                  color: Colors.black12,
                ),
              ]),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Column(
                children: [
                  // Progress indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          minHeight: 10,
                          value: progressPercentage,
                          backgroundColor: progressColor.withValues(alpha: 0.3),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(progressColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text.rich(
                        TextSpan(
                          text:
                              '${testItems[controller.currentIndex.value].id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: ' / ${testItems.length}',
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // questions
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Static Instruction (doesn't animate)
                          const Text(
                            'Instruction',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(test.instruction),
                          const SizedBox(height: 12),

                          // AnimatedSwitcher for only question + options
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              final curvedAnimation = CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut, // smoother easing
                              );

                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.2),
                                  end: Offset.zero,
                                ).animate(curvedAnimation),
                                child: FadeTransition(
                                  opacity: curvedAnimation,
                                  child: child,
                                ),
                              );
                            },
                            child: KeyedSubtree(
                              key: ValueKey(controller.currentIndex.value),
                              child: buildQuestionSection(
                                testItems,
                                controller,
                                progressPercentage,
                                progressColor,
                                test,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // btn
                  buildNavigationButtons(controller, test, testItems.length),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Build the content when the user agrees to proceed
  Widget buildQuestionSection(
      List<ItemModel> testItems,
      TestController controller,
      double progressPercentage,
      Color progressColor,
      dynamic test) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Box
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
          decoration: BoxDecoration(
            color: Colors.black12.withAlpha(5),
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: const BoxConstraints(minHeight: 88),
          child: Text(
            '${testItems[controller.currentIndex.value].id}.  ${testItems[controller.currentIndex.value].title}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 16),

        // Answer Options
        ListTileTheme(
          contentPadding: EdgeInsets.zero,
          child: Column(
            children: List.generate(
              testItems[controller.currentIndex.value].scale.length,
              (index) {
                final option =
                    testItems[controller.currentIndex.value].scale[index];
                final isSelected =
                    controller.selectedOptions[controller.currentIndex.value] ==
                        option.id;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.green.shade50 : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Obx(
                    () => RadioListTile<int?>(
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      dense: true,
                      activeColor: Colors.green,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('${option.id}. ${option.title}'),
                      value: option.id,
                      groupValue: controller
                          .selectedOptions[controller.currentIndex.value],
                      onChanged: controller.isProcessing.value
                          ? null
                          : (value) {
                              // If it's the last question, we still want to record the selected option
                              // but the actual submission will happen when the "Submit" button is pressed.
                              // For other questions, selecting an option automatically moves to the next.
                              if (controller.currentIndex.value ==
                                  controller.itemsLength.value - 1) {
                                controller.selectedOptions[
                                    controller.currentIndex.value] = value;
                                controller.canGoNext.value =
                                    true; // Enable submit button
                              } else {
                                controller.onNextPressed(
                                  title: test.title,
                                  selectedOption: value!,
                                );
                              }
                            },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Build navigation buttons
  Widget buildNavigationButtons(
      TestController controller, dynamic test, int totalItems) {
    // Determine if it's the last question
    bool isLastQuestion = controller.currentIndex.value == totalItems - 1;

    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: controller.currentIndex.value > 0
                  ? controller.onBackPressed
                  : null,
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastQuestion
                        ? Colors.green
                        : Theme.of(context).canvasColor,
                  ),
                  onPressed: controller.canGoNext.value
                      ? () {
                          controller.onNextPressed(
                            title: test.title,
                            selectedOption: controller.selectedOptions[
                                controller.currentIndex.value]!,
                          );
                        }
                      : null,
                  child: Text(
                    isLastQuestion ? 'Submit' : 'Next',
                    style: TextStyle(
                        color: isLastQuestion
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

// Determine the color of the progress bar based on progress percentage
  Color getProgressColor(double percentage) {
    if (percentage < 0.33) {
      return Colors.grey;
    } else if (percentage < 0.66) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
