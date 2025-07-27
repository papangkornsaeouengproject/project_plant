import 'package:flutter/material.dart';
import '../pages/plant_info_page.dart';
import '../pages/light_info_page.dart';
import '../pages/water_info_page.dart';

class PlantDetailScreen extends StatefulWidget {
  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _pages = [
    PlantInfoPage(),
    LightInfoPage(),
    WaterInfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'พบต้นไม้แล้ว! (87%)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: EdgeInsets.all(20),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
              image: DecorationImage(
                image: AssetImage('assets/dracaena.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: _pages,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _currentIndex,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'ต้นไม้'),
            BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'แสง'),
            BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'น้ำ'),
          ],
          selectedItemColor: Colors.green.shade700,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 12,
        ),
      ),
    );
  }
}
