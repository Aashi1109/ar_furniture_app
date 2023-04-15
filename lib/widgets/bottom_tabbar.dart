import 'package:flutter/material.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar(this.currentIndex, this.setIndex, {super.key});
  final int currentIndex;
  final Function setIndex;

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

  _bottomNavTapHandler(int index) {}

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      enableFeedback: true,
      currentIndex: currentIndex,
      elevation: 0,
      onTap: (index) => setIndex(index),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            0,
            currentIndex,
            Icons.home_rounded,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            1,
            currentIndex,
            Icons.favorite_outline_rounded,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            2,
            currentIndex,
            Icons.shopping_cart_outlined,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildSelectedTab(
            context,
            3,
            currentIndex,
            Icons.person_3_outlined,
          ),
          label: '',
        ),
      ],
    );
  }
}
