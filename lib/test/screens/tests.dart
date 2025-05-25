import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../model/test_model.dart';
import '../../utils/set_tab_title.dart';
import '../test_list.dart';

List categoryList = [
  'All',
  'Wellbeing',
  'Emotion',
  'Personality',
  'Disorder',
  'Addiction',
];

class Tests extends StatefulWidget {
  const Tests({super.key});

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  String selectedCategory = categoryList.first;
  List<TestModel> filteredTests = [];

  @override
  void initState() {
    super.initState();
    _filterTests(); // Initialize with all tests
  }

  void _filterTests() {
    setState(() {
      if (selectedCategory == 'All') {
        filteredTests = testList;
      } else {
        filteredTests = testList
            .where((test) => test.category == selectedCategory)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setTabTitle('Tests - Wellbeing Clinic', context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tests',
            style: TextStyle(
                color: Colors.indigo.shade700, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Column(
            children: [
              Divider(
                height: .5,
                color: Colors.black12,
                thickness: .5,
              ),

              //
              SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: categoryList.map((category) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          _filterTests(); // Apply filtering on category change
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedCategory == category
                                ? Colors.blueAccent.shade700
                                : Colors.black12,
                          ),
                          color: selectedCategory == category
                              ? Colors.blue.shade50
                              : Colors.transparent,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category
                                ? Colors.blueAccent.shade700
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              //
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  itemCount: filteredTests.length,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemBuilder: (context, index) {
                    return TestItem(index: index, test: filteredTests[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestItem extends StatelessWidget {
  final int index;
  final TestModel test;

  const TestItem({super.key, required this.index, required this.test});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/tests/${test.route}');
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
            //shadow
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ]),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ${test.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              test.about,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 4),

            const Divider(
              height: 16,
              thickness: .2,
            ),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // vertical center
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      test.category,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        height: 1.2,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.2,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      const TextSpan(text: 'Estimated time: '),
                      TextSpan(
                        text: ' ${(test.items.length * 20 / 60).ceil()} min',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class TestItemz extends StatelessWidget {
//   final int index;
//
//   const TestItemz({super.key, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.toNamed('/tests/${testList[index].route}');
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade400),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               // '${index + 1}. ${testList[index].title}',// todo
//               testList[index].title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 4),
//
//             //
//             Text(
//               testList[index].about,
//               maxLines: 3, //todo: change max lines
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 14,
//                 height: 1.3,
//               ),
//             ),
//
//             const SizedBox(height: 4),
//             Text(
//               'Duration : ${testList[index].items} min.',
//               maxLines: 3, //todo: change max lines
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 14,
//                 height: 1.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
