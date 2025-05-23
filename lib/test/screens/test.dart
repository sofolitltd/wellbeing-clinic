import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/item_model.dart';
import '../../utils/set_tab_title.dart';
import '../controller.dart';
import '../test_list.dart';

class Test extends StatefulWidget {
  const Test({
    super.key,
  });

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    String route = Get.parameters['route']!;
    // Find the test using the route parameter from the dynamic route.
    final test = testList.firstWhere((test) => test.route == route);
    final List<ItemModel> testItems = List<ItemModel>.from(test.items);
    final TestController controller = Get.put(TestController(context, route))
      ..setItemsLength(testItems.length);

    //
    setTabTitle(test.title, context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          test.title,
        ),
        // automaticallyImplyLeading: kIsWeb ? false : true,
      ),
      body: Container(
        padding:
            // (MediaQuery.of(context).size.width > 800)
            //     ? EdgeInsets.symmetric(
            //         vertical: 16, horizontal: Get.size.width * .2)
            //     : const
            EdgeInsets.all(16),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: buildConsentContent(test),
                  ),
                ),

                //
                buildConsentButtons(route: route),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the consent form content
  Widget buildConsentContent(dynamic test) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(test.about),
        const Divider(height: 32, thickness: 0.5),

        //
        const Text(
          'Instruction',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(test.instruction),

        //
        const SizedBox(height: 12),

        //
        Row(
          spacing: 16,
          children: [
            const Text(
              'Reference',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            //
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Disclaimer'),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.close_outlined),
                              ),
                            ],
                          ),
                          content: RichText(
                            text: TextSpan(
                              text:
                                  'The references may not be entirely accurate or could contain unintentional mistakes. For any queries, please contact us at ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 16), // Use theme font
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final Uri emailUri = Uri(
                                        scheme: 'mailto',
                                        path: 'sofolitltd@gmail.com',
                                      );
                                      if (await canLaunchUrl(emailUri)) {
                                        launchUrl(emailUri);
                                      }
                                    },
                                    child: Text(
                                      'sofolitltd@gmail.com',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.info_outline,
                size: 18,
              ),
            )
          ],
        ),

        const SizedBox(height: 4),
        Text(
          test.author,
        ),
      ],
    );
  }

  // Build consent buttons
  Widget buildConsentButtons({required String route}) {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.check_circle_outline, size: 12),
            SizedBox(width: 4),
            Text('I understand and give my consent.'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.offNamed(
                    '/tests/$route/details',
                  );
                },
                child: const Text('Agree and Continue'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
