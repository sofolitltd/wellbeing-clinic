import 'package:flutter/material.dart';

void main() {
  runApp(const TIPIApp());
}

class TIPIApp extends StatelessWidget {
  const TIPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TIPI Personality Test',
      home: TIPIScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TIPIScreen extends StatefulWidget {
  const TIPIScreen({super.key});

  @override
  State<TIPIScreen> createState() => _TIPIScreenState();
}

class _TIPIScreenState extends State<TIPIScreen> {
  final Map<int, int?> responses = {};
  final List<int> reverseScored = [1, 3, 5, 7, 9]; // reverse index
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> questionKeys = List.generate(10, (_) => GlobalKey());

  final List<String> optionLabels = [
    "১. সম্পূর্ণভাবে দ্বিমত",
    "২. মোটামুটিভাবে দ্বিমত",
    "৩. কিছুটা দ্বিমত",
    "৪. নিরপেক্ষ (দ্বিমত বা একমত কোনটি নয়)",
    "৫. কিছুটা একমত",
    "৬. মোটামুটিভাবে একমত",
    "৭. সম্পূর্ণভাবে একমত",
  ];

  final List<String> questions = [
    "১। মিশুক, চটপট",
    "২। জটিল, ঝগড়াটে",
    "৩। নির্ভরযোগ্য, আত্মনিয়ন্ত্রক",
    "৪। দুশ্চিন্তাগ্রস্থ, সহজে বিপর্যস্থ",
    "৫। নতুন অভিজ্ঞতায় আগ্রহী, সৃষ্টিশীল",
    "৬। গম্ভীর, চুপচাপ",
    "৭। দরদী, আন্তরিক",
    "৮। অগোছালো, উদাসীন",
    "৯। শান্ত, ধীরস্থির",
    "১০। গতানুগতিক, সৃষ্টিশীল নই",
  ];

  final Set<int> errorIndexes = {};

  void _scrollToError(int index) {
    final context = questionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 500),
          alignment: 0.2,
          curve: Curves.easeInOut);
    }
  }

  void _submit() {
    errorIndexes.clear();
    for (int i = 0; i < 10; i++) {
      if (responses[i] == null) {
        errorIndexes.add(i);
      }
    }

    if (errorIndexes.isNotEmpty) {
      setState(() {});
      _scrollToError(errorIndexes.first);
      return;
    }

    List<double> processed = List.generate(10, (i) {
      int value = responses[i]!;
      return reverseScored.contains(i)
          ? (8 - value).toDouble()
          : value.toDouble();
    });

    final scores = {
      "Extraversion": (processed[0] + processed[5]) / 2,
      "Agreeableness": (processed[1] + processed[6]) / 2,
      "Conscientiousness": (processed[2] + processed[7]) / 2,
      "Emotional Stability": (processed[3] + processed[8]) / 2,
      "Openness": (processed[4] + processed[9]) / 2,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(scores: scores),
      ),
    );
  }

  Widget _buildQuestion(int index) {
    return Container(
      key: questionKeys[index],
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questions[index],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          for (int value = 1; value <= 7; value++)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: responses[index] == value
                    ? Colors.green.shade50
                    : Colors.white, // BG change here
                border: Border.all(
                  color:
                      responses[index] == value ? Colors.green : Colors.black12,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<int>(
                title: Text(optionLabels[value - 1]),
                value: value,
                groupValue: responses[index],
                onChanged: (val) {
                  setState(() {
                    responses[index] = val;
                    errorIndexes.remove(index);
                  });

                  // Scroll to the next question
                  if (index < 9) {
                    final nextContext = questionKeys[index + 1].currentContext;
                    if (nextContext != null) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Scrollable.ensureVisible(
                          nextContext,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          alignment: 0.2,
                        );
                      });
                    }
                  }
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          if (errorIndexes.contains(index))
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 4),
              child: Text(
                "Please select a value.",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(10, (index) {
                      final isSelected = responses[index] != null;
                      return GestureDetector(
                        onTap: () {
                          final context = questionKeys[index].currentContext;
                          if (context != null) {
                            Scrollable.ensureVisible(
                              context,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              alignment: 0.2,
                            );
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                //

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          //
                          const Text(
                              "নিম্মে ১০ জোড়া ব্যক্তিত্ব বৈশিষ্ট্য দেয়া আছে। প্রতি জোড়া বৈশিষ্ট্য আপনার ক্ষেত্রে কতখানি প্রযোজ্য তা ৭ টি উত্তরের মধ্যে যেটিতে প্রযোজ্য তার পাশে টিক চিহ্ন (১) দিয়ে প্রকাশ করুন। যদিও প্রতি জোড়া বৈশিষ্ট্যগুলোর মধ্যে একটি বৈশিষ্ট্য অপরটির চেয়ে আপনার ক্ষেত্রে কম বা বেশি প্রযোজ্য হতে পারে।"),
                          const SizedBox(height: 16),

                          ...List.generate(10, _buildQuestion),
                          //
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: _submit,
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
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
  }
}

class ResultPage extends StatelessWidget {
  final Map<String, double> scores;

  const ResultPage({super.key, required this.scores});

  String getTip(String trait, double value) {
    if (value >= 6) {
      return "High in $trait — You likely excel in this trait!";
    } else if (value >= 4) {
      return "Moderate in $trait — You have a balanced level of this trait.";
    } else {
      return "Low in $trait — You might consider developing this area.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Personality Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: scores.entries.map((entry) {
            final tip = getTip(entry.key, entry.value);
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${entry.key}: ${entry.value.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
