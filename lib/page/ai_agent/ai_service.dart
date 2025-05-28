// import 'dart:convert';
//
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
//
// class AiPsychologistService {
//   final _baseUrl = "https://openrouter.ai/api/v1/chat/completions";
//   final _model = "deepseek/deepseek-chat-v3-0324:free"; // from OpenRouter doc
//
//   Future<String> getResponse(String userMessage) async {
//     final apiKey = dotenv.env['OPENROUTER_API_KEY'];
//
//     final headers = {
//       'Authorization': 'Bearer $apiKey',
//       'Content-Type': 'application/json',
//       'HTTP-Referer': 'https://wellbeingclinic.web.app', // optional
//       'X-Title': 'WellbeingAI' // optional
//     };
//
//     final body = jsonEncode({
//       "model": _model,
//       "messages": [
//         {
//           "role": "system",
//           "content":
//               "তুমি একজন অভিজ্ঞ ও সহানুভূতিশীল বাংলাদেশি মনোবিজ্ঞানী যার নাম 'Wellbeing Clinic AI Assistant'। অংশগ্রহণকারীদের মানসিক স্বাস্থ্য সংক্রান্ত প্রশ্নগুলোর উত্তর দাও সহজ ও সহানুভূতিশীল ভাষায়, যেন তারা স্বস্তি পায়। ইংরেজি ব্যবহার করো না এবং উত্তরগুলোতে ইমোজি ব্যবহার কোরো না। যদি কেউ বিশেষজ্ঞের সাথে যোগাযোগ করতে চায়, তাহলে আমাদের হটলাইন +8801823161333, ফেসবুক https://fb.com/wellbeingclinicbd অথবা ওয়েবসাইট https://wellbeingclinic.vercel.app/contact জানাও।"
//         },
//         {"role": "user", "content": userMessage}
//       ]
//     });
//
//     final response =
//         await http.post(Uri.parse(_baseUrl), headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return decoded['choices'][0]['message']['content'];
//     } else {
//       print("Error: ${response.body}");
//       return "দুঃখিত, এখন উত্তর দেওয়া যাচ্ছে না। পরে আবার চেষ্টা করুন।";
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiPsychologistService {
  final _model = "gemini-1.5-flash"; // Changed to a generally available model

  Future<String> getResponse(String userMessage) async {
    final apiKey = dotenv.env['GEMINI_API_KEY']; // Make sure it's set correctly
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$apiKey";

    // System instruction as a 'model' role message
    final systemInstructionContent = {
      "role": "model",
      "parts": [
        {
          "text":
              "তুমি একজন অভিজ্ঞ ও সহানুভূতিশীল বাংলাদেশি মনোবিজ্ঞানী যার নাম 'Wellbeing Clinic AI Assistant'। অংশগ্রহণকারীদের মানসিক স্বাস্থ্য সংক্রান্ত প্রশ্নগুলোর উত্তর দাও সহজ ও সহানুভূতিশীল ভাষায়, যেন তারা স্বস্তি পায়। ইংরেজি ব্যবহার করো না এবং উত্তরগুলোতে ইমোজি ব্যবহার কোরো না। যদি কেউ বিশেষজ্ঞের সাথে যোগাযোগ করতে চায়, তাহলে আমাদের হটলাইন +8801823161333, ফেসবুক https://fb.com/wellbeingclinicbd অথবা ওয়েবসাইট https://wellbeingclinic.vercel.app/contact জানাও। কিন্তু বারবার যোগাযোগ তথ্য দেওয়া হবে না।"
        }
      ]
    };

    final body = jsonEncode({
      "contents": [
        systemInstructionContent, // Include the system instruction here
        {
          "role": "user", // Explicitly define user role
          "parts": [
            {"text": userMessage}
          ]
        }
      ]
    });

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['candidates']?[0]['content']?['parts']?[0]['text'];
      return content ?? "দুঃখিত, কোনো উত্তর পাওয়া যায়নি।";
    } else {
      print("Error: ${response.body}");
      return "দুঃখিত, এখন উত্তর দেওয়া যাচ্ছে না। পরে আবার চেষ্টা করুন।";
    }
  }
}
