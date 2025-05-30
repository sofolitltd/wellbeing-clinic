import 'package:flutter/material.dart';

import 'audio_model.dart';

class AudioCard extends StatelessWidget {
  final AudioTrack track;
  final VoidCallback onTap;

  const AudioCard({super.key, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12.withValues(alpha: .1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Image.network(
          track.coverUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(track.title),
        subtitle: Text(track.subtitle),
        onTap: onTap,
      ),
    );
  }
}
