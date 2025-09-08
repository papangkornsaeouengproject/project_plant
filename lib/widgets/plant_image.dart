import 'package:flutter/material.dart';

class PlantImage extends StatelessWidget {
  final String? plantIcon; // fallback
  final String? imageUrl;  // URL จาก Firebase/Cloudinary

  const PlantImage({
    Key? key,
    this.plantIcon = "🌿",
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      final safeUrl = Uri.encodeFull(imageUrl!.trim());
     child = Image.network(
  imageUrl!.trim(),
  fit: BoxFit.cover,
  width: double.infinity,
  height: double.infinity,
  loadingBuilder: (c, w, p) =>
      p == null ? w : const Center(child: CircularProgressIndicator()),
  errorBuilder: (c, e, st) {
    debugPrint('❌ Image load error: $e');
    debugPrint('URL: $imageUrl');
    return const Icon(Icons.broken_image, size: 64, color: Colors.grey);
  },
);
    } else {
      child = Text(
        plantIcon ?? "🌿",
        style: const TextStyle(fontSize: 64),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      height: 350,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F5E8), Color(0xFFC8E6C8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Center(child: child),
      ),
    );
  }
}
