import 'package:flutter/material.dart';
import '../models/plant_data.dart';

class CareIcons extends StatefulWidget {
  final PlantData plantData;
  final Function(String) onIconTap;

  const CareIcons({
    Key? key,
    required this.plantData,
    required this.onIconTap,
  }) : super(key: key);

  @override
  State<CareIcons> createState() => _CareIconsState();
}

class _CareIconsState extends State<CareIcons> {
  String? hoveredIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // Gradient background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.green.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        // Enhanced shadow with multiple layers
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        // Border with subtle gradient effect
        border: Border.all(
          color: Colors.green.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Decorative background elements
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.green.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -5,
            left: -5,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.03),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header with title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF14C273).withOpacity(0.15),
                            const Color(0xFF14C273).withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.spa_rounded,
                        color: Color(0xFF14C273),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'การดูแล',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF14C273),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF14C273).withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Care icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCareIcon(
                      icon: Icons.eco_rounded,
                      label: 'Plant',
                      subtitle: 'ข้อมูลพืช',
                      color: const Color(0xFF14C273),
                      type: 'plant',
                      onTap: () => widget.onIconTap('plant'),
                    ),
                    _buildCareIcon(
                      icon: Icons.water_drop_rounded,
                      label: 'Water',
                      subtitle: _getWaterSubtitle(),
                      color: const Color(0xFF2196F3),
                      type: 'water',
                      onTap: () => widget.onIconTap('water'),
                    ),
                    _buildCareIcon(
                      icon: Icons.wb_sunny_rounded,
                      label: 'Light',
                      subtitle: _getLightSubtitle(),
                      color: const Color(0xFFFF9800),
                      type: 'light',
                      onTap: () => widget.onIconTap('light'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWaterSubtitle() {
    final waterText = widget.plantData.water.toLowerCase();
    if (waterText.contains('น้อย')) return 'รดน้ำน้อย';
    if (waterText.contains('ปานกลาง')) return 'รดปานกลาง';
    if (waterText.contains('มาก')) return 'รดน้ำมาก';
    return 'ดูรายละเอียด';
  }

  String _getLightSubtitle() {
    final lightText = widget.plantData.light.toLowerCase();
    if (lightText.contains('ร่ม')) return 'ใต้ร่ม';
    if (lightText.contains('แสง')) return 'ต้องการแสง';
    if (lightText.contains('แดด')) return 'แสงแดด';
    return 'ดูรายละเอียด';
  }

  Widget _buildCareIcon({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required String type,
    required VoidCallback onTap,
  }) {
    final isHovered = hoveredIcon == type;
    
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => hoveredIcon = type),
        onExit: (_) => setState(() => hoveredIcon = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered ? color.withOpacity(0.3) : color.withOpacity(0.1),
              width: isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered ? color.withOpacity(0.15) : color.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: isHovered ? 12 : 6,
                offset: Offset(0, isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon container with enhanced styling
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(isHovered ? 0.2 : 0.15),
                      color.withOpacity(isHovered ? 0.1 : 0.08),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedScale(
                  scale: isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Label text
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isHovered ? color : Colors.black87,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              
              // Subtitle with container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Tap indicator
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}