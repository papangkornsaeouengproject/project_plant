import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/plant_data.dart';

class DetailModal extends StatefulWidget {
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
  State<DetailModal> createState() => _DetailModalState();
}

class _DetailModalState extends State<DetailModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<Offset> _slide;
  double _sheetHeight = 400; // จะวัดจริงด้วย LayoutBuilder

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 0.0, // 0 = ปิด, 1 = เปิด
    );
    _slide = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic),
    );
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _ac.reverse();
    widget.onClose();
  }

  // ===== Drag-to-close =====
  void _onDragUpdate(DragUpdateDetails d) {
    final dy = d.primaryDelta ?? 0;
    if (dy <= 0) return; // ลากขึ้นไม่ทำอะไร
    final frac = dy / _sheetHeight; // 0..1
    _ac.value = (_ac.value - frac).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails d) {
    const velocityThreshold = 700.0; // px/s
    if ((d.primaryVelocity ?? 0) > velocityThreshold) {
      _close();
      return;
    }
    if (_ac.value < 0.5) {
      _close();
    } else {
      _ac.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _getDetailContent(widget.type, widget.plantData);

    return WillPopScope(
      onWillPop: () async {
        await _close(); // ปิดเมื่อกดปุ่ม Back
        return false;
      },
      child: Material(
        color: Colors.black45,
        child: Stack(
          children: [
            // กด “นอกกรอบ” เพื่อปิด + เบลอพื้นหลัง
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque, // รับทัชทั่วพื้นที่
                onTap: _close,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // ตัวการ์ด (slide ขึ้น) + รองรับลากลงเพื่อปิด
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _slide,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _sheetHeight = constraints.maxHeight;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: _onDragUpdate,
                      onVerticalDragEnd: _onDragEnd,
                      child: _BottomCard(
                        title: detail.title,
                        icon: detail.icon,
                        iconColor: detail.iconColor, // ✅ ใช้สีตามประเภท
                        content: detail.content,
                        onClose: _close,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// การ์ดด้านล่างสไตล์ sheet
class _BottomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget content;
  final VoidCallback onClose;

  const _BottomCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.content,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = 22.0;
    final borderColor = const Color(0xFF7EC8F8);

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(radius)),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -8)),
          ],
          border: Border.all(color: borderColor, width: 1.6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle
            Container(
              width: 46,
              height: 5,
              margin: const EdgeInsets.only(top: 6, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            // title + close
            Row(
              children: [
                Icon(icon, color: iconColor, size: 22), // ✅ ไอคอนตามสี
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  tooltip: 'ปิด',
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // content scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Utils สร้างคอนเทนต์ =====
class _DetailBundle {
  final String title;
  final IconData icon;
  final Color iconColor;   // ✅ สีไอคอน
  final Widget content;
  _DetailBundle(this.title, this.icon, this.iconColor, this.content);
}

_DetailBundle _getDetailContent(String type, PlantData plant) {
  switch (type) {
    case 'plant':
      return _DetailBundle(
        'ข้อมูลพืช',
        Icons.local_florist_rounded,
        Colors.green, // ✅ plant = เขียว
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item('ชื่อทางวิทยาศาสตร์', plant.scienceName),
            const SizedBox(height: 12),
            _item('วงศ์', plant.family),
            const SizedBox(height: 12),
            _item('ชื่อภาษาอังกฤษ', plant.engName),
          ],
        ),
      );
    case 'water':
      return _DetailBundle(
        'การรดน้ำ',
        Icons.water_drop_rounded,
        Colors.blue, // ✅ water = ฟ้า
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item('การรดน้ำทั่วไป', plant.water),
            const SizedBox(height: 12),
            _item('การรดน้ำในร่ม', plant.watering_indoor),
            const SizedBox(height: 12),
            _item('การรดน้ำกลางแจ้ง', plant.watering_outdoor),
          ],
        ),
      );
    case 'light':
      return _DetailBundle(
        'แสงแดด',
        Icons.wb_sunny_rounded,
        Colors.orange, // ✅ light = ส้ม
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item('สภาพแสง', plant.light),
            const SizedBox(height: 12),
            _item('รายละเอียดแสง', plant.light_detail),
            const SizedBox(height: 12),
            _item('คำเตือน', plant.warning),
          ],
        ),
      );
    default:
      return _DetailBundle('', Icons.info_outline, Colors.grey, const SizedBox.shrink());
  }
}

Widget _item(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Colors.black54,
        ),
      ),
      const SizedBox(height: 10),
      const Divider(color: Colors.black12, height: 18, thickness: 1),
    ],
  );
}
