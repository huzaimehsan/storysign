// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../../constants/color_constants.dart';
//
// class ProfileImagePicker extends StatefulWidget {
//   final String imageAssetPath;
//   final double size;
//   final VoidCallback? onImageTap;
//
//   const ProfileImagePicker({
//     super.key,
//     this.imageAssetPath = 'assets/png/searchprofile.png',
//     this.size = 30.0,
//     this.onImageTap,
//   });
//
//   @override
//   State<ProfileImagePicker> createState() => _ProfileImagePickerState();
// }
//
// class _ProfileImagePickerState extends State<ProfileImagePicker> {
//   XFile? _pickedFile;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _setUpCameraDelegate();
//   }
//
//   void _setUpCameraDelegate() {
//     final ImagePickerPlatform instance = ImagePickerPlatform.instance;
//     if (instance is CameraDelegatingImagePickerPlatform) {
//       instance.cameraDelegate = MyCameraDelegate();
//     }
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? file = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 80,
//       );
//       if (!mounted || file == null) return;
//       setState(() => _pickedFile = file);
//     } catch (_) {
//       // ignore: avoid_print
//       print('Image pick cancelled or failed');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double size = widget.size.w;
//
//     return Center(
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             height: size,
//             width: size,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: textFeildContainColor,
//               border: Border.all(color: whiteColor.withOpacity(0.2), width: 1.5),
//             ),
//             child: ClipOval(
//               child: _pickedFile == null
//                   ? Image.asset(
//                       widget.imageAssetPath,
//                       fit: BoxFit.cover,
//                     )
//                   : Image.file(
//                       File(_pickedFile!.path),
//                       fit: BoxFit.cover,
//                     ),
//             ),
//           ),
//           Positioned(
//             right: -1.w,
//             bottom: 2.w,
//             child: GestureDetector(
//               onTap: () {
//                 widget.onImageTap?.call();
//                 _pickImage();
//               },
//               child: Container(
//                 height: 8.w,
//                 width: 8.w,
//                 decoration: BoxDecoration(
//                   color: whiteColor,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: buttonColor, width: 1.2),
//                 ),
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: buttonColor,
//                   size: 4.w,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MyCameraDelegate extends ImagePickerCameraDelegate {
//   @override
//   Future<XFile?> takePhoto({
//     ImagePickerCameraDelegateOptions options = const ImagePickerCameraDelegateOptions(),
//   }) async {
//     return _takeAPhoto(options.preferredCameraDevice);
//   }
//
//   @override
//   Future<XFile?> takeVideo({
//     ImagePickerCameraDelegateOptions options = const ImagePickerCameraDelegateOptions(),
//   }) async {
//     return _takeAVideo(options.preferredCameraDevice);
//   }
//
//   Future<XFile?> _takeAPhoto(CameraDevice preferredCameraDevice) async {
//     return await ImagePicker().pickImage(
//       source: ImageSource.camera,
//       preferredCameraDevice: preferredCameraDevice,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 80,
//     );
//   }
//
//   Future<XFile?> _takeAVideo(CameraDevice preferredCameraDevice) async {
//     return await ImagePicker().pickVideo(
//       source: ImageSource.camera,
//       preferredCameraDevice: preferredCameraDevice,
//       maxDuration: const Duration(seconds: 30),
//     );
//   }
// }
