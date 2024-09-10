import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'customer/Map/mapmain.dart';
import 'drawer_controller/drawer_controller.dart';
import 'customer/Shop/shoplike.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int _pageIndex = 0;

  final List<Widget> _tablist = [
    mapmain(),
    shoplike(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomDrawerController());

    return Scaffold(
      body: Stack(
        children: [
          _tablist.elementAt(_pageIndex),
          Obx(
                () {
              return AnimatedOpacity(
                opacity: controller.isOpen.value ? 0 : 1,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Align(
                    alignment: Alignment(0.0, 1.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      child: BottomNavigationBar(
                        selectedIconTheme: IconThemeData(
                            color: Color(0xff99ccff), shadows: [Shadow(blurRadius: 5, color: Colors.white, offset: Offset.zero)], opacity: 0.5),
                        unselectedItemColor: Colors.grey,
                        showSelectedLabels: true,
                        showUnselectedLabels: false,
                        backgroundColor: Color(0xfffaf4d9),
                        currentIndex: _pageIndex,
                        onTap: (int index) {
                          setState(() {
                            _pageIndex = index;
                          });
                        },
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.location_on),
                            label: '가게 찾기',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.favorite),
                            label: '찜',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
