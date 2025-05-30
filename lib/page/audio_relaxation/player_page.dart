import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_model.dart';

class PlayerPage extends StatefulWidget {
  final AudioTrack track;

  const PlayerPage({super.key, required this.track});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioPlayer player;
  Duration? total;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    setupPlayer();
  }

  Future<void> setupPlayer() async {
    await player.setUrl(widget.track.url);
    player.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });
    player.durationStream.listen((d) {
      setState(() {
        total = d;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = player.playing;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.track.title,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // gradiant bg
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFbde3d0), // Very light cyan
                Color(0xFFf9feff), // Very light cyan
              ],
            ),
          ),
          child: Column(
            children: [
              //
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.track.coverUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(widget.track.title, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(widget.track.subtitle),
              const SizedBox(height: 16),
              Slider(
                value: position.inSeconds.toDouble(),
                max: (total?.inSeconds ?? 1).toDouble(),
                onChanged: (value) {
                  player.seek(Duration(seconds: value.toInt()));
                },
              ),
              Text("${_format(position)} / ${_format(total ?? Duration.zero)}"),
              const SizedBox(height: 16),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10),
                    onPressed: () {
                      player
                          .seek(player.position - const Duration(seconds: 10));
                    },
                  ),
                  IconButton.filledTonal(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                    ),
                    onPressed: () {
                      isPlaying ? player.pause() : player.play();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10),
                    onPressed: () {
                      player
                          .seek(player.position + const Duration(seconds: 10));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _format(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }
}
