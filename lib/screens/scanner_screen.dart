import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

// Import screens และ components ที่แยกออกมา
import '../screens/plant_detail_screen.dart';
import '../screens/error_screen.dart';
import '../painters/crosshair_painter.dart';
import '../widgets/camera_overlay.dart';
import '../widgets/bottom_controls.dart';
import '../widgets/processing_overlay.dart';
import '../services/plant_analyzer.dart';
import '../screens/plant_scan_result_screen.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;
  bool _flashOn = false;
  bool _cameraActive = true;
  int _selectedCameraIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  final ImagePicker _picker = ImagePicker();
  final PlantAnalyzer _plantAnalyzer = PlantAnalyzer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![_selectedCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    try {
      setState(() => _isProcessing = true);

      // Haptic feedback
      HapticFeedback.mediumImpact();

      // Focus animation
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      // Capture image
      final XFile image = await _cameraController!.takePicture();

      // Process image using PlantAnalyzer
      await _plantAnalyzer.processPlantImage(
        imagePath: image.path,
        onSuccess: (result) {
          setState(() => _isProcessing = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantScanResultScreen(
                scannedPlantName: result.plantName,
                accuracy: (result.confidence * 100).toInt(),
              ),
            ),
          );
        },
        onError: () {
          setState(() => _isProcessing = false);
          _showError();
        },
      );
    } catch (e) {
      print('Error capturing image: $e');
      setState(() => _isProcessing = false);
      _showError();
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _isProcessing = true);
        await _plantAnalyzer.processPlantImage(
          imagePath: image.path,
          onSuccess: (result) {
            setState(() => _isProcessing = false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantScanResultScreen(
                  scannedPlantName: result.plantName,
                  accuracy: (result.confidence * 100).toInt(),
                ),
              ),
            );
          },
          onError: () {
            setState(() => _isProcessing = false);
            _showError();
          },
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _toggleFlash() async {
    if (_cameraController != null) {
      try {
        await _cameraController!.setFlashMode(
          _flashOn ? FlashMode.off : FlashMode.torch,
        );
        setState(() => _flashOn = !_flashOn);
        HapticFeedback.selectionClick();
      } catch (e) {
        print('Error toggling flash: $e');
      }
    }
  }

  void _switchCamera() async {
    if (_cameras != null && _cameras!.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      await _cameraController?.dispose();
      await _initializeCamera();
      HapticFeedback.selectionClick();
    }
  }

  void _showError() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ErrorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'จำแนกพืช',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _flashOn ? Icons.flash_on : Icons.flash_off,
              color: _flashOn ? Colors.yellow : Colors.white,
            ),
            onPressed: _toggleFlash,
          ),
          if (_cameras != null && _cameras!.length > 1)
            IconButton(
              icon: Icon(Icons.flip_camera_ios, color: Colors.white),
              onPressed: _switchCamera,
            ),
        ],
      ),
      body: Stack(
        children: [
          _buildCameraView(),
          CameraOverlay(),
          if (_isProcessing) ProcessingOverlay(),
          BottomControls(
            onCapture: _captureAndAnalyze,
            onGallery: _pickFromGallery,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
              SizedBox(height: 16),
              Text(
                'เริ่มต้นกล้อง...',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: AnimatedBuilder(
        animation: _focusAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _focusAnimation.value,
            child: CameraPreview(_cameraController!),
          );
        },
      ),
    );
  }
}
