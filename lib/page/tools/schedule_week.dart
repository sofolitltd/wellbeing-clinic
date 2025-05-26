import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'activity_table.dart';

class Schedule {
  final String id;
  final String name;
  final String subtitle;
  final DateTime date;

  Schedule(
      {required this.id,
      required this.name,
      required this.subtitle,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subtitle': subtitle,
      'date': Timestamp.fromDate(date), // 👈 store as Firestore Timestamp
    };
  }

  factory Schedule.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Schedule(
      id: doc.id,
      name: data['name'] ?? '',
      subtitle: data['subtitle'] ?? '',
      date: (data['date'] as Timestamp)
          .toDate(), // 👈 convert back from Timestamp
    );
  }
}

class ScheduleListPage extends StatefulWidget {
  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  final user = FirebaseAuth.instance.currentUser;
  final schedulesRef = FirebaseFirestore.instance.collection('users');

  List<Schedule> schedules = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    if (user == null) return;

    final snap =
        await schedulesRef.doc(user!.uid).collection('schedules').get();
    setState(() {
      schedules = snap.docs.map((doc) => Schedule.fromDoc(doc)).toList();
      loading = false;
    });
  }

  Future<void> _addOrEditSchedule({Schedule? existing}) async {
    var result = await showDialog<Schedule>(
      context: context,
      builder: (_) => AddScheduleDialog(existing: existing),
    );

    if (result != null && user != null) {
      final docRef = schedulesRef.doc(user!.uid).collection('schedules');

      if (existing != null) {
        // Update
        await docRef.doc(existing.id).update(result.toMap());
      } else {
        // Add
        final newDoc = await docRef.add(result.toMap());
        result = Schedule(
            id: newDoc.id,
            name: result.name,
            subtitle: result.subtitle,
            date: result.date);
      }

      await _loadSchedules();
    }
  }

  Future<void> _confirmAndDeleteSchedule(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("মুছে ফেলুন?"),
        content: const Text("আপনি কি নিশ্চিত এই সময়সূচীটি মুছে ফেলতে চান?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("না"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("হ্যাঁ"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteSchedule(id);
    }
  }

  Future<void> _deleteSchedule(String id) async {
    if (user == null) return;
    await schedulesRef.doc(user!.uid).collection('schedules').doc(id).delete();
    await _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Activity Schedules")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700),
                child: ListView.separated(
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  padding: EdgeInsets.all(16),
                  itemCount: schedules.length,
                  itemBuilder: (_, index) {
                    final s = schedules[index];

                    //
                    return InkWell(
                      onTap: () {
                        Get.to(() => ActivitySchedulePage(
                              scheduleId: s.id,
                              scheduleName: s.name,
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.subtitle,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 12,
                                          color: Colors.black38,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Starting from",
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),

                                    //
                                    Text(
                                      "${DateFormat('d MMMM, y', 'en_US').format(s.date)}"
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.indigo.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: "Edit Schedule",
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(Icons.edit,
                                        color: Colors.indigo, size: 20),
                                  ),
                                  onPressed: () =>
                                      _addOrEditSchedule(existing: s),
                                ),
                                IconButton(
                                  tooltip: "Delete Schedule",
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(Icons.delete,
                                        color: Colors.red, size: 20),
                                  ),
                                  onPressed: () =>
                                      _confirmAndDeleteSchedule(s.id),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditSchedule(),
        icon: Icon(Icons.add),
        label: Text('Add Week'),
      ),
    );
  }
}

//
class AddScheduleDialog extends StatefulWidget {
  final Schedule? existing;

  const AddScheduleDialog({super.key, this.existing});

  @override
  _AddScheduleDialogState createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final nameController = TextEditingController();
  final subtitleController = TextEditingController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.existing != null) {
      nameController.text = widget.existing!.name;
      subtitleController.text = widget.existing!.subtitle;
      selectedDate = widget.existing!.date;
    } else {
      nameController.text = 'Activity Scheduling';
      subtitleController.text = '1st Week';
      selectedDate = DateTime.now();
    }
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Dialog(
      insetPadding: EdgeInsets.all(16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Schedule' : 'Add Activity Schedule',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.close, size: 16),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              Divider(height: 16, thickness: .5),
              SizedBox(height: 16),

              //
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: subtitleController,
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              ListTile(
                tileColor: Colors.indigo.shade50,
                onTap: _pickDate,
                title: Text(
                    "Starting From: ${DateFormat('d MMMM, y', 'en_US').format(selectedDate)}"),
              ),

              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final s = Schedule(
                        id: widget.existing?.id ?? '',
                        name: nameController.text.trim(),
                        subtitle: subtitleController.text.trim(),
                        date: selectedDate,
                      );
                      Navigator.pop(context, s);
                    },
                    child: Text("Save"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
