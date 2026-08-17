import 'dart:typed_data';
import 'package:get/get.dart';

class RequestService extends GetxService {
  String autographRequestId = '';
  String bookPdfUrl = '';
  int currentPage = 1;

  Uint8List? signatureBytes;

  // Placement parameters for API
  int pageIndex = 0; // 0-based
  double xRatio = 0.15;
  double yRatio = 0.82;
  double widthRatio = 0.25;
  double heightRatio = 0.08;
  double pageWidthPts = 612.0;
  double pageHeightPts = 792.0;

  // Reader & Ebook metadata for review screen
  String readerName = 'Reader';
  String readerImagePath = '';
  String bookTitle = 'Ebook';
  String coverImage = '';

  static RequestService get find {
    if (!Get.isRegistered<RequestService>()) {
      return Get.put(RequestService(), permanent: true);
    }
    return Get.find<RequestService>();
  }

  void setRequestData(String id, {String? pdfUrl, int? page, String? rName, String? rImage, String? bTitle, String? cImage}) {
    if (id.isNotEmpty) autographRequestId = id;
    if (pdfUrl != null && pdfUrl.isNotEmpty) bookPdfUrl = pdfUrl;
    if (page != null) currentPage = page;
    if (rName != null && rName.isNotEmpty) readerName = rName;
    if (rImage != null && rImage.isNotEmpty) readerImagePath = rImage;
    if (bTitle != null && bTitle.isNotEmpty) bookTitle = bTitle;
    if (cImage != null && cImage.isNotEmpty) coverImage = cImage;
    print('RequestService - ID: $autographRequestId, Page: $currentPage, PDF: $bookPdfUrl');
  }

  void setPlacementData({
    required Uint8List bytes,
    required int pageIdx,
    required double xR,
    required double yR,
    required double wR,
    required double hR,
    double pW = 612.0,
    double pH = 792.0,
  }) {
    signatureBytes = bytes;
    pageIndex = pageIdx;
    xRatio = xR;
    yRatio = yR;
    widthRatio = wR;
    heightRatio = hR;
    pageWidthPts = pW;
    pageHeightPts = pH;
    print('RequestService Placement set - PageIdx: $pageIdx, xRatio: $xR, yRatio: $yR');
  }

  void clear() {
    autographRequestId = '';
    bookPdfUrl = '';
    currentPage = 1;
    signatureBytes = null;
    pageIndex = 0;
    xRatio = 0.15;
    yRatio = 0.82;
    widthRatio = 0.25;
    heightRatio = 0.08;
    pageWidthPts = 612.0;
    pageHeightPts = 792.0;
    readerName = 'Reader';
    readerImagePath = '';
    bookTitle = 'Ebook';
    coverImage = '';
  }
}
