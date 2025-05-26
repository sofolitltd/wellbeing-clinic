// import 'package:flutter/material.dart';
//
// class ActivitySchedulePage extends StatefulWidget {
//   final String scheduleName;
//
//   const ActivitySchedulePage({super.key, required this.scheduleName});
//
//   @override
//   State<ActivitySchedulePage> createState() => _ActivitySchedulePageState();
// }
//
// class _ActivitySchedulePageState extends State<ActivitySchedulePage> {
//   final List<String> days = [
//     'শনিবার',
//     'রবিবার',
//     'সোমবার',
//     'মঙ্গলবার',
//     'বুধবার',
//     'বৃহস্পতিবার',
//     'শুক্রবার'
//   ];
//
//   // Use combined string for easier handling
//   final List<String> timeSlots = [
//     'সকাল ৬টা - ৮টা',
//     'সকাল ৮টা - ১০টা',
//     'দুপুর ১০টা - ১২টা',
//     'দুপুর ১২টা - ২টা',
//     'বিকেল ২টা - ৪টা',
//     'বিকেল ৪টা - ৬টা',
//     'সন্ধ্যা ৬টা - ৮টা',
//     'রাত ৮টা - ১০টা',
//     'রাত ১০টা - ১২টা',
//     'রাত ১২টা - সকাল ৬টা',
//   ];
//
//   final Map<String, String> activities = {}; // key = "day|timeSlot"
//
//   Future<void> _editActivity(String initialDay, String initialTimeSlot) async {
//     final key = "$initialDay|$initialTimeSlot";
//     final noteController = TextEditingController(text: activities[key] ?? '');
//
//     String selectedDay = initialDay;
//     String selectedTime = initialTimeSlot;
//
//     final result = await showDialog<Map<String, String>>(
//       context: context,
//       builder: (_) {
//         return Dialog(
//           insetPadding: EdgeInsets.all(16),
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             constraints: BoxConstraints(maxWidth: 400),
//             padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   //
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'কাজের বিবরণ',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//
//                       //close icon btn
//                       IconButton(
//                         visualDensity: VisualDensity.compact,
//                         icon: Icon(
//                           Icons.close,
//                           size: 16,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ],
//                   ),
//
//                   Divider(height: 16, thickness: .5),
//                   SizedBox(height: 16),
//
//                   //
//                   DropdownButtonFormField<String>(
//                     isDense: true,
//                     value: selectedDay,
//                     items: days
//                         .map((d) => DropdownMenuItem(value: d, child: Text(d)))
//                         .toList(),
//                     onChanged: (v) {
//                       if (v != null) selectedDay = v;
//                     },
//                     decoration: InputDecoration(
//                       labelText: 'দিন',
//                       border: OutlineInputBorder(),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     isDense: true,
//                     value: selectedTime,
//                     items: timeSlots
//                         .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//                         .toList(),
//                     onChanged: (v) {
//                       if (v != null) selectedTime = v;
//                     },
//                     decoration: InputDecoration(
//                       labelText: 'সময়',
//                       border: OutlineInputBorder(),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   TextField(
//                     controller: noteController,
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       labelText: 'কাজের বিবরণ (আবশ্যক)',
//                       border: OutlineInputBorder(),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                     ),
//                     maxLines: 4,
//                   ),
//
//                   SizedBox(height: 24),
//                   //
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     spacing: 8,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text("Cancel"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (noteController.text.trim().isEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("কাজের বিবরণ দিন")),
//                             );
//                             return;
//                           }
//                           Navigator.pop(context, {
//                             "day": selectedDay,
//                             "time": selectedTime,
//                             "note": noteController.text.trim(),
//                           });
//                         },
//                         child: Text("Save"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//
//     if (result != null) {
//       final newKey = "${result['day']}|${result['time']}";
//       setState(() {
//         activities[newKey] = result['note']!;
//         if (newKey != key) {
//           activities.remove(key); // Remove old key if changed
//         }
//       });
//     }
//   }
//
//   Widget _buildTable() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Table(
//         border: TableBorder.all(),
//         columnWidths: {
//           0: FixedColumnWidth(90),
//           for (var i = 1; i <= timeSlots.length; i++) i: FixedColumnWidth(150),
//         },
//         children: [
//           // Header Row
//           TableRow(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 alignment: Alignment.centerLeft,
//                 height: 50,
//                 color: Colors.grey[200],
//                 child:
//                     Text('দিন', style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               //
//               ...timeSlots.map(
//                 (slot) {
//                   final firstSpaceIndex = slot.indexOf(' ');
//                   final label =
//                       slot.substring(0, firstSpaceIndex); // e.g., 'রাত'
//                   final time = slot.substring(
//                       firstSpaceIndex + 1); // e.g., '১২টা - সকাল ৬টা'
//
//                   return Container(
//                     padding: const EdgeInsets.all(6),
//                     color: Colors.grey[200],
//                     alignment: Alignment.center,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(label,
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(time, style: TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//
//           // Data Rows
//           ...days.map((day) {
//             return TableRow(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   child:
//                       Text(day, style: TextStyle(fontWeight: FontWeight.w600)),
//                 ),
//                 ...timeSlots.map((slot) {
//                   final key = "$day|$slot";
//                   final hasActivity = activities.containsKey(key);
//                   return InkWell(
//                     onTap: () => _editActivity(day, slot),
//                     child: Stack(
//                       children: [
//                         Container(
//                           constraints: BoxConstraints(minHeight: 75),
//                           // height: 50,
//                           // color: Colors.red.shade50,
//                           padding: const EdgeInsets.all(6),
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             activities[key] ?? '',
//                             style: TextStyle(fontSize: 10, height: 1.2),
//                           ),
//                         ),
//
//                         //
//                         Positioned(
//                           right: 4,
//                           bottom: 4,
//                           child: Icon(
//                             hasActivity ? Icons.mode_edit_outlined : Icons.add,
//                             size: 14,
//                             color: Colors.black38,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ],
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.scheduleName)),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Add new activity default to first day/time
//           _editActivity(days[0], timeSlots[0]);
//         },
//         label: const Text('Add Activity'),
//         icon: const Icon(Icons.add),
//       ),
//       body: Center(
//         child: Container(
//           constraints: BoxConstraints(maxWidth: 1024),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: SingleChildScrollView(child: _buildTable()),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
