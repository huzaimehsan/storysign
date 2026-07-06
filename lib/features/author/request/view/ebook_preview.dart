import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../widgets/subscription_header_widget.dart';
import '../../../../widgets/button_widget.dart';
import '../controller/ebook_preview_controller.dart';

class BookPreviewPage extends GetView<EbookPreviewController> {
  const BookPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: customHeaderAuthor(
                context: context,
                title: 'Ebook Preview',
                onBack: () => Get.back(),
                onIconPressed: () {},
              ),
            ),
            SizedBox(height: 4.h),
        
            // PDF Document View container
            Container(
              height: 48.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: white, // warm cream background
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(color: Colors.white.withAlpha(64), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(89),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SfPdfViewer.asset(
                      'assets/book/pdf.pdf',
                      controller: controller.pdfViewerController,
                      onDocumentLoaded: controller.onDocumentLoaded,
                      onPageChanged: controller.onPageChanged,
                      pageLayoutMode: PdfPageLayoutMode.single,
                      onZoomLevelChanged: controller.onZoomLevelChanged,
                      scrollDirection: PdfScrollDirection.horizontal,

                      canShowScrollHead: false,
                      canShowScrollStatus: false,
                      canShowPaginationDialog: false,

                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
        
            SizedBox(height: 5.h),
        
            // Zoom Controls Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: controller.zoomIn,
                  child: Icon(Icons.zoom_in, color: bottomNavColor, size: 7.w),
                ),
                SizedBox(width: 3.w),
                Obx(() => Text(
                  "${(controller.zoomLevel.value * 100).toInt()}%",
                  style: TextStyle(
                    color: bottomNavColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                )),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: controller.zoomOut,
                  child: Icon(Icons.zoom_out, color: bottomNavColor, size: 7.w),
                ),
              ],
            ),
        
            SizedBox(height: 2.h),
        
            // Page Navigation Controls Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: controller.previousPage,
                  child: Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: bottomNavColor, width: 1.5),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: bottomNavColor,
                      size: 4.w,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Obx(() => Text(
                  "${controller.currentPage.value} of ${controller.pageCount.value}",
                  style: TextStyle(
                    color: bottomNavColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                )),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: controller.nextPage,
                  child: Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: bottomNavColor, width: 1.5),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: bottomNavColor,
                      size: 4.w,
                    ),
                  ),
                ),
              ],
            ),
        
        SizedBox(height: 6.h,),
        
            // "Sign This Page" Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: buttonWidget(
                "Sign This Page",
                whiteColor,
                colors: buttonColor,
                onTap: (){
                  Navigator.of(context).pushNamed('/drawSignature');

                },
                fontFamily: 'Poppins',
                height: 5.5.h,
                width: double.infinity,
                fontsize: 16.sp,
                fontweight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}