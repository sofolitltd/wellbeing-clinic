import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/utils/set_tab_title.dart';
import '../../model/item_model.dart';
import '../../model/result_model.dart';
import '../../model/test_model.dart';
import '../../utils/generate_pdf.dart';
import '../test_list.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

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

    final String title = args['title'] as String? ?? 'Unknown Test';
    final int score = args['score'] as int? ?? 0;
    final ResultModel result = (args['result'] is ResultModel)
        ? args['result'] as ResultModel
        : ResultModel.empty();
    final Map<int, int> scoreMap = (args['scoreMap'] is Map<int, int>)
        ? args['scoreMap'] as Map<int, int>
        : {};
    final String route = args['route'] as String? ?? '';

    final TestModel? targetTestModel = testList.firstWhereOrNull(
      (testModel) => testModel.route == route,
    );

    if (targetTestModel == null) {
      setTabTitle('Error', context);
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text('Test details not found for route: "$route".'),
        ),
      );
    }

    setTabTitle('$title Preview', context);

    List<ItemModel> items = targetTestModel.items;

    final bool hasItems = items.isNotEmpty;
    final bool hasScale = hasItems && items.first.scale.isNotEmpty;

    GlobalKey previewContainer = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text('Preview: $title'),
        actions: [
          //pdf download btn
          IconButton(
            onPressed: () {
              //
              generateAndPrintResult(
                title: title,
                score: score,
                items: items,
                resultMap: scoreMap,
                result: result,
              );
            },
            icon: Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 794),
            child: SingleChildScrollView(
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
                  if (hasScale) ...[
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
                  if (hasItems)
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade500),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
                            if (hasScale)
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
                              if (hasScale)
                                ...items[i].scale.map((scaleItem) {
                                  final selectedId = scoreMap[items[i].id];
                                  final bool isSelected =
                                      selectedId == scaleItem.id;
                                  return Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Center(
                                      child: isSelected
                                          ? Text('*',
                                              style: TextStyle(fontSize: 18))
                                          : const SizedBox.shrink(),
                                    ),
                                  );
                                }),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Result: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      // const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '$title ($score) - ${result.status} ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
