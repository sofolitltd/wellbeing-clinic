import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'audio_card.dart';
import 'audio_service.dart';
import 'player_page.dart';

class AudioRelaxationScreen extends StatefulWidget {
  const AudioRelaxationScreen({super.key});

  @override
  State<AudioRelaxationScreen> createState() => _AudioRelaxationScreenState();
}

class _AudioRelaxationScreenState extends State<AudioRelaxationScreen> {
  String selectedCategory = 'All';
  final tracks = AudioService.fetchTracks();

  @override
  Widget build(BuildContext context) {
    final filteredTracks = selectedCategory == 'All'
        ? tracks
        : tracks.where((t) => t.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relaxing Audio'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              // Filter bar
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: AudioService.categories.map((cat) {
                    final isSelected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // List of audio cards
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTracks.length,
                  itemBuilder: (context, index) {
                    final track = filteredTracks[index];
                    return AudioCard(
                      track: track,
                      onTap: () {
                        Get.to(() => PlayerPage(track: track));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
