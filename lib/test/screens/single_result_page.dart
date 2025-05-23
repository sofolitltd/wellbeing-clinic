import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/result_model.dart';
import '../../utils/set_tab_title.dart';

class SingleResultPage extends StatelessWidget {
  const SingleResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map?;
    final result = args?['result'] as ResultModel?;
    final scoreMap = args?['scoreMap'] as Map<int, int>?;
    final score = args?['score'] as int?;
    final route = args?['route'] as String?;
    final title = args?['title'] as String?;

    if (args == null || result == null || score == null || route == null) {
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

    setTabTitle('$title Result', context);

    return Scaffold(
      appBar: AppBar(
        title: Text('$title Result'),
        centerTitle: true,
        actions: [
          // preview page
          IconButton(
            tooltip: 'Preview',
            onPressed: () {
              Get.toNamed('/tests/someRoute/preview', arguments: {
                'title': title,
                'score': score,
                'result': result,
                'scoreMap': scoreMap,
                'route': route,
              });
            },
            icon: const Icon(Icons.preview),
          ),
        ],
      ),
      body: ResultCard(
        result: result,
        score: score,
        route: route,
      ),
    );
  }
}

//
class ResultCard extends StatelessWidget {
  final ResultModel result;
  final int score;
  final String route;

  const ResultCard({
    super.key,
    required this.result,
    required this.score,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildScoreAndStatus(result, score),
                      const SizedBox(height: 16),
                      _buildSection(
                          'Interpretation of Result', result.interpretation),
                      const SizedBox(height: 16),
                      _buildSection('Tips/Suggestions', result.suggestions),
                      const Divider(height: 32),
                      _buildContactSection(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreAndStatus(ResultModel result, int score) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: result.color.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Score',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '$score',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: result.color),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  result.status,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: result.color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
      ],
    );
  }

  Widget _buildContactSection() {
    final urls = {
      'Appointment':
          'https://calendar.google.com/calendar/u/0/appointments/schedules/AcZssZ3BkoHghLUj-bjY5X0Vese8nZulj3fPUd7FyNbdpdV-B9w5rhwQRjHF4jsSYfEdHx-dpOqXOfKv',
      'Facebook': 'https://www.facebook.com/wellbeingclinicbd',
      'WhatsApp': 'https://wa.me/+8801704340860',
    };

    Widget contactOption(IconData icon, String label, Color bg,
        [Color? iconColor]) {
      return GestureDetector(
        onTap: () async {
          final url = urls[label];
          if (url != null && await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact for Counseling/Guidance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            contactOption(Icons.app_registration_outlined, 'Appointment',
                Colors.grey.shade200),
            const SizedBox(width: 12),
            contactOption(Icons.facebook_rounded, 'Facebook',
                Colors.blue.shade50, Colors.blue),
            const SizedBox(width: 12),
            contactOption(
                Icons.add_call, 'WhatsApp', Colors.green.shade50, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => Get.offAndToNamed('/tests/$route'),
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Get.offAllNamed('/'),
            child: const Text('Back to Home'),
          ),
        ),
      ],
    );
  }
}
