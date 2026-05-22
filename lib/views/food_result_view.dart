import 'dart:io';
import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodResultView extends StatelessWidget {
  final File imageFile;
  final FoodModel foodData;

  const FoodResultView({
    super.key,
    required this.imageFile,
    required this.foodData,
  });

  @override
  Widget build(BuildContext context) {
    // Memisahkan catatan user agar tidak ikut looping di dalam list makronutrisi
    final macroEntries = foodData.macronutrients.entries
        .where((entry) => entry.key != 'User Note Matrix')
        .toList();
        
    final String? userNote = foodData.macronutrients['User Note Matrix'];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('AI Analysis Results', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Food Image Preview Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),

            // Main Identification Header Card (Menggunakan Wrap agar BEBAS OVERFLOW)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodData.foodName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    // Mengganti Row menjadi Wrap agar otomatis turun ke bawah jika layar sempit
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.verified, size: 14, color: Colors.green),
                          label: Text(foodData.accuracyStatus, style: const TextStyle(fontSize: 11)),
                          backgroundColor: Colors.green[50],
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        ),
                        Chip(
                          label: Text('Confidence: ${foodData.confidenceScore}%', style: const TextStyle(fontSize: 11)),
                          backgroundColor: Colors.orange[50],
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Energy Level Metrics Panel (Calories)
            Card(
              color: Colors.orange[50],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.orangeAccent, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Energy Yield', style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                        Text('Calculated Estimate', style: TextStyle(fontSize: 12, color: Colors.black38)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${foodData.calories.toInt()}',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange[900]),
                        ),
                        const SizedBox(width: 4),
                        Text('Kcal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange[900])),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Macronutrient Distribution Matrix Metrics Breakdown
            const Text(
              'Macronutrient Distribution Framework',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  children: macroEntries.map((entry) {
                    IconData macroIcon = Icons.fitness_center;
                    Color iconColor = Colors.grey;
                    
                    if (entry.key == 'Carbohydrates') { macroIcon = Icons.grain; iconColor = Colors.amber[700]!; }
                    if (entry.key == 'Protein') { macroIcon = Icons.egg; iconColor = Colors.red[400]!; }
                    if (entry.key == 'Fat') { macroIcon = Icons.opacity; iconColor = Colors.blue[400]!; }

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: iconColor.withOpacity(0.1),
                        child: Icon(macroIcon, color: iconColor, size: 18),
                      ),
                      title: Text(entry.key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      trailing: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // 🌟 PANEL BARU: Menampilkan Catatan Kustom Secara Horizontal Luas
            if (userNote != null && userNote.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'User Verification Specifications',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.grey[100],
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.assignment, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          userNote,
                          style: const TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.w500, 
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}