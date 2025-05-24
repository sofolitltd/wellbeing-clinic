import 'package:flutter/material.dart';

class CBTPage extends StatefulWidget {
  const CBTPage({super.key});

  @override
  State<CBTPage> createState() => _CBTPageState();
}

class _CBTPageState extends State<CBTPage> {
  final PageController _pageController = PageController();
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());

  String _finalThoughtSummary = '';
  int _currentPageIndex = 0;

  // Professional and empathetic Bengali prompts with detailed descriptions
  final List<Map<String, String>> _cbtPromptsBn = const [
    {
      "title": "১. আপনার নেতিবাচক চিন্তাটি কী?",
      "description":
          "ঠিক কী চিন্তা আপনাকে কষ্ট দিচ্ছে? এটি একটি নির্দিষ্ট বাক্য বা চিত্র হতে পারে। যতটা সম্ভব সুনির্দিষ্টভাবে লিখুন।\nউদাহরণ: 'আমি যথেষ্ট ভালো নই', 'সবকিছু ব্যর্থ হবে', 'কেউ আমাকে বোঝে না'।",
      "hint": "আপনার নেতিবাচক চিন্তাটি লিখুন...",
    },
    {
      "title": "২. এই চিন্তাটি সমর্থন করে এমন কী প্রমাণ আছে?",
      "description":
          "কোন তথ্য, ঘটনা, বা অভিজ্ঞতা এই নেতিবাচক চিন্তাটিকে সমর্থন করে বলে আপনার মনে হয়? নিরপেক্ষভাবে চিন্তা করুন, আবেগপ্রবণ না হয়ে শুধু বাস্তব তথ্যগুলো লিখুন।",
      "hint": "আপনার প্রমাণ লিখুন...",
    },
    {
      "title": "৩. এই চিন্তার বিপক্ষে কী প্রমাণ আছে?",
      "description":
          "কোন তথ্য, ঘটনা, বা অভিজ্ঞতা এই চিন্তাটিকে মিথ্যা প্রমাণ করে বা এর বিপরীত? অন্য দৃষ্টিকোণ থেকে দেখুন, আপনার শক্তি বা ইতিবাচক দিকগুলো মনে করুন।",
      "hint": "বিপরীত প্রমাণ লিখুন...",
    },
    {
      "title": "৪. আপনার প্রিয় বন্ধু এই অবস্থায় থাকলে আপনি তাকে কী বলতেন?",
      "description":
          "যদি আপনার কোনো প্রিয় বন্ধু একই ধরনের সমস্যার সম্মুখীন হতেন এবং এই একই চিন্তা করতেন, আপনি তাকে কী পরামর্শ বা সান্ত্বনা দিতেন? নিজের প্রতিও সেই একই সহানুভূতি দেখান।",
      "hint": "বন্ধুকে যা বলতেন তা লিখুন...",
    },
    {
      "title": "৫. এখন আপনি কীভাবে একটি ভারসাম্যপূর্ণ চিন্তা গঠন করবেন?",
      "description":
          "উপরের তথ্যগুলো (সপক্ষে ও বিপক্ষে প্রমাণ এবং বন্ধুর প্রতি আপনার পরামর্শ) ব্যবহার করে, আপনার মূল নেতিবাচক চিন্তার একটি বাস্তবসম্মত, যৌক্তিক এবং স্বাস্থ্যকর বিকল্প তৈরি করুন। এটি এমন একটি চিন্তা যা সত্যের কাছাকাছি এবং আপনাকে ভালো অনুভব করতে সাহায্য করে।",
      "hint": "আপনার ভারসাম্যপূর্ণ চিন্তাটি লিখুন...",
    },
  ];

  final String _pageIntroBn =
      "কগনিটিভ বিহেভিওরাল থেরাপি (CBT) এর একটি শক্তিশালী কৌশল হলো **চিন্তা পুনর্গঠন** বা 'Thought Restructuring'। এটি আপনাকে নেতিবাচক চিন্তাভাবনা শনাক্ত করতে, সেগুলোকে চ্যালেঞ্জ করতে এবং আরও বাস্তবসম্মত ও স্বাস্থ্যকর চিন্তা দিয়ে প্রতিস্থাপন করতে সাহায্য করে। এই অনুশীলন আপনাকে মানসিক চাপ কমাতে এবং আবেগ নিয়ন্ত্রণ করতে সহায়তা করবে।";

  final String _pageDisclaimerBn =
      "**গুরুত্বপূর্ণ দ্রষ্টব্য:** এই অনুশীলনটি একটি সহায়ক টুল। এটি কোনো মানসিক রোগ নির্ণয় বা পেশাদার থেরাপির বিকল্প নয়। যদি আপনার গুরুতর মানসিক স্বাস্থ্য উদ্বেগ থাকে, তবে অনুগ্রহ করে একজন লাইসেন্সপ্রাপ্ত মানসিক স্বাস্থ্য পেশাদারের সাথে পরামর্শ করুন।";

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _goToNextPage() {
    // Only validate if it's a prompt page (not intro or summary)
    if (_currentPageIndex > 0 && _currentPageIndex <= _cbtPromptsBn.length) {
      if (_controllers[_currentPageIndex - 1].text.isEmpty &&
          _currentPageIndex <= _cbtPromptsBn.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("অনুগ্রহ করে এই ধাপটি পূরণ করুন।"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    if (_currentPageIndex < _cbtPromptsBn.length) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else if (_currentPageIndex == _cbtPromptsBn.length) {
      _generateFinalThoughtSummary();
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _generateFinalThoughtSummary() {
    _finalThoughtSummary = '''
''';
  }

  void _resetExercise() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _finalThoughtSummary = '';
      _currentPageIndex = 0;
    });
    _pageController.jumpToPage(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "CBT চিন্তা পুনর্গঠন",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.lightBlue.shade700,
        elevation: 4,
        centerTitle: true,
        leading: _currentPageIndex > 0 &&
                _currentPageIndex <= _cbtPromptsBn.length
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: _goToPreviousPage,
              )
            : null,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              // Progress Dots Indicator below AppBar
              if (_currentPageIndex > 0 &&
                  _currentPageIndex <= _cbtPromptsBn.length)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_cbtPromptsBn.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPageIndex == index + 1 ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPageIndex == index + 1
                              ? Colors.lightBlue.shade700
                              : Colors.lightBlue.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cbtPromptsBn.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildIntroPage();
                    } else if (index <= _cbtPromptsBn.length) {
                      final promptIndex = index - 1;
                      return _buildPromptPage(promptIndex);
                    } else {
                      return _buildSummaryPage();
                    }
                  },
                ),
              ),
              // Navigation Buttons at the bottom
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders for Different Pages ---

  Widget _buildIntroPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "চিন্তা পুনর্গঠন: একটি CBT কৌশল",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue.shade800,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _pageIntroBn,
            style: const TextStyle(
                fontSize: 17, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Text(
              _pageDisclaimerBn,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPromptPage(int promptIndex) {
    // Each prompt page gets its own Form with a unique key
    final GlobalKey<FormState> promptFormKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Form(
        key: promptFormKey, // Assign the unique key here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              _cbtPromptsBn[promptIndex]["title"]!,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _cbtPromptsBn[promptIndex]["description"]!,
              style: const TextStyle(
                  fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: _controllers[promptIndex],
              maxLines: promptIndex == 0 || promptIndex == 4 ? 5 : 4,
              decoration: InputDecoration(
                hintText: _cbtPromptsBn[promptIndex]["hint"],
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.lightBlue.shade400, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? "অনুগ্রহ করে এই ধাপটি পূরণ করুন।"
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "আপনার চিন্তা পুনর্গঠন সম্পন্ন হয়েছে!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "এখানে আপনার চিন্তার পরিবর্তনটি পর্যালোচনা করুন:", // Review your thought transformation here:
            style: const TextStyle(fontSize: 17, color: Colors.black87),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Original Negative Thought
                Text(
                  "মূল নেতিবাচক চিন্তা:", // Original Negative Thought:
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _controllers[0].text.isNotEmpty
                      ? _controllers[0].text
                      : "কোনো মূল চিন্তা দেওয়া হয়নি।",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Evidence Examined / Self-Compassion
                Text(
                  "প্রমাণ পর্যালোচনা এবং আত্ম-সহানুভূতি:", // Evidence Reviewed and Self-Compassion:
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "সপক্ষে প্রমাণ: ${_controllers[1].text.isNotEmpty ? _controllers[1].text : 'দেওয়া হয়নি।'}",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 8),
                Text(
                  "বিপক্ষে প্রমাণ: ${_controllers[2].text.isNotEmpty ? _controllers[2].text : 'দেওয়া হয়নি।'}",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 8),
                Text(
                  "বন্ধুকে যা বলতেন: ${_controllers[3].text.isNotEmpty ? _controllers[3].text : 'দেওয়া হয়নি।'}",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Balanced Thought
                Text(
                  "আপনার নতুন ভারসাম্যপূর্ণ চিন্তা:", // Your New Balanced Thought:
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _controllers[4].text.isNotEmpty
                      ? _controllers[4].text
                      : "কোনো ভারসাম্যপূর্ণ চিন্তা তৈরি হয়নি।",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            "অভিনন্দন! আপনি আপনার নেতিবাচক চিন্তাটিকে সফলভাবে একটি আরও বাস্তবসম্মত এবং ইতিবাচক দৃষ্টিকোণে রূপান্তরিত করেছেন। নিয়মিত এই অনুশীলনটি আপনার মানসিক স্বাস্থ্যে ইতিবাচক প্রভাব ফেলতে পারে।", // Congratulations! You have successfully transformed your negative thought into a more realistic and positive perspective. Regular practice of this exercise can positively impact your mental health.
            style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black54),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    String buttonText;
    IconData buttonIcon;
    Color buttonColor;
    VoidCallback onPressedAction;

    if (_currentPageIndex == 0) {
      buttonText = "শুরু করুন";
      buttonIcon = Icons.play_arrow;
      buttonColor = Colors.lightBlue.shade700;
      onPressedAction = _goToNextPage;
    } else if (_currentPageIndex == _cbtPromptsBn.length + 1) {
      buttonText = "আবার শুরু করুন";
      buttonIcon = Icons.refresh;
      buttonColor = Colors.lightBlue.shade500;
      onPressedAction = _resetExercise;
    } else {
      buttonText = "পরবর্তী";
      buttonIcon = Icons.arrow_forward;
      buttonColor = Colors.lightBlue.shade700;
      onPressedAction = _goToNextPage;
    }

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressedAction,
          label: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          icon: Icon(buttonIcon, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}
