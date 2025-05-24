import 'dart:async'; // Required for Timer

import 'package:flutter/material.dart';

// Assuming BreathingExerciseScreen is in a separate file, uncomment this import:
// import 'package:your_app_name/breathing_exercise_screen.dart';

// Define the different phases of the breathing exercise (if not in a separate file already)
enum BreathingPhase {
  prepare,
  inhale,
  hold,
  exhale,
  rest,
}

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> {
  // --- Exercise Configuration (now just for display in instructions) ---
  final int _inhaleDuration = 4; // seconds
  final int _holdDuration = 4; // seconds
  final int _exhaleDuration = 6; // seconds
  final int _restDuration = 2; // seconds between cycles

  // --- Introduction Texts (Bengali) ---
  final String _breathingIntroBn =
      "শ্বাস-প্রশ্বাস অনুশীলন হলো মানসিক চাপ (Stress) কমানো, উদ্বেগ (Anxiety) নিয়ন্ত্রণ করা এবং মনকে শান্ত করার একটি শক্তিশালী কৌশল। এটি আপনার মনোযোগ বর্তমান মুহূর্তে ফিরিয়ে আনতে এবং শরীর ও মনের মধ্যে ভারসাম্য তৈরি করতে সাহায্য করে। এই অনুশীলন আপনাকে গভীর এবং নিয়ন্ত্রিত শ্বাস-প্রশ্বাসের মাধ্যমে আপনার স্নায়ুতন্ত্রকে শান্ত করতে শেখাবে।";

  final String _breathingDisclaimerBn =
      "**গুরুত্বপূর্ণ সতর্কতা:**\n- গুরুতর শ্বাসযন্ত্রের বা হৃদরোগ থাকলে অনুশীলনের আগে ডাক্তারের পরামর্শ নিন।\n- যদি মাথা ঘোরা বা অস্বস্তি অনুভব করেন, অবিলম্বে অনুশীলন বন্ধ করুন।\n- এটি চিকিৎসার বিকল্প নয়, বরং সহায়ক একটি কৌশল।";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Consistent white background
      appBar: AppBar(
        title: const Text(
          'শ্বাস প্রশ্বাস অনুশীলন', // Breathing Exercise
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.lightBlue.shade700, // Consistent AppBar color
        elevation: 4, // Consistent shadow for depth
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0), // Consistent padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Introduction Section ---
                      _buildIntroSection(),

                      const SizedBox(height: 30),

                      // --- Disclaimer/Precautions Section ---
                      _buildDisclaimerSection(),

                      const SizedBox(height: 30),

                      // --- Instructions Section (Expandable) ---
                      _buildInstructionsSection(),
                    ],
                  ),
                ),
              ),
              // --- Action Button (Start Exercise) ---
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the new BreathingExerciseScreen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                const BreathingExerciseScreen()),
                      );
                    },
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    label: const Text(
                      'অনুশীলন করুন', // Start Exercise
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the introduction section
  Widget _buildIntroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'শ্বাস-প্রশ্বাস অনুশীলন: উদ্দেশ্য ও উপকারিতা', // Breathing Exercise: Purpose and Benefits
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue.shade800,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          _breathingIntroBn,
          style: const TextStyle(
            fontSize: 17,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Builds the disclaimer/precautions section
  Widget _buildDisclaimerSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Text(
        _breathingDisclaimerBn,
        style: TextStyle(
          fontSize: 13,
          color: Colors.red.shade700,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  // Builds the instructions section of the app
  Widget _buildInstructionsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50, // Lighter background for this section
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.lightBlue.shade100), // Subtle border
      ),
      child: Theme(
        // Use Theme to override default ExpansionTile color
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // No divider line in ExpansionTile
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary:
                    Colors.lightBlue.shade700, // Color for ExpansionTile icon
              ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExpansionTile(
            initiallyExpanded: false, // Instructions are initially collapsed
            title: const Text(
              'কিভাবে শ্বাস প্রশ্বাস অনুশীলন করবেন?', // How to do Breathing Exercises?
              style: TextStyle(
                fontSize: 18, // Consistent font size for section titles
                fontWeight: FontWeight.w600,
                color: Colors.lightBlue, // Consistent color
              ),
            ),
            childrenPadding: const EdgeInsets.all(20.0),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstructionPoint(
                    '১. একটি শান্ত জায়গা খুঁজুন:', // 1. Find a quiet place:
                    'একটি শান্ত পরিবেশে আরাম করে বসুন বা শুয়ে পড়ুন যেখানে আপনাকে কেউ বিরক্ত করবে না।', // Sit or lie down comfortably in a calm environment where you won't be disturbed.
                  ),
                  _buildInstructionPoint(
                    '২. ভঙ্গি:', // 2. Posture:
                    'যদি বসে থাকেন, তাহলে আপনার পিঠ সোজা কিন্তু শিথিল রাখুন। যদি শুয়ে থাকেন, তাহলে এক হাত বুকে এবং অন্য হাত পেটে রাখুন।', // If sitting, keep your back straight but relaxed. If lying down, place one hand on your chest and the other on your abdomen.
                  ),
                  _buildInstructionPoint(
                    '৩. স্বাভাবিকভাবে শ্বাস নিন:', // 3. Breathe naturally:
                    'নিজেকে শান্ত করার জন্য কয়েকবার স্বাভাবিক শ্বাস নিন।', // Take a few normal breaths to settle yourself.
                  ),
                  _buildInstructionPoint(
                    '৪. গভীরভাবে শ্বাস নিন (${_inhaleDuration} সেকেন্ড):', // 4. Inhale deeply (X seconds):
                    '${_inhaleDuration} গণনা ধরে ধীরে ধীরে এবং গভীরভাবে নাক দিয়ে শ্বাস নিন। আপনার ডায়াফ্রাম প্রসারিত হওয়ার সাথে সাথে আপনার পেট উপরে উঠতে অনুভব করুন।', // Slowly and deeply inhale through your nose for X counts. Feel your abdomen rise as your diaphragm expands.
                  ),
                  _buildInstructionPoint(
                    '৫. শ্বাস ধরে রাখুন (${_holdDuration} সেকেন্ড):', // 5. Hold your breath (X seconds):
                    '${_holdDuration} গণনা ধরে আলতো করে শ্বাস ধরে রাখুন।', // Gently hold your breath for X counts.
                  ),
                  _buildInstructionPoint(
                    '৬. ধীরে ধীরে শ্বাস ছাড়ুন (${_exhaleDuration} সেকেন্ড):', // 6. Exhale slowly (X seconds):
                    '${_exhaleDuration} গণনা ধরে মুখ (বা নাক) দিয়ে ধীরে ধীরে শ্বাস ছাড়ুন, আলতো করে আপনার পেটের পেশী সংকুচিত করুন। আপনার পেট নিচে নামতে অনুভব করুন।', // Slowly exhale through your mouth (or nose) for X counts, gently contracting your abdominal muscles. Feel your abdomen fall.
                  ),
                  _buildInstructionPoint(
                    '৭. বিশ্রাম নিন (${_restDuration} সেকেন্ড):', // 7. Rest (X seconds):
                    '${_restDuration} গণনা ধরে বিশ্রাম নিন এবং পরবর্তী চক্রের জন্য প্রস্তুত হন।', // Rest for X counts and prepare for the next cycle.
                  ),
                  _buildInstructionPoint(
                    '৮. পুনরাবৃত্তি করুন:', // 8. Repeat:
                    'আপনার শ্বাস-প্রশ্বাসের ছন্দ এবং আপনার শরীরের অনুভূতির উপর মনোযোগ দিয়ে কয়েক মিনিট ধরে এই চক্রটি চালিয়ে যান।', // Continue this cycle for several minutes, focusing on the rhythm of your breath and the sensation in your body.
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build individual instruction points
  Widget _buildInstructionPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Consistent padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.4, // Consistent line height
            ),
          ),
        ],
      ),
    );
  }
}

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  // --- Exercise Configuration ---
  final int _inhaleDuration = 4; // seconds
  final int _holdDuration = 4; // seconds
  final int _exhaleDuration = 6; // seconds
  final int _restDuration = 2; // seconds between cycles

  // --- Exercise State Variables ---
  BreathingPhase _currentPhase = BreathingPhase.prepare;
  int _countdown = 0;
  Timer? _timer;
  bool _isExercising = false; // Flag to control if exercise is active

  // --- Animation Variables ---
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller specific to this screen
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Placeholder, will be updated
    );

    // Initial state for the animation (large circle for prepare phase,
    // as the first action is inhale which contracts)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      // Start large
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // IMPORTANT CHANGE: Removed the automatic start.
    // The exercise will now only begin when the user taps the 'Start Exercise' button.
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel any active timer
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  // --- Exercise Control Methods ---
  void _startExercise() {
    setState(() {
      _isExercising = true; // Set exercising flag to true
      _currentPhase = BreathingPhase.inhale; // Start with inhale
      _countdown = _inhaleDuration;
    });
    _startPhaseTimer(); // Start the timer for the current phase
    _startAnimation(BreathingPhase.inhale); // Start the animation
  }

  void _stopExercise() {
    _timer?.cancel(); // Stop the timer
    _animationController.stop(); // Stop the animation
    _animationController.reset(); // Reset animation to initial state
    setState(() {
      _isExercising = false; // Set exercising flag to false
      _currentPhase = BreathingPhase.prepare; // Reset to prepare phase
      _countdown = 0; // Reset countdown
      // Ensure the circle is in its initial large state when stopped
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    });
  }

  void _startPhaseTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        // Crucial check: if the widget is no longer in the widget tree,
        // cancel the timer to prevent errors.
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 0) {
          _countdown--; // Decrement countdown
        } else {
          _nextPhase(); // Move to the next phase when countdown reaches 0
        }
      });
    });
  }

  void _nextPhase() {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        _currentPhase = BreathingPhase.hold;
        _countdown = _holdDuration;
        _startAnimation(BreathingPhase.hold);
        break;
      case BreathingPhase.hold:
        _currentPhase = BreathingPhase.exhale;
        _countdown = _exhaleDuration;
        _startAnimation(BreathingPhase.exhale);
        break;
      case BreathingPhase.exhale:
        _currentPhase = BreathingPhase.rest; // Introduce a rest phase
        _countdown = _restDuration;
        _startAnimation(BreathingPhase.rest);
        break;
      case BreathingPhase.rest:
        _currentPhase = BreathingPhase.inhale; // Loop back to inhale
        _countdown = _inhaleDuration;
        _startAnimation(BreathingPhase.inhale);
        break;
      case BreathingPhase.prepare:
        // This case should ideally not be reached during an active exercise
        break;
    }
    _startPhaseTimer(); // Restart the timer for the new phase
  }

  void _startAnimation(BreathingPhase phase) {
    _animationController.stop(); // Stop any ongoing animation
    _animationController.reset(); // Reset to the start

    switch (phase) {
      case BreathingPhase.inhale:
        // INHALE: Circle contracts (starts large, goes small)
        _animationController.duration = Duration(seconds: _inhaleDuration);
        _scaleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.forward(); // Contract the circle
        break;
      case BreathingPhase.hold:
        // HOLD: Keep the circle contracted (stays small)
        _animationController.duration = Duration(seconds: _holdDuration);
        _scaleAnimation = Tween<double>(begin: 0.5, end: 0.5).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.forward(); // Keep it contracted
        break;
      case BreathingPhase.exhale:
        // EXHALE: Circle expands (starts small, goes large)
        _animationController.duration = Duration(seconds: _exhaleDuration);
        _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.forward(); // Expand the circle
        break;
      case BreathingPhase.rest:
        // REST: Keep the circle expanded (stays large)
        _animationController.duration = Duration(seconds: _restDuration);
        _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.forward();
        break;
      case BreathingPhase.prepare:
        // Prepare: Initial state, keep it large
        _animationController.duration =
            const Duration(milliseconds: 1); // Instant
        _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.forward();
        break;
    }
  }

  // Helper to get the current phase text
  String _getPhaseText() {
    switch (_currentPhase) {
      case BreathingPhase.prepare:
        return 'শুরু করতে প্রস্তুত?'; // Ready to start?
      case BreathingPhase.inhale:
        return 'শ্বাস টানুন'; // Inhale (more direct translation for contraction)
      case BreathingPhase.hold:
        return 'ধরে রাখুন'; // Hold
      case BreathingPhase.exhale:
        return 'শ্বাস ছাড়ুন'; // Exhale
      case BreathingPhase.rest:
        return 'বিশ্রাম'; // Rest
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'শ্বাস প্রশ্বাস অনুশীলন', // Breathing Exercise
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.lightBlue.shade700,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _stopExercise(); // Stop exercise before navigating back
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Breathing Animation Circle
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlue.shade400,
                        Colors.lightBlue.shade700
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _getPhaseText(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Countdown Text (only visible if exercise is active)
              _isExercising
                  ? Text(
                      '$_countdown সেকেন্ড', // seconds in Bengali
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue.shade700,
                      ),
                    )
                  : const SizedBox(
                      height: 24), // Keep some spacing if not exercising
              const SizedBox(height: 30),
              // Start/Stop Buttons
              _isExercising
                  ? ElevatedButton.icon(
                      onPressed: _stopExercise,
                      icon: const Icon(Icons.stop, color: Colors.white),
                      label: const Text(
                        'অনুশীলন বন্ধ করুন', // Stop Exercise
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed:
                          _startExercise, // Call _startExercise on button press
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        'অনুশীলন শুরু করুন', // Start Exercise
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue.shade700,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
