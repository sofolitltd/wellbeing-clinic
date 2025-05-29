import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  final Function(String) onNotesChanged;
  final String initialNotes;

  const NotesPage({
    super.key,
    required this.onNotesChanged,
    required this.initialNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anything you want to note',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            '(your feelings, thoughts, music, photos etc.)',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          //
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: TextEditingController(text: initialNotes),
              onChanged: onNotesChanged,
              maxLines: 8,
              minLines: 6,
              // expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Write the text...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16.0),
              ),
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }
}
