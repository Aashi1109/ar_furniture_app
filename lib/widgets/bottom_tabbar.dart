import 'package:flutter/material.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar(this.setCurIndex, {super.key});
  final Function setCurIndex;
  // final bool resetIndex;

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  var _currentIndex = 0;

  Widget buildSelectedTab(
      BuildContext context, int index, int curIndex, IconData icon) {
    final themeColorScheme = Theme.of(context).colorScheme;
    if (index == curIndex) {
      return CircleAvatar(
        backgroundColor: themeColorScheme.primary,
        radius: 30,
        child: Icon(
          icon,
          color: themeColorScheme.onPrimary,
        ),
      );
    }
    return Icon(
      icon,
      color: themeColorScheme.primary,
    );
  }

  _bottomNavTapHandler(int index) {
    setState(() {
      _currentIndex = index;
      // if (widget.resetIndex) {
      //   _currentIndex = 0;
      // }
    });
    widget.setCurIndex(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      enableFeedback: true,
      currentIndex: _currentIndex,
      elevation: 0,
      onTap: _bottomNavTapHandler,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            0,
            _currentIndex,
            Icons.home_rounded,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            1,
            _currentIndex,
            Icons.favorite_outline_rounded,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            2,
            _currentIndex,
            Icons.shopping_cart_outlined,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            3,
            _currentIndex,
            Icons.person_3_outlined,
          ),
          label: '',
        ),
      ],
    );
  }
}
