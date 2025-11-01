import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/wishlist_controller.dart';
import 'package:mini4wd_store/views/pages/home_page.dart';
import 'package:mini4wd_store/views/pages/profile_page.dart';
import 'package:mini4wd_store/views/pages/shop_map_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    ShopMapPage(),
    ProfilePage()
  ];

  @override
  void initState(){
    super.initState();
    Get.put(WishlistController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 10),
        child: _pages[_selectedIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) { 
          _selectedIndex = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled), 
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined), 
            label: "Find & Race",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: "Profile"
          ),
        ],
      ),
    );
  }
}
