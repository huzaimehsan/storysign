// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../constants/color_constants.dart';
//
// class LoaderService {
//   static final LoaderService _instance = LoaderService._internal();
//
//   factory LoaderService() => _instance;
//
//   LoaderService._internal();
//
//   OverlayEntry? _overlayEntry;
//   final GlobalKey<_AnimatedLoaderState> _loaderKey = GlobalKey();
//
//   bool get isShowing => _overlayEntry != null;
//
//   void show({
//     String text = 'Loading...',
//     Color ringColor = buttonColor,
//     Color textColor = secondryColor,
//     Color cardColor = whiteColor,
//   }) {
//     if (isShowing) return;
//
//     final overlayContext = Get.overlayContext ?? Get.context;
//     if (overlayContext == null) return;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) {
//         return _AnimatedLoader(
//           key: _loaderKey,
//           text: text,
//           ringColor: ringColor,
//           textColor: textColor,
//           cardColor: cardColor,
//         );
//       },
//     );
//
//     Overlay.of(overlayContext)?.insert(_overlayEntry!);
//   }
//
//   void dismiss() {
//     final state = _loaderKey.currentState;
//     if (state != null) {
//       state.animateOut().then((_) {
//         _overlayEntry?.remove();
//         _overlayEntry = null;
//       });
//     } else {
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//     }
//   }
// }
//
// class _AnimatedLoader extends StatefulWidget {
//   final String text;
//   final Color ringColor;
//   final Color textColor;
//   final Color cardColor;
//
//   const _AnimatedLoader({
//     super.key,
//     required this.text,
//     required this.ringColor,
//     required this.textColor,
//     required this.cardColor,
//   });
//
//   @override
//   State<_AnimatedLoader> createState() => _AnimatedLoaderState();
// }
//
// class _AnimatedLoaderState extends State<_AnimatedLoader>
//     with TickerProviderStateMixin {
//   late AnimationController _entranceController;
//   late Animation<double> _fade;
//   late Animation<double> _scale;
//
//   late AnimationController _pulseController;
//   late Animation<double> _pulse;
//
//   late AnimationController _rotateController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Entrance/exit animation
//     _entranceController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//     );
//     _fade = CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
//     _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
//     );
//     _entranceController.forward();
//
//     // Continuous soft pulse (breathing) jab tak loader show hai
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1100),
//     )..repeat(reverse: true);
//     _pulse = Tween<double>(begin: 0.97, end: 1.03).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//
//     // Rotating gradient ring
//     _rotateController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..repeat();
//   }
//
//   Future<void> animateOut() async {
//     _pulseController.stop();
//     _rotateController.stop();
//     await _entranceController.reverse();
//   }
//
//   @override
//   void dispose() {
//     _entranceController.dispose();
//     _pulseController.dispose();
//     _rotateController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([_entranceController, _pulseController]),
//       builder: (context, child) {
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(
//                   sigmaX: 4 * _fade.value,
//                   sigmaY: 4 * _fade.value,
//                 ),
//                 child: Container(
//                   color: Colors.black.withOpacity(0.22 * _fade.value),
//                 ),
//               ),
//             ),
//             Center(
//               child: Opacity(
//                 opacity: _fade.value,
//                 child: Transform.scale(
//                   scale: _scale.value * _pulse.value,
//                   child: _LoaderCard(
//                     text: widget.text,
//                     ringColor: widget.ringColor,
//                     textColor: widget.textColor,
//                     cardColor: widget.cardColor,
//                     rotateController: _rotateController,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class _LoaderCard extends StatelessWidget {
//   final String text;
//   final Color ringColor;
//   final Color textColor;
//   final Color cardColor;
//   final AnimationController rotateController;
//
//   const _LoaderCard({
//     required this.text,
//     required this.ringColor,
//     required this.textColor,
//     required this.cardColor,
//     required this.rotateController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(22),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
//           decoration: BoxDecoration(
//             color: cardColor.withOpacity(0.22),
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(
//               color: cardColor.withOpacity(0.35),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 30,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 width: 46,
//                 height: 46,
//                 child: AnimatedBuilder(
//                   animation: rotateController,
//                   builder: (context, _) {
//                     return Transform.rotate(
//                       angle: rotateController.value * 6.2832, // 2*pi
//                       child: CustomPaint(
//                         painter: _GradientRingPainter(color: buttonColor),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 18),
//               Text(
//                 text,
//                 style: TextStyle(
//                   color: textColor,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: 'Poppins',
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _GradientRingPainter extends CustomPainter {
//   final Color color;
//
//   _GradientRingPainter({required this.color});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     final gradient = SweepGradient(
//       colors: [
//         color.withOpacity(0.0),
//         color.withOpacity(0.3),
//         color,
//       ],
//       stops: const [0.0, 0.6, 1.0],
//       startAngle: 0,
//       endAngle: 6.2832,
//     );
//
//     final paint = Paint()
//       ..shader = gradient.createShader(rect)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.5
//       ..strokeCap = StrokeCap.round;
//
//     canvas.drawArc(rect.deflate(2), 0, 6.2, false, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant _GradientRingPainter oldPainter) => false;
// }