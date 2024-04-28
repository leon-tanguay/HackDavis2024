import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final List<Map<String, dynamic>> _pages = [
    {'title': 'Coupons', 'icon': Icons.local_offer},
    {'title': 'Map', 'icon': Icons.map},
    {'title': 'Login', 'icon': Icons.login},
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: _pages.map((page) {
        return BottomNavigationBarItem(
          icon: Icon(page['icon'] as IconData),
          label: page['title'] as String,
        );
      }).toList(),
    );
  }
}
