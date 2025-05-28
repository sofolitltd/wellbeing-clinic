import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  final _aiService = AiPsychologistService();
  bool _isLoading = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    final reply = await _aiService.getResponse(text);

    setState(() {
      _messages.add({"role": "bot", "text": reply});
      _isLoading = false;
    });
    _scrollToBottom();
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    final text = message['text'] ?? "";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: SelectionArea(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.black12.withValues(alpha: 0.04)
                    : Colors.teal.shade50.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  SelectableText.rich(
                    _buildTextSpans(text),
                    textAlign: isUser ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
            if (!isUser)
              Positioned(
                right: 12,
                bottom: 8,
                child: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('কপি করা হয়েছে')),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  //
  TextSpan _buildTextSpans(String text) {
    final RegExp linkRegex = RegExp(
      r'(https?:\/\/[^\s]+|www\.[^\s]+|fb\.com\/[^\s]+|[\w\.-]+@[\w\.-]+\.\w{2,}|(?:\+88)?01[3-9]\d{8})',
    );

    final List<TextSpan> spans = [];
    final matches = linkRegex.allMatches(text);
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      final matchText = match.group(0)!;
      spans.add(
        TextSpan(
          text: matchText,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _launchUrl(matchText);
            },
        ),
      );
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return TextSpan(style: const TextStyle(fontSize: 16), children: spans);
  }

  //
  void _launchUrl(String rawUrl) async {
    try {
      String url = rawUrl.trim();

      // Add proper scheme if missing
      if (url.startsWith('http')) {
        // ok
      } else if (url.contains('@')) {
        url = 'mailto:$url';
      } else if (url.startsWith('+88') || url.startsWith('01')) {
        url = 'tel:$url';
      } else {
        url = 'https://$url';
      }

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching url: $e');
    }
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          spacing: 4,
          children: [
            SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                )),
            //
            const Text("আপনার উত্তর প্রস্তুত হচ্ছে...",
                style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wellbeing Clinic AI')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (_, index) {
                    if (index == _messages.length && _isLoading) {
                      return _buildTypingIndicator();
                    } else {
                      return _buildMessage(_messages[index]);
                    }
                  },
                ),
              ),
              // const Divider(height: 1),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ]),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'আপনার প্রশ্ন লিখুন...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      icon: Icon(
                        Icons.send_outlined,
                        size: 18,
                        color: _controller.text.trim().isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: _controller.text.trim().isNotEmpty
                          ? _sendMessage
                          : null,
                    ),
                  ],
                ),
              ),
              //
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '*এই চ্যাটবট একজন চিকিৎসকের বিকল্প নয়। জরুরি হলে বিশেষজ্ঞের সাথে যোগাযোগ করুন।',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
