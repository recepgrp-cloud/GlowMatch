import 'dart:io';

import 'package:flutter/material.dart';

import '../services/image_service.dart';
import '../services/ai_service.dart';
import 'result_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImageService _imageService = ImageService();

  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickFromCamera() async {
    final image = await _imageService.pickFromCamera();

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final image = await _imageService.pickFromGallery();

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _analyzeImage() async {
  if (_selectedImage == null) return;

  setState(() {
    _isLoading = true;
  });

  final result = await AIService().analyzeFace();

  setState(() {
    _isLoading = false;
  });

  if (!mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ResultScreen(
        result: result,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text("GlowMatch AI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.pink.shade200),
              ),
              child: _selectedImage == null
                  ? const Icon(
                      Icons.face_retouching_natural,
                      size: 120,
                      color: Colors.pink,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: _pickFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Fotoğraf Çek"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text("Galeriden Seç"),
              ),
            ),

            const SizedBox(height: 25),

            if (_selectedImage != null)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _analyzeImage,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text("AI Analiz Et"),
                ),
              ),

            const SizedBox(height: 30),

            if (_isLoading)
              Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text(
                    "GlowMatch AI fotoğrafını analiz ediyor...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}