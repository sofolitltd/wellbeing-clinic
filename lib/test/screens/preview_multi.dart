import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/utils/set_tab_title.dart';
import '../../model/result_model.dart';
import '../../model/test_model.dart';
import '../test_list.dart';

class MultiResultPreviewScreen extends StatelessWidget {
  MultiResultPreviewScreen({super.key});

  final GlobalKey previewContainer = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      setTabTitle('Wellbeing Clinic', context);
      return Scaffold(
        appBar: AppBar(title: const Text('Wellbeing Clinic')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            mainAxisSize: MainAxisSize
                .min, // Optional: remove or keep as min for tight wrapping
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              const Text('No preview data available.'),
              const SizedBox(height: 16), // Add some spacing
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/');
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final String title = args['title'] ?? 'Unknown Test';
    final String route = args['route'] ?? '';
    final List<int> scores = List<int>.from(args['scores'] ?? []);
    final List<ResultModel> resultModels =
        List<ResultModel>.from(args['resultModels'] ?? []);
    final Map<int, int> scoreMap = Map<int, int>.from(args['scoreMap'] ?? {});

    final TestModel? targetTestModel =
        testList.firstWhereOrNull((test) => test.route == route);

    if (targetTestModel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Test not found for route: "$route"')),
      );
    }

    final items = targetTestModel.items;

    setTabTitle('$title Preview', context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Preview: $title'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 794),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (items.isNotEmpty && items.first.scale.isNotEmpty) ...[
                  const Text('স্কেল:', style: TextStyle(fontSize: 14)),
                  Wrap(
                    children: List.generate(
                      items.first.scale.length,
                      (index) {
                        final scale = items.first.scale[index];
                        final isLast = index == items.first.scale.length - 1;
                        return Text(
                          '${scale.id} = ${scale.title}${isLast ? '' : ', '}',
                          style: const TextStyle(fontSize: 13),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (items.isNotEmpty)
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade500),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: const FlexColumnWidth(4),
                      for (int i = 1; i <= items.first.scale.length; i++)
                        i: const FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'প্রশ্ন',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...items.first.scale.map(
                            (scale) => Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                scale.id.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < items.length; i++)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${items[i].id}. ${items[i].title}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            ...items[i].scale.map((scaleItem) {
                              final selectedId = scoreMap[items[i].id];
                              final isSelected = selectedId == scaleItem.id;
                              return Padding(
                                padding: const EdgeInsets.all(6),
                                child: Center(
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 16)
                                      : const SizedBox.shrink(),
                                ),
                              );
                            }),
                          ],
                        ),
                    ],
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Results:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(resultModels.length, (index) {
                  final result = resultModels[index];
                  final score = scores.length > index ? scores[index] : 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${result.title}($score) - ${result.status}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
