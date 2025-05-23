// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../model/extra_result_model.dart';
// import '../../model/result_model.dart';
// import '../../utils/set_tab_title.dart';
//
// class Result extends StatelessWidget {
//   const Result({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final extra = Get.arguments as ExtraResultModel;
//
//     if (extra == null) {
//       // Redirect to 404 or display an error screen
//       Future.microtask(() => Get.offNamed('/not-found'));
//       return const SizedBox.shrink(); // Placeholder while redirecting
//     }
//
//     final List<ResultModel> results = extra.resultModels;
//
//     //
//     setTabTitle('${extra.title} Result', context);
//
//     //
//
//     if (results.length == 1) {
//       // Single result: Display without TabBar
//       final result = results.first;
//
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('${extra.title} Result'),
//               IconButton(
//                 tooltip: 'Preview',
//                 onPressed: () {
//                   ExtraResultModel extras = ExtraResultModel(
//                     title: extra.title,
//                     route: extra.route,
//                     score: extra.score,
//                     resultModels: [result],
//                     resultMap: extra.resultMap,
//                   );
//                   Get.toNamed('/tests/${extra.route}/preview',
//                       arguments: extras);
//                 },
//                 icon: const Icon(Icons.preview),
//               ),
//             ],
//           ),
//           automaticallyImplyLeading: false,
//         ),
//         body: _buildResultCard(context, extra, result),
//       );
//     } else {
//       // Multiple results: Display with TabBar
//       return DefaultTabController(
//         length: results.length,
//         child: Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             title: Text('${extra.title} Results'),
//             bottom: TabBar(
//               isScrollable: true,
//               tabs: results.map((result) {
//                 return Tab(text: result.status);
//               }).toList(),
//             ),
//           ),
//           body: TabBarView(
//             children: results.map((result) {
//               return _buildResultCard(context, extra, result);
//             }).toList(),
//           ),
//         ),
//       );
//     }
//   }
//
//   Widget _buildResultCard(
//       BuildContext context, ExtraResultModel extra, ResultModel result) {
//     return Container(
//       padding:
//           // MediaQuery.of(context).size.width > 800
//           //     ? EdgeInsets.symmetric(vertical: 16, horizontal: Get.size.width * .2)
//           //     :
//           const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(top: 16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 8,
//             spreadRadius: 2,
//             color: Colors.black12,
//           ),
//         ],
//       ),
//       child: Center(
//         child: Container(
//           constraints: const BoxConstraints(
//             maxWidth: 700,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     spacing: 16,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildScoreAndStatus(result, extra.score),
//                       _buildSection(
//                           'Interpretation of Result', result.interpretation),
//                       _buildSection('Tips/Suggestions', result.suggestions),
//                       const Divider(height: 8, thickness: .5),
//                       _buildContactSection(),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//               _buildNavigationButtons(context, extra.route),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildScoreAndStatus(ResultModel result, int score) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: result.color.withValues(alpha: 0.2),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Score',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '$score',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: result.color,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 24),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Status',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   result.status,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: result.color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSection(String title, String content) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           content,
//           style: const TextStyle(fontSize: 15, height: 1.4),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildContactSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Contact for Counseling/Guidance',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             _buildContactOption(Icons.app_registration_outlined, 'Appointment',
//                 Colors.grey.shade200),
//             const SizedBox(width: 12),
//             _buildContactOption(Icons.facebook_rounded, 'Facebook',
//                 Colors.blue.shade50, Colors.blue),
//             const SizedBox(width: 12),
//             _buildContactOption(
//                 Icons.add_call, 'WhatsApp', Colors.green.shade50, Colors.green),
//           ],
//         ),
//       ],
//     );
//   }
//
// // Update your function to handle tap:
//   Widget _buildContactOption(IconData icon, String label, Color bgColor,
//       [Color? iconColor]) {
//     // Define URL based on the label
//     String? url;
//     if (label == 'Appointment') {
//       url =
//           'https://calendar.google.com/calendar/u/0/appointments/schedules/AcZssZ3BkoHghLUj-bjY5X0Vese8nZulj3fPUd7FyNbdpdV-B9w5rhwQRjHF4jsSYfEdHx-dpOqXOfKv';
//     } else if (label == 'Facebook') {
//       url = 'https://www.facebook.com/wellbeingclinicbd';
//     } else if (label == 'WhatsApp') {
//       url = 'https://wa.me/+8801704340860'; // Replace with your WhatsApp number
//     }
//
//     return GestureDetector(
//       onTap: () async {
//         if (url != null && await canLaunchUrl(Uri.parse(url))) {
//           launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         child: Row(
//           children: [
//             Icon(icon, size: 16, color: iconColor),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavigationButtons(BuildContext context, String route) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Row(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Get.offAndToNamed('/tests/$route');
//             },
//             child: const Icon(Icons.refresh),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.offAllNamed('/');
//               },
//               child: const Text('Back to Home'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
