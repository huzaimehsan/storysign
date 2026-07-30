// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import 'package:storysign/features/reader/Home/controller/request_detail_model.dart';
// import 'package:storysign/features/reader/Home/widgets/reader/request_detail_widget.dart';
// import 'package:storysign/features/reader/Home/widgets/reader/custom_text_field_with_limit.dart';
// import 'package:storysign/features/reader/Home/widgets/reader/fee_field_with_price.dart';
// import 'package:storysign/features/reader/search/view/author_detail.dart';
//
// import '../../../../../constants/color_constants.dart';
// import '../../../../../widgets/author_detail_widget.dart';
// import '../../../../../widgets/button_widget.dart';
// import '../../../../../widgets/customText_widget.dart';
// import '../../../search/widgets/header_widget.dart';
//
//
//
// class RequestDetail extends GetView<AuthorDetailController> {
//   const RequestDetail({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final args = (Get.arguments is Map<String, dynamic>)
//         ? Get.arguments as Map<String, dynamic>
//         : ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//
//     final detailController = controller;
//     final String role = args?['role'] as String? ?? '';
//     final String authorId = args?['authorId']?.toString() ?? '';
//
//
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final requestId = args?['autographRequestId']?.toString() ??
//           args?['requestId']?.toString() ??
//           args?['id']?.toString();
//       if (requestId != null && requestId.isNotEmpty) {
//         detailController.setRequestId(requestId);
//       }
//     });
//
//     return Scaffold(
//       body: SafeArea(
//         child: Obx(() {
//           final data = detailController.selectedRequest.value;
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 customHeader(
//                   context: context,
//                   title: 'Request Detail',
//                   onBack: () => Get.back(),
//                   onIconPressed: () {},
//                 ),
//                 SizedBox(height: 2.h),
//                 if (detailController.isloading.value && data == null)
//                   SizedBox(
//                     height: 30.h,
//                     child: Center(
//                       child: CircularProgressIndicator(color: buttonColor),
//                     ),
//                   )
//                 else ...[
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 4.w),
//                     child: customText(
//                       fontFamily: "Poppins",
//                       text: "Book Detail",
//                       color: whiteColor,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 1.h),
//                   RequestDetailWidget(
//                     imagePath: data?.coverImage ?? '',
//                     bookTitle: data?.title ?? 'Loading...',
//                     status: data?.status ?? '',
//                   ),
//                   SizedBox(height: 1.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 4.w),
//                     child: customText(
//                       fontFamily: "Poppins",
//                       text: "About Author",
//                       color: whiteColor,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   AuthorInfoCard(
//                     imagePath: data?.author.profilePicture ?? "",
//                     bookTitle: data?.author.fullName ?? "Author",
//                     date: data?.author.dateJoined ?? "",
//                   ),
//                   SizedBox(height: 1.5.h),
//                   CustomMessageDisplay(
//                     label: 'Personal Message',
//                     message: "Data",
//                   ),
//                   SizedBox(height: 1.5.h),
//                   FeeFieldWithPrice(
//                     label: 'Signature Price',
//                     price: 'Fee',
//                     amount: data?.feeAmount.toString() ?? '',
//                   ),
//                   SizedBox(height: 7.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 4.w),
//                     child: buttonWidget(
//                       "Make Payment",
//                       fontsize: 16.sp,
//                       whiteColor,
//                       onTap: (){
//                         controller.selectedRequest.value;
//
//                       },
//                       colors: buttonColor,
//                       fontweight: FontWeight.w600,
//                       fontFamily: 'Poppins',
//                       height: 5.2.h,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                 ],
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
