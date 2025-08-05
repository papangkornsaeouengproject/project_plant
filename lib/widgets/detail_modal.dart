  import 'package:flutter/material.dart';
  import '../models/plant_data.dart';

  class DetailModal extends StatelessWidget {
    final String type;
    final PlantData plantData;
    final VoidCallback onClose;

    const DetailModal({
      Key? key,
      required this.type,
      required this.plantData,
      required this.onClose,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      final detail = _getDetailContent();

      return Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      detail['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                detail['content']!,
              ],
            ),
          ),
        ),
      );
    }

    Map<String, dynamic> _getDetailContent() {
      switch (type) {
        case 'plant':
          return {
            'title': 'ข้อมูลพืช',
            'content': Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('ชื่อทางวิทยาศาสตร์', plantData.scienceName),
                const SizedBox(height: 12),
                _buildDetailItem('วงศ์', plantData.family),
                const SizedBox(height: 12),
                _buildDetailItem('ชื่อภาษาอังกฤษ', plantData.engName),
              ],
            ),
          };
        case 'water':
          return {
            'title': 'การรดน้ำ',
            'content': Text(
              plantData.water,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          };
        case 'light':
          return {
            'title': 'แสงแดด',
            'content': Text(
              plantData.light,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          };
        default:
          return {'title': '', 'content': const SizedBox()};
      }
    }

    Widget _buildDetailItem(String label, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
  }