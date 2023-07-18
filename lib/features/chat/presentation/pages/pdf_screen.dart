import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfMessage extends StatefulWidget {
  final String pdfUrl;
  const PdfMessage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PdfMessageState createState() => _PdfMessageState();
}

class _PdfMessageState extends State<PdfMessage> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    var response = await http.get(Uri.parse(widget.pdfUrl));
    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/document.pdf");
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      pdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pdfPath == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return PDFView(filePath: pdfPath!);
    }
  }
}
