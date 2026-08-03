import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/constants/color_constants.dart';
import 'package:storysign/widgets/cover_image_widget.dart';

/// Widget 1: "Ready to Send" card — reader avatar + name, book cover + title
class ReadyToSendCard extends StatelessWidget {
  final String readerName;
  final String readerImagePath;
  final String ebookTitle;
  final String bookImagePath;

  const ReadyToSendCard({
    super.key,
    required this.readerName,
    required this.readerImagePath,
    required this.ebookTitle,
    required this.bookImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Column(
        children: [
          // ── Reader row ──
          Row(
            children: [
              Container(
                height: 12.w,
                width: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor.withAlpha(30),
                ),
                child: ClipOval(
                  child: CoverImageWidget(
                    assetPath: readerImagePath,
                    imageUrl: readerImagePath.startsWith('http://') || readerImagePath.startsWith('https://')
                        ? readerImagePath
                        : null,
                    fit: BoxFit.cover,
                    width: 12.w,
                    height: 12.w,
                    fallbackIcon: Icons.person,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.7),
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      const TextSpan(
                        text: 'Reader: ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: readerName,
                        style: const TextStyle(
                          color: secondryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // ── Ebook row ──
          Row(
            children: [
              Container(
                height: 12.w,
                width: 12.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.w),
                  color: Colors.grey.withOpacity(0.15),
                ),
                clipBehavior: Clip.hardEdge,
                child: bookImagePath.trim().isEmpty
                    ? Container(
                        color: Colors.grey.withOpacity(0.2),
                      )
                    : (bookImagePath.startsWith('http://') ||
                            bookImagePath.startsWith('https://')
                        ? Image.network(
                            bookImagePath,
                            fit: BoxFit.cover,
                            width: 12.w,
                            height: 12.w,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          )
                        : Image.asset(
                            bookImagePath,
                            fit: BoxFit.cover,
                            width: 12.w,
                            height: 12.w,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          )),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.7),
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      const TextSpan(
                        text: 'Ebook: ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: ebookTitle,
                        style: const TextStyle(
                          color: secondryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
