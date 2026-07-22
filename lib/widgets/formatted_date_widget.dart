import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/color_constants.dart';
import 'customText_widget.dart';

class FormattedRequestDate extends StatelessWidget {
  final String dateString;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overFlow;
  final String dateFormat;

  const FormattedRequestDate({
    super.key,
    required this.dateString,
    this.fontFamily = "Poppins",
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overFlow,
    this.dateFormat = 'dd MMM, hh:mm a',
  });

  String _formatRequestDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat(dateFormat).format(dateTime.toLocal());
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return customText(
      fontFamily: fontFamily,
      text: _formatRequestDate(dateString),
      color: color ?? secondryColor.withOpacity(0.7),
      fontSize: fontSize,
      fontWeight: fontWeight,
      textAlign: textAlign,
      maxLines: maxLines,
      overFlow: overFlow,
    );
  }
}