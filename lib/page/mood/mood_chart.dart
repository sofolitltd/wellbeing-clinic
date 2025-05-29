import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/mood.dart';

class MonthlyMoodChartData {
  final List<FlSpot> spots;
  final double overallAverageScore;

  MonthlyMoodChartData({
    required this.spots,
    required this.overallAverageScore,
  });
}

class MoodMonthlyChart extends StatelessWidget {
  final String? userId;

  const MoodMonthlyChart({super.key, required this.userId});

  Stream<MonthlyMoodChartData> _streamMonthlyMoodData() {
    if (userId == null) {
      print("Error: userId is null. Cannot stream mood data.");
      return const Stream.empty();
    }

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);
    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0).day;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThan: startOfNextMonth)
        .snapshots()
        .map((snapshot) {
      final moodData = <int, List<double>>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp?;
        final scoreRaw = data['score'];

        if (timestamp != null && scoreRaw != null) {
          final date = timestamp.toDate();
          final day = date.day;

          final score = (scoreRaw as num).toDouble();

          moodData.putIfAbsent(day, () => []);
          moodData[day]!.add(score);
        }
      }

      final spots = <FlSpot>[];
      double dailyAverageSum = 0;
      int daysWithDataCount = 0;

      for (var day = 1; day <= lastDayOfCurrentMonth; day++) {
        final scores = moodData[day];
        if (scores != null && scores.isNotEmpty) {
          final avgScore = scores.reduce((a, b) => a + b) / scores.length;
          spots.add(FlSpot(day.toDouble(), avgScore));

          dailyAverageSum += avgScore;
          daysWithDataCount++;
        }
      }

      final overallAverageScore =
          daysWithDataCount > 0 ? dailyAverageSum / daysWithDataCount : 0.0;

      return MonthlyMoodChartData(
        spots: spots,
        overallAverageScore: overallAverageScore,
      );
    }).handleError((e) {
      print("Error streaming monthly mood data: $e");
      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MonthlyMoodChartData>(
      stream: _streamMonthlyMoodData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final chartData = snapshot.data;
        final spots = chartData?.spots ?? [];
        final overallAverageScore = chartData?.overallAverageScore ?? 0.0;
        print("Overall average: $overallAverageScore");

        var banglaMonth = DateFormat.MMMM('bn').format(DateTime.now());

        final overallStatusText = overallAverageScore > 0
            ? "$banglaMonth মাসে সামগ্রিক ভাবে মেজাজ: ${getEmojiForScore(overallAverageScore)}"
            : "এই মাসের জন্য কোনো তথ্য নেই";

        return Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) => Text(
                          value.floor().toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipMargin: 8,
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipColor: defaultLineTooltipColor,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          // Use the exact spot value to get Mood info, not an average
                          final mood = getMoodFromScore(spot.y);
                          return LineTooltipItem(
                            'দিন ${spot.x.toInt()}\n${mood.emoji} ${mood.title}',
                            const TextStyle(color: Colors.white, fontSize: 14),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.3),
                      ),
                      color: Colors.green,
                      preventCurveOverShooting: true,
                      shadow:
                          const Shadow(color: Colors.black12, blurRadius: 4),
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  minX: 1,
                  maxX:
                      DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                          .day
                          .toDouble(),
                  minY: 0,
                  maxY: 5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                overallStatusText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

String getEmojiForScore(double score) {
  if (score >= 4.5) return 'চমৎকার 😄';
  if (score >= 3.5) return 'ভালো 🙂';
  if (score >= 2.5) return 'নিরপেক্ষ 😐';
  if (score >= 1.5) return 'কম 🙁';
  return 'খারাপ 😢';
}

Mood getMoodFromScore(double score) {
  return Mood.values.reduce(
    (a, b) => ((a.score - score).abs() < (b.score - score).abs()) ? a : b,
  );
}
