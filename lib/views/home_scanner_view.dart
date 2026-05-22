import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/scanner_controller.dart';
import '../controllers/api_controller.dart'; // Import API Controller
import 'food_result_view.dart'; // Import Result View

class HomeScannerView extends StatefulWidget {
  const HomeScannerView({super.key});

  @override
  State<HomeScannerView> createState() => _HomeScannerViewState();
}

class _HomeScannerViewState extends State<HomeScannerView> {
  final ScannerController _scannerController = ScannerController();
  final ApiController _apiController = ApiController(); // Instantiate network channel
  File? _displayImage;
  bool _isAnalyzing = false;

  /// Handles camera initialization stream inside the view context
  Future<void> _handleCameraCapture() async {
    final image = await _scannerController.captureImageFromCamera();
    if (image != null) {
      setState(() => _displayImage = image);
    }
  }

  /// Handles local gallery asset fetching stream
  Future<void> _handleGalleryImport() async {
    final image = await _scannerController.importImageFromGallery();
    if (image != null) {
      setState(() => _displayImage = image);
    }
  }

  /// Executes image dispatch transactions to the network processing layer
  Future<void> _executeFoodAnalysis() async {
    if (_displayImage == null) return;
    setState(() => _isAnalyzing = true);
    
    // Fire image payload to cloud compute pipeline
    final resultModel = await _apiController.uploadAndAnalyzeFoodImage(_displayImage!);
    
    setState(() => _isAnalyzing = false);

    if (resultModel != null && mounted) {
      // Transition navigation stack matrix smoothly to the results interface dashboard
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodResultView(
            imageFile: _displayImage!,
            foodData: resultModel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Caloricity AI Terminal', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // High-Fidelity Visual Feed Container Panel
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: _displayImage != null
                    ? Image.file(_displayImage!, fit: BoxFit.cover)
                    : Container(
                        color: Colors.orange[50],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fastfood, size: 72, color: Colors.orange[300]),
                            const SizedBox(height: 16),
                            const Text(
                              'Deploy Food Image for AI Recognition Matrix',
                              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Dynamic Functional Capture Control Matrix Panel
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _handleCameraCapture,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera Roll'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _handleGalleryImport,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery Import'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Strategic Execution AI Pipeline Action Button
            ElevatedButton.icon(
              onPressed: _displayImage == null || _isAnalyzing ? null : _executeFoodAnalysis,
              icon: _isAnalyzing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.analytics),
              label: Text(_isAnalyzing ? 'Analyzing Nutritional Metrics...' : 'Execute AI Diagnosis Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}