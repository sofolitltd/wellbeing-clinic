import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/extra_result_model.dart';
import '../../model/result_model.dart';
import '../../utils/set_tab_title.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = Get.arguments;

    if (extra == null) {
      setTabTitle('Wellbeing Clinic', context);
      return Scaffold(
        appBar: AppBar(title: const Text('Wellbeing Clinic')),
        body: Center(
          child: Column(
            children: [
              const Text('No preview data available.'),
              // bach to home
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

    final List<ResultModel> results = extra.resultModels;
    setTabTitle('${extra.title} Result', context);

    return results.length == 1
        ? _buildSingleResult(context, extra, results.first)
        : _buildMultipleResults(context, extra, results);
  }

  Widget _buildSingleResult(
      BuildContext context, ExtraResultModel extra, ResultModel result) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${extra.title} Result'),
            IconButton(
              tooltip: 'Preview',
              onPressed: () {
                Get.toNamed('/tests/${extra.route}/preview', arguments: extra);
              },
              icon: const Icon(Icons.preview),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildResultCard(context, extra, result),
    );
  }

  Widget _buildMultipleResults(
      BuildContext context, ExtraResultModel extra, List<ResultModel> results) {
    return DefaultTabController(
      length: results.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${extra.title} Results'),
          bottom: TabBar(
            isScrollable: true,
            tabs: results.map((result) => Tab(text: result.status)).toList(),
          ),
        ),
        body: TabBarView(
          children: results
              .map((result) => _buildResultCard(context, extra, result))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildResultCard(
      BuildContext context, ExtraResultModel extra, ResultModel result) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 2,
            color: Colors.black12,
          ),
        ],
      ),
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
                      // _buildScoreAndStatus(result, extra.score),
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
              _buildNavigationButtons(extra.route),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact for Counseling/Guidance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildContactOption(Icons.app_registration_outlined, 'Appointment',
                Colors.grey.shade200),
            const SizedBox(width: 12),
            _buildContactOption(Icons.facebook_rounded, 'Facebook',
                Colors.blue.shade50, Colors.blue),
            const SizedBox(width: 12),
            _buildContactOption(
                Icons.add_call, 'WhatsApp', Colors.green.shade50, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildContactOption(IconData icon, String label, Color bgColor,
      [Color? iconColor]) {
    final Map<String, String> urls = {
      'Appointment':
          'https://calendar.google.com/calendar/u/0/appointments/schedules/AcZssZ3BkoHghLUj-bjY5X0Vese8nZulj3fPUd7FyNbdpdV-B9w5rhwQRjHF4jsSYfEdHx-dpOqXOfKv',
      'Facebook': 'https://www.facebook.com/wellbeingclinicbd',
      'WhatsApp': 'https://wa.me/+8801704340860',
    };

    return GestureDetector(
      onTap: () async {
        final url = urls[label];
        if (url != null && await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
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

  Widget _buildNavigationButtons(String route) {
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
