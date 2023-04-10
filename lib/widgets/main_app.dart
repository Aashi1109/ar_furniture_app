import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_account_screen.dart';
import '../widgets/bottom_tabbar.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/user_home_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static const namedRoute = '/mainapp';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedPageIndex = 0;
  // bool resetIndex = false;

  final List _screens = [
    const UserHomeScreen(),
    const FavouriteScreen(),
  ];
  getCurPageIndex(int index) {
    setState(() {
      // if(index == 3) {}
      if (index < 2) {
        _selectedPageIndex = index;
        // resetIndex = false;
      }
    });
    if (index == 2) {
      Navigator.of(context).pushNamed(CartScreen.namedRoute).then(
        (value) {
          Provider.of<CartProviderModel>(context, listen: false)
              .pushCartDataToFirestore();
          setState(() {
            _selectedPageIndex = 0;
            // resetIndex = true;
          });
        },
      );
    }
    if (index == 3) {
      Navigator.of(context).pushNamed(UserAccountScreen.namedRoute).then(
        (value) {
          setState(() {
            _selectedPageIndex = 0;
            // resetIndex = true;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedPageIndex],
      bottomNavigationBar: BottomTabBar(getCurPageIndex),
    );
  }
}
