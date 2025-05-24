// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Ensure intl is imported for date formatting
// import 'package:table_calendar/table_calendar.dart';
//
// import 'home_temp.dart'; // Assuming MoodEntry and MoodTrackingSection are in main.dart or a similar file
//
// class MoodCalendarPage extends StatefulWidget {
//   const MoodCalendarPage({super.key});
//
//   @override
//   State<MoodCalendarPage> createState() => _MoodCalendarPageState();
// }
//
// class _MoodCalendarPageState extends State<MoodCalendarPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   // Map to store mood entries by date (without time) for easy lookup
//   final Map<DateTime, List<MoodEntry>> _moodsByDay = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _groupMoodsByDay();
//   }
//
//   // Helper to group mood entries by date (ignoring time)
//   void _groupMoodsByDay() {
//     // for (var entry in widget.moodHistory) {
//     //   final date = DateTime(
//     //       entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
//     //   if (_moodsByDay.containsKey(date)) {
//     //     _moodsByDay[date]!.add(entry);
//     //   } else {
//     //     _moodsByDay[date] = [entry];
//     //   }
//     // }
//   }
//
//   List<MoodEntry> _getEventsForDay(DateTime day) {
//     return _moodsByDay[DateTime(day.year, day.month, day.day)] ?? [];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text(
//           'আপনার মেজাজ ক্যালেন্ডার', // Your Mood Calendar
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         backgroundColor: Colors.indigo.shade700,
//         elevation: 4,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.utc(2023, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _focusedDay,
//             calendarFormat: _calendarFormat,
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             onDaySelected: (selectedDay, focusedDay) {
//               if (!isSameDay(_selectedDay, selectedDay)) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               }
//             },
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//             },
//             eventLoader:
//                 _getEventsForDay, // Use eventLoader to show indicators for moods
//             calendarBuilders: CalendarBuilders(
//               markerBuilder: (context, day, events) {
//                 if (events.isNotEmpty) {
//                   // Display a small colored dot or emoji for each mood entry
//                   // For simplicity, we'll just show the first mood's emoji
//                   final firstMood = events.first as MoodEntry;
//                   return Positioned(
//                     right: 1,
//                     bottom: 1,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: firstMood.color, // Dot color based on mood
//                         shape: BoxShape.circle,
//                       ),
//                       width: 8.0,
//                       height: 8.0,
//                       alignment: Alignment.center,
//                       // child: Text(
//                       //   firstMood.emoji, // You can choose to show emoji or just a dot
//                       //   style: const TextStyle(fontSize: 10),
//                       // ),
//                     ),
//                   );
//                 }
//                 return null;
//               },
//               selectedBuilder: (context, date, events) => Container(
//                 margin: const EdgeInsets.all(4.0),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Colors.indigo.shade400, // Color for selected day
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Text(
//                   '${date.day}',
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               todayBuilder: (context, date, events) => Container(
//                 margin: const EdgeInsets.all(4.0),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Colors.indigo.shade200
//                       .withOpacity(0.5), // Color for today
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Text(
//                   '${date.day}',
//                   style: const TextStyle(
//                       color: Colors.indigo, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             headerStyle: HeaderStyle(
//               formatButtonVisible:
//                   false, // You can make this true if you want month/week/2-week toggle
//               titleCentered: true,
//               titleTextStyle: TextStyle(
//                 color: Colors.indigo.shade800,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               // leftMarrowIcon:
//               //     Icon(Icons.chevron_left, color: Colors.indigo.shade700),
//               // rightMarrowIcon:
//               //     Icon(Icons.chevron_right, color: Colors.indigo.shade700),
//             ),
//             calendarStyle: CalendarStyle(
//               todayDecoration: BoxDecoration(
//                 color: Colors.indigo.shade100,
//                 shape: BoxShape.circle,
//               ),
//               selectedDecoration: BoxDecoration(
//                 color: Colors.indigo.shade500,
//                 shape: BoxShape.circle,
//               ),
//               markerDecoration: BoxDecoration(
//                 color: Colors.green.shade400, // Fallback marker color
//                 shape: BoxShape.circle,
//               ),
//               outsideDaysVisible: false,
//               weekendTextStyle: const TextStyle(color: Colors.red),
//             ),
//           ),
//           const SizedBox(height: 20.0),
//           Expanded(
//             child: _buildMoodListForSelectedDay(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMoodListForSelectedDay() {
//     final selectedDayMoods = _getEventsForDay(_selectedDay!);
//
//     if (selectedDayMoods.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.event_note, size: 50, color: Colors.grey.shade400),
//             const SizedBox(height: 10),
//             Text(
//               'এই দিনে কোনো মেজাজ রেকর্ড করা হয়নি।', // No mood recorded on this day.
//               style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       itemCount: selectedDayMoods.length,
//       itemBuilder: (context, index) {
//         final entry = selectedDayMoods[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12.0),
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//             side: BorderSide(color: entry.color.withOpacity(0.7), width: 1.5),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Text(
//                   entry.emoji,
//                   style: const TextStyle(fontSize: 35),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         entry.moodLabel,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: entry.color,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         DateFormat('hh:mm a').format(entry.timestamp),
//                         style: TextStyle(
//                             fontSize: 13, color: Colors.grey.shade600),
//                       ),
//                       if (entry.note != null && entry.note!.isNotEmpty) ...[
//                         const SizedBox(height: 8),
//                         Text(
//                           entry.note!,
//                           style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey.shade700,
//                               fontStyle: FontStyle.italic),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
