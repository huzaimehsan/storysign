import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/color_constants.dart';
import 'customText_widget.dart';

class FormattedRequestDate extends StatelessWidget {
  final String dateString;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;

  const FormattedRequestDate({
    super.key,
    required this.dateString,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color,
  });

  String _formatRequestDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM, hh:mm a').format(dateTime.toLocal());
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return customText(
      fontFamily: "Poppins",
      text: _formatRequestDate(dateString),
      color: color ?? secondryColor.withOpacity(0.7),
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}
