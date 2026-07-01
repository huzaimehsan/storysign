import 'dart:async';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:flutter/material.dart';

class MyCameraDelegate extends ImagePickerCameraDelegate {
  // We use this to return the file back to the ImagePicker caller
  Completer<XFile?>? _completer;

  @override
  Future<XFile?> takePhoto({
    ImagePickerCameraDelegateOptions options = const ImagePickerCameraDelegateOptions(),
  }) async {
    _completer = Completer<XFile?>();

    // Trigger navigation to your custom camera screen
    // Make sure you pass the context or use a GlobalKey<NavigatorState>
    _openCustomCamera();

    return _completer!.future;
  }

  void _openCustomCamera() {
    // Navigate to your camera screen here
    // Navigator.of(context).push(...);
  }

  // Call this function from your Camera UI when the user clicks 'Capture'
  void onPhotoCaptured(XFile file) {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(file);
    }
  }

  @override
  Future<XFile?> takeVideo({
    ImagePickerCameraDelegateOptions options = const ImagePickerCameraDelegateOptions(),
  }) async {
    return null; // Handle video logic if needed
  }
}