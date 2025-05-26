import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final List<String> days = [
  'শনিবার',
  'রবিবার',
  'সোমবার',
  'মঙ্গলবার',
  'বুধবার',
  'বৃহস্পতিবার',
  'শুক্রবার'
];

final List<String> timeSlots = [
  'সকাল ৬টা - ৮টা',
  'সকাল ৮টা - ১০টা',
  'দুপুর ১০টা - ১২টা',
  'দুপুর ১২টা - ২টা',
  'বিকেল ২টা - ৪টা',
  'বিকেল ৪টা - ৬টা',
  'সন্ধ্যা ৬টা - ৮টা',
  'রাত ৮টা - ১০টা',
  'রাত ১০টা - ১২টা',
  'রাত ১২টা - সকাল ৬টা',
];

class ActivityTable extends StatefulWidget {
  final String scheduleId;
  final String scheduleName;

  const ActivityTable({
    super.key,
    required this.scheduleId,
    required this.scheduleName,
  });

  @override
  State<ActivityTable> createState() => _ActivityTableState();
}

class _ActivityTableState extends State<ActivityTable> {
  Map<String, Map<String, String>> activities = {};
  bool _loading = true;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get activitiesCollection => FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('schedules')
      .doc(widget.scheduleId)
      .collection('activities');

  bool _mobileView = false;

  /// Keep track of last selected cell for FAB default
  String _lastSelectedDay = '';
  String _lastSelectedTime = '';

  @override
  void initState() {
    super.initState();
    _fetchActivities();

    // Default last selected cell to first day and first time slot
    _lastSelectedDay = days[0];
    _lastSelectedTime = timeSlots[0];
  }

