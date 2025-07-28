import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

// Import screens ที่แยกออกมา
import '../screens/plant_detail_screen.dart';
import '../screens/error_screen.dart';
import '../painters/crosshair_painter.dart';

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

      // Simulate plant analysis processing
      await _processPlantImage(image.path);
    } catch (e) {
      print('Error capturing image: $e');
      setState(() => _isProcessing = false);
      _showError();
    }
  }

  Future<void> _processPlantImage(String imagePath) async {
    // TODO: ใส่ Roboflow AI model ตรงนี้
    // Simulate AI processing time
    await Future.delayed(Duration(seconds: 3));

    setState(() => _isProcessing = false);

    // Simulate random success/failure for demo
    final isSuccess = DateTime.now().millisecond % 3 != 0;

    if (isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantDetailScreen(imagePath: imagePath),
        ),
      );
    } else {
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
        await _processPlantImage(image.path);
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
          _buildCameraOverlay(),
          if (_isProcessing) _buildProcessingOverlay(),
          _buildBottomControls(),
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

  Widget _buildCameraOverlay() {
    return Container(
      child: Stack(
        children: [
          // Dark overlay with transparent center
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
          ),
          // Focus guide
          _buildFocusGuide(),
          // Instructions
          _buildInstructions(),
        ],
      ),
    );
  }

  Widget _buildFocusGuide() {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.greenAccent.withOpacity(0.8),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Corner indicators
            _buildCornerIndicators(),
            // Center cross
            Center(
              child: Container(
                width: 40,
                height: 40,
                child: CustomPaint(painter: CrosshairPainter()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerIndicators() {
    return Stack(
      children: [
        // Top corners
        Positioned(top: -2, left: -2, child: _buildCornerIndicator()),
        Positioned(
          top: -2,
          right: -2,
          child: Transform.rotate(
            angle: 1.5708,
            child: _buildCornerIndicator(),
          ),
        ),
        // Bottom corners
        Positioned(
          bottom: -2,
          left: -2,
          child: Transform.rotate(
            angle: -1.5708,
            child: _buildCornerIndicator(),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Transform.rotate(
            angle: 3.14159,
            child: _buildCornerIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildCornerIndicator() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.greenAccent, width: 4),
          left: BorderSide(color: Colors.greenAccent, width: 4),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_florist,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ถ่ายรูปดอกไม้หรือใบพืชในกรอบ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(32),
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      strokeWidth: 5,
                    ),
                    Center(
                      child: Icon(
                        Icons.local_florist,
                        color: Colors.green,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                '🔍 กำลังวิเคราะห์พืช',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'กำลังจำแนกชนิดพืชจากรูปภาพ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'โปรดรอสักครู่...',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.photo_library,
                label: 'คลัง',
                onPressed: _pickFromGallery,
              ),
              _buildCaptureButton(),
              _buildControlButton(
                icon: Icons.history,
                label: 'ประวัติ',
                onPressed: () {
                  // TODO: Show identification history
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _captureAndAnalyze,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(Icons.camera_alt, size: 35, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'ถ่ายรูป',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
