import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/scanner_controller.dart';
import '../controllers/api_controller.dart';
import 'food_result_view.dart';

class HomeScannerView extends StatefulWidget {
  const HomeScannerView({super.key});

  @override
  State<HomeScannerView> createState() => _HomeScannerViewState();
}

class _HomeScannerViewState extends State<HomeScannerView> {
  final ScannerController _scannerController = ScannerController();
  final ApiController _apiController = ApiController();
  final TextEditingController _detailsController = TextEditingController(); // Controller untuk kolom detail
  File? _displayImage;
  bool _isAnalyzing = false;

  Future<void> _handleCameraCapture() async {
    final image = await _scannerController.captureImageFromCamera();
    if (image != null) {
      setState(() => _displayImage = image);
    }
  }

  Future<void> _handleGalleryImport() async {
    final image = await _scannerController.importImageFromGallery();
    if (image != null) {
      setState(() => _displayImage = image);
    }
  }

  Future<void> _executeFoodAnalysis() async {
    if (_displayImage == null) return;
    setState(() => _isAnalyzing = true);
    
    // Mengirimkan file gambar DAN teks catatan porsi dari user
    final resultModel = await _apiController.uploadAndAnalyzeFoodImage(
      _displayImage!, 
      _detailsController.text,
    );
    
    setState(() => _isAnalyzing = false);

    if (resultModel != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodResultView(
            imageFile: _displayImage!,
            foodData: resultModel,
          ),
        ),
      ).then((_) {
        // Opsional: bersihkan input setelah kembali ke dashboard
        _detailsController.clear();
      });
    }
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
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
      body: SingleChildScrollView( // Diubah ke scrollview biar pas ngetik keyboard gak overflow eror!
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container Panel Visual Foto Makanan
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 300, // Fixed height agar layout tetap seimbang
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

            // 🌟 INDIKATOR KECERDASAN UX: Kolom Input Detail Porsi Tambahan
            if (_displayImage != null) ...[
              const Text(
                'Additional Portion Specifications (Optional)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _detailsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g., siomay ikan 3, kol kukus 2, kentang 1, bumbu kacang terpisah',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Tombol Kontrol Kamera dan Galeri
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

            // Tombol Analisis AI Utama
            ElevatedButton.icon(
              onPressed: _displayImage == null || _isAnalyzing ? null : _executeFoodAnalysis,
              icon: _isAnalyzing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.analytics),
              label: Text(_isAnalyzing ? 'Analyzing Hybrid Metrics...' : 'Execute AI Diagnosis Session'),
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