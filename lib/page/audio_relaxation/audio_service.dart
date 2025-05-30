import 'audio_model.dart';

class AudioService {
  static List<AudioTrack> fetchTracks() {
    return [
      AudioTrack(
        title: 'Ocean Waves',
        subtitle: 'Relaxing sea sounds',
        url:
            'https://firebasestorage.googleapis.com/v0/b/wellbeingclinicbd.appspot.com/o/audio%2Fdeep-relaxation-1.mp3?alt=media&token=4b2cdd03-f838-460a-afaf-3e3c67c776b8',
        coverUrl:
            'https://firebasestorage.googleapis.com/v0/b/wellbeingclinicbd.appspot.com/o/cover%2Frelaxation.png?alt=media&token=e49e62a0-6b92-4b31-a136-1e3d4478be4b',
        category: 'Relaxation',
      ),
    ];
  }

  static List<String> categories = [
    'All',
    'Relaxation',
    'Sleep',
    'Focus',
    'Anxiety Relief',
  ];
}
