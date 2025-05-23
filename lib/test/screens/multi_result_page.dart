import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellbeingclinic/test/screens/single_result_page.dart';

import '../../model/extra_result_model.dart';
import '../../utils/set_tab_title.dart';

class MultiResultPage extends StatelessWidget {
  const MultiResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = Get.arguments;

    if (extra is! ExtraResultModel || extra.resultModels.length <= 1) {
      Future.microtask(() => Get.offNamed('/not-found'));
      return const SizedBox.shrink();
    }

    if (extra == null) {
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

    //

    setTabTitle('${extra.title} Results', context);

    return DefaultTabController(
      length: extra.resultModels.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${extra.title} Results'),
          actions: [
            // preview page
            IconButton(
              tooltip: 'Preview',
              onPressed: () {
                Get.toNamed('/tests/${extra.route}/previews', arguments: {
                  'title': extra.title,
                  'route': extra.route,
                  'scoreMap': extra.scoreMap,
                  'scores': extra.scores,
                  'resultModels': extra.resultModels,
                });
              },
              icon: const Icon(Icons.preview),
            ),
          ],
          // Removed TabBar from here
        ),
        body: Column(
          children: [
            // Put tabs inside a card-like container

            Container(
              padding: const EdgeInsets.symmetric(),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, -2), // Top shadow
                    blurRadius: 6,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: TabBar(
                    isScrollable: false,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.black54,
                    dividerHeight: 0,
                    tabs: extra.resultModels
                        .map((result) => Tab(text: result.title ?? ""))
                        .toList(),
                  ),
                ),
              ),
            ),

            // Expanded to fill rest of screen
            Expanded(
              child: TabBarView(
                children: List.generate(extra.resultModels.length, (index) {
                  return ResultCard(
                    result: extra.resultModels[index],
                    score: extra.scores[index],
                    route: extra.route,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
