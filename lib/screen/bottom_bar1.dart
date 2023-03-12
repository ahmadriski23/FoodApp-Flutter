import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/dark_theme_provider.dart';
import 'package:new_app/screen/categories.dart';
import 'package:new_app/screen/home_screen.dart';
import 'package:new_app/screen/user.dart';
import 'package:new_app/screen/wishlist/wishlist_screen.dart';
import 'package:new_app/screen/wishlist/wishlist_screen_bottom.dart';
import 'package:provider/provider.dart';

import '../constants/color.dart';
import '../widgets/text_widgets.dart';
import 'cart/cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class BottomBar1 extends StatefulWidget {
  const BottomBar1({Key? key}) : super(key: key);

  @override
  State<BottomBar1> createState() => _BottomBar1State();
}

class _BottomBar1State extends State<BottomBar1> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'page': WishlistBottomScreen(), 'title': 'Wishlist Screen'},
    {'page': UserScreen(), 'title': 'User Screen'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    bool isDark = themeState.getDarkTheme;
    return Scaffold(
      /* appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
      ), */
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: isDark ? Colors.white10 : const Color(0xFF1a1f3c),
        selectedItemColor:
            isDark ? Colors.lightBlue.shade200 : const Color(0xFF1a1f3c),
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 2 ? IconlyBold.heart : IconlyLight.heart),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: "User",
          ),
        ],
      ),
    );
  }
}
