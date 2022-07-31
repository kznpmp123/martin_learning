import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViewScreen extends StatelessWidget {
  final String pdf;
  final String title;
  const PDFViewScreen({Key? key, required this.pdf, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(title,
            style: const TextStyle(
              color: Colors.black,
            )),
      ),
      body: Container(
        child: PDF(
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
        ).fromUrl(pdf),
      ),
    );
  }
}
