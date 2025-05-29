import 'dart:convert';
import 'dart:io';

import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:web/web.dart' as web;

Future<void> generateAndOpenInvoice() async {
  // 1. Create a PDF document
  final pdf = pw.Document();

  // 2. Load Bangla font
  final fontData = await FontManager.loadFont(GetFonts.ruposhiBangla);
  final ttf = pw.Font.ttf(fontData);

  // 3. Add content to the PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text(
          'বেঁচে থাকার মত আনন্দ আর কিছুই নেই।'.fix(),
          style: pw.TextStyle(font: ttf, fontSize: 20),
        ),
      ),
    ),
  );

  if (kIsWeb) {
    print('Running on Web, triggering download...');
    final pdfBytes = await pdf.save();
    final base64Pdf = base64.encode(pdfBytes);

    web.HTMLAnchorElement()
      ..href =
          'data:application/octet-stream;charset=utf-16le;base64,$base64Pdf'
      ..setAttribute('download', 'fileName.pdf')
      ..click();
    print('Download triggered.');
    print('Download triggered.');
  }
  // 4. Save the PDF to a file
  final outputDir = await getApplicationDocumentsDirectory();
  final file = File("${outputDir.path}/example.pdf");
  await file.writeAsBytes(await pdf.save());

  // 5. Open the PDF
  await OpenFile.open(file.path);
}
