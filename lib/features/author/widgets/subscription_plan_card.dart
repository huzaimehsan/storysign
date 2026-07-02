import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/color_constants.dart';
import '../../../../widgets/customText_widget.dart';
import '../../../../widgets/button_widget.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final List<String> features;
  final bool isMostPopular;
  final VoidCallback onSelect;

  const SubscriptionPlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.features,
    this.isMostPopular = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                text: title,
                fontFamily: "Poppins",
                color: secondryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),

              customText(
                text: price,
                fontFamily: "Poppins",
                color: buttonColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
             
            ],
          ),



          customText(
            text: subtitle,
            fontFamily: "Poppins",
            color: primaryColor.withOpacity(0.7),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),

          Divider(
            color:buttonColor,
            thickness: 0.8,
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map(
                  (feature) => Padding(
                    padding: EdgeInsets.only(bottom: 0.8.h),
                    child: Expanded(
                      child: customText(
                        text: feature,
                        fontFamily: "Poppins",
                        color: primaryColor.withOpacity(0.7),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 2.h),

          buttonWidget(
            'Select Plan',
            whiteColor,
            onTap: onSelect,
            colors: buttonColor,
            fontFamily: 'Poppins',
            height: 4.h,
            width: double.infinity,
            fontsize: 14.sp,
            fontweight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
