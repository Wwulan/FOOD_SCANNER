import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Business logic controller handling camera peripherals and image file caching.
class ScannerController {
  final ImagePicker _picker = ImagePicker();
  File? _capturedImage;

  /// Returns the current active image cached in memory.
  File? get capturedImage => _capturedImage;

  /// Triggers the device camera to capture a new food sample image matrix.
  Future<File?> captureImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Optimized resolution to save memory and API payload bandwidth
      );
      
      if (photo != null) {
        _capturedImage = File(photo.path);
        return _capturedImage;
      }
    } catch (e) {
      print('Hardware Camera Integration Failure: $e');
    }
    return null;
  }

  /// Opens the local device gallery to import an existing image.
  Future<File?> importImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        _capturedImage = File(image.path);
        return _capturedImage;
      }
    } catch (e) {
      print('Gallery Storage Access Failure: $e');
    }
    return null;
  }

  /// Clears the active image cache from operational memory.
  void clearCache() {
    _capturedImage = null;
  }
}