  Future<void> _fetchActivities() async {
    setState(() {
      _loading = true;
    });

    try {
      final querySnapshot = await activitiesCollection.get();

      final Map<String, Map<String, String>> fetched = {};
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final day = data['day'] as String?;
        final time = data['time'] as String?;
        final note = data['note'] as String?;
        if (day != null && time != null && note != null) {
          final key = "$day|$time";
          fetched[key] = {
            'id': doc.id,
            'note': note,
          };
        }
      }
      setState(() {
        activities = fetched;
      });
    } catch (e) {
      debugPrint("Failed to fetch activities: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load activities")),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveActivity({
    String? activityId,
    required String day,
    required String time,
    required String note,
  }) async {
    try {
      if (activityId == null) {
        final docRef = await activitiesCollection.add({
          'day': day,
          'time': time,
          'note': note,
        });
        activities["$day|$time"] = {
          'id': docRef.id,
          'note': note,
        };
      } else {
        await activitiesCollection.doc(activityId).update({'note': note});
        activities["$day|$time"] = {
          'id': activityId,
          'note': note,
        };
      }
      setState(() {}); // refresh UI
    } catch (e) {
      debugPrint("Failed to save activity: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save activity")),
      );
    }
  }

  Future<void> _deleteActivity(String activityId, String key) async {
    try {
      await activitiesCollection.doc(activityId).delete();
      setState(() {
        activities.remove(key);
      });
    } catch (e) {
      debugPrint("Failed to delete activity: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete activity")),
      );
    }
  }

  Future<void> _editActivity(
      String? initialDay, String? initialTimeSlot) async {
    final key = initialDay != null && initialTimeSlot != null
        ? "$initialDay|$initialTimeSlot"
        : null;

    final existing = key != null ? activities[key] : null;
    final noteController =
        TextEditingController(text: existing != null ? existing['note'] : '');

    String? selectedDay = initialDay;
    String? selectedTime = initialTimeSlot;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'কাজের বিবরণ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 16, thickness: .5),
                  const SizedBox(height: 16),

                  //
                  DropdownButtonFormField<String>(
                    isDense: true,
                    value: selectedDay,
                    items: days
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) selectedDay = v;
                    },
                    decoration: const InputDecoration(
                      labelText: 'দিন (আবশ্যক)',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),

                  //
                  const SizedBox(height: 16),

                  //
                  DropdownButtonFormField<String>(
                    isDense: true,
                    value: selectedTime,
                    items: timeSlots
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) selectedTime = v;
                    },
                    decoration: const InputDecoration(
                      labelText: 'সময় (আবশ্যক)',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text("সময় নির্বাচন করুন"),
                    validator: (value) => value == null ? 'সময় আবশ্যক' : null,
                  ),

                  //
                  const SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'কাজের বিবরণ (আবশ্যক)',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedDay == null ||
                              selectedTime == null ||
                              noteController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("দিন, সময় এবং কাজের বিবরণ আবশ্যক")),
                            );
                            return;
                          }

                          Navigator.pop(context, {
                            "day": selectedDay!,
                            "time": selectedTime!,
                            "note": noteController.text.trim(),
                          });
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      final newKey = "${result['day']}|${result['time']}";
      final oldEntry = activities[key];

      // If day/time changed and old entry exists, delete old doc
      if (key != newKey && oldEntry != null) {
        await _deleteActivity(oldEntry['id']!, key!);
      }

      await _saveActivity(
        activityId: activities[newKey]?['id'],
        day: result['day']!,
        time: result['time']!,
        note: result['note']!,
      );

      // Update last selected cell to newly saved one
      _lastSelectedDay = result['day']!;
      _lastSelectedTime = result['time']!;
    }
  }

  Widget _buildTable() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 1024),
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: {
                    0: const FixedColumnWidth(90),
                    for (var i = 1; i <= timeSlots.length; i++)
                      i: const FixedColumnWidth(150),
                  },
                  children: [
                    TableRow(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          height: 50,
                          color: Colors.grey[200],
                          child: const Text('দিন',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ...timeSlots.map((slot) {
                          final firstSpaceIndex = slot.indexOf(' ');
                          final label = slot.substring(0, firstSpaceIndex);
                          final time = slot.substring(firstSpaceIndex + 1);
                          return Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(label,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(time,
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    ...days.map((day) {
                      return TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            child: Text(day,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ),
                          ...timeSlots.map((slot) {
                            final key = "$day|$slot";
                            final activity = activities[key];
                            final hasActivity = activity != null;
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _editActivity(day, slot);
                                    // Update last selected cell
                                    _lastSelectedDay = day;
                                    _lastSelectedTime = slot;
                                  },
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(minHeight: 75),
                                    padding: const EdgeInsets.all(6),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      activity?['note'] ?? '',
                                      style: TextStyle(
                                        fontWeight: hasActivity
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: hasActivity
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                if (hasActivity)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () async {
                                        final confirmed =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("মুছে ফেলুন?"),
                                            content: const Text(
                                                "আপনি কি নিশ্চিত এই কাজটি মুছে ফেলতে চান?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("না"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text("হ্যাঁ"),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true) {
                                          await _deleteActivity(
                                              activity!['id']!, key);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.shade200,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: Icon(
                                    hasActivity
                                        ? Icons.mode_edit_outlined
                                        : Icons.add,
                                    size: 14,
                                    color: Colors.black38,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: days.length,
      itemBuilder: (context, dayIndex) {
        final day = days[dayIndex];
        final dayActivities = timeSlots.map((slot) {
          final key = "$day|$slot";
          final activity = activities[key];
          return MapEntry(slot, activity);
        }).toList();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: dayActivities.map((entry) {
              final slot = entry.key;
              final activity = entry.value;
              final key = "$day|$slot"; // 👈 Add this line

              return Column(
                children: [
                  ListTile(
                    onTap: () => _editActivity(day, slot),
                    dense: true,
                    title: Text(slot),
                    subtitle: Text(activity?['note'] ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            activity == null ? Icons.add : Icons.edit,
                            size: 20,
                          ),
                          onPressed: () => _editActivity(day, slot),
                        ),
                        if (activity != null)
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("মুছে ফেলুন?"),
                                  content: const Text(
                                      "আপনি কি নিশ্চিত এই কাজটি মুছে ফেলতে চান?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("না"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("হ্যাঁ"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await _deleteActivity(activity['id']!, key);
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          constraints: BoxConstraints(maxWidth: _mobileView ? 700 : 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              BackButton(),

              //
              Text(widget.scheduleName),

              //
              IconButton(
                tooltip: _mobileView ? 'টেবিল ভিউ দেখুন' : 'মোবাইল ভিউ দেখুন',
                icon: Icon(_mobileView ? Icons.grid_view : Icons.view_list),
                onPressed: () => setState(() => _mobileView = !_mobileView),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(maxWidth: _mobileView ? 700 : 1200),
            child: _mobileView ? _buildMobileList() : _buildTable(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "নতুন কাজ যুক্ত করুন",
        onPressed: () => _editActivity(null, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
