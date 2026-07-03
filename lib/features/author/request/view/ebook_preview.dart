import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookPreviewPage extends StatelessWidget {
  // PDF controller navigation ke liye
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ebook Preview"),
      ),
      // PDF yahan load hogi
      body: SfPdfViewer.asset(
        'assets/books/sample_book.pdf',
        controller: _pdfViewerController,
      ),
      // Neeche wale navigation buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => _pdfViewerController.previousPage(),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () => _pdfViewerController.nextPage(),
            ),
          ],
        ),
      ),
    );
  }
}