// import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// import '../model/extra_result_model.dart' show ExtraResultModel;
// import '../model/item_model.dart';
// import '../model/result_model.dart';
//
// Future<void> generateAndPrintResult({
//   required ExtraResultModel extra,
//   required List<ItemModel> items,
//   required Map<int, int> resultMap,
//   required ResultModel result,
// }) async {
//   final pdf = pw.Document();
//
//   // Load Bangla font
//   final loadFont = await FontManager.loadFont(GetFonts.kalpurush);
//   final loadFontEn =
//       await rootBundle.load('assets/fonts/AnekBangla-Regular.ttf');
//
//   final banglaFont = pw.Font.ttf(loadFont);
//   final englishFont = pw.Font.ttf(loadFontEn);
//
//   pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       margin: const pw.EdgeInsets.all(20),
//       build: (context) => [
//         pw.Text(extra.title.fix(),
//             style: pw.TextStyle(
//                 fontSize: 18,
//                 font: englishFont,
//                 fontWeight: pw.FontWeight.bold)),
//         pw.SizedBox(height: 10),
//         pw.Text('স্কেল:'.fix(),
//             style: pw.TextStyle(fontSize: 14, font: banglaFont)),
//         pw.Wrap(
//           spacing: 5,
//           runSpacing: 5,
//           children: List.generate(
//             items.first.scale.length,
//             (index) {
//               final scale = items.first.scale[index];
//               final isLast = index == items.first.scale.length - 1;
//               return pw.Text(
//                   '${scale.id} = ${scale.title}${isLast ? '' : ', '}'.fix(),
//                   style: pw.TextStyle(fontSize: 13, font: banglaFont));
//             },
//           ),
//         ),
//         pw.SizedBox(height: 16),
//         pw.Table(
//           border: pw.TableBorder.all(),
//           defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
//           columnWidths: {
//             0: const pw.FlexColumnWidth(3),
//             for (int i = 1; i <= items.first.scale.length; i++)
//               i: const pw.FlexColumnWidth(1),
//           },
//           children: [
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(8),
//                   child: pw.Text('প্রশ্ন'.fix(),
//                       style: pw.TextStyle(
//                           fontSize: 13,
//                           fontWeight: pw.FontWeight.bold,
//                           font: banglaFont)),
//                 ),
//                 ...items.first.scale.map(
//                   (scale) => pw.Padding(
//                     padding: const pw.EdgeInsets.all(4),
//                     child: pw.Text(
//                       scale.id.toString().fix(),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontSize: 13,
//                           fontWeight: pw.FontWeight.bold,
//                           font: banglaFont),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             ...items.map(
//               (item) => pw.TableRow(
//                 children: [
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8),
//                     child: pw.Text(
//                       '${item.id}. ${item.title}'.fix(),
//                       style: pw.TextStyle(fontSize: 12, font: banglaFont),
//                     ),
//                   ),
//                   ...item.scale.map((scaleItem) {
//                     final selectedId = resultMap[item.id];
//                     final isSelected = selectedId == scaleItem.id;
//                     return pw.Padding(
//                       padding: const pw.EdgeInsets.all(6),
//                       child: pw.Center(
//                         child: isSelected
//                             ? pw.Text('*', style: pw.TextStyle(fontSize: 18))
//                             : pw.SizedBox(),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 10),
//         pw.Text('Score: ${extra.score}',
//             style: pw.TextStyle(
//                 fontSize: 14,
//                 fontWeight: pw.FontWeight.bold,
//                 font: englishFont)),
//         pw.Text('Status: ${result.status}',
//             style: pw.TextStyle(
//                 fontSize: 14,
//                 fontWeight: pw.FontWeight.bold,
//                 font: englishFont)),
//       ],
//     ),
//   );
//
//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }
