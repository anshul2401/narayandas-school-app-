import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintBill extends StatefulWidget {
  final List<String?> images;
  const PrintBill({Key? key, required this.images}) : super(key: key);

  @override
  _PrintBillState createState() => _PrintBillState();
}

class _PrintBillState extends State<PrintBill> {
  List i = [];

  @override
  void initState() {
    widget.images.forEach((element) async {
      i.add(await networkImage(element!));
    });
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: getNormalText('Documents', 15, Colors.white)),
      body: PdfPreview(
        build: (format) => _generatePdf(format, 'title'),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return i.map((e) {
          return pw.Container(
            height: 500,
            width: 500,
            child: pw.Center(child: pw.Image(e)),
          );
        }).toList();
      },
    ));

    return pdf.save();
  }
}
