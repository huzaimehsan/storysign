import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/color_constants.dart';
import '../../../widgets/customText_widget.dart';

class RoleOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 15.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.sp),
            color: isSelected ? buttonColor : white,
            border: isSelected ? null : Border.all(color: buttonColor, width: 2),
          ),
          child: Row(
            children: [
              Icon(icon, size: 30.sp, color: isSelected ? white : buttonColor),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      color: isSelected ? white : buttonColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      text: title,
                    ),
                    SizedBox(height: 0.5.h),
                    customText(
                      color: isSelected ? white.withOpacity(0.8) : Colors.grey,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      text: description,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}