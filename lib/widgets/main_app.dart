import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../screens/user/cart_screen.dart';
import '../screens/user/favourite_screen.dart';
import '../screens/user/user_account_screen.dart';
import '../screens/user/user_home_screen.dart';
import '../widgets/bottom_tabbar.dart';

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

  Widget _buildBody() {
    switch (_selectedPageIndex) {
      case 0:
        return _screens[0];
      case 1:
        return _screens[1];
      case 2:
        Future.delayed(
            const Duration(
              milliseconds: 100,
            ), () {
          if (mounted) {
            Navigator.of(context).pushNamed(CartScreen.namedRoute).then(
              (value) {
                if (mounted) {
                  Provider.of<CartProviderModel>(context, listen: false)
                      .pushCartDataToFirestore();
                  _setIndex(0);
                }
              },
            );
          }
        });
        break;
      case 3:
        Future.delayed(
            const Duration(
              milliseconds: 100,
            ), () {
          if (mounted) {
            Navigator.of(context).pushNamed(UserAccountScreen.namedRoute).then(
              (value) {
                if (mounted) {
                  _setIndex(0);
                }
              },
            );
          }
        });
        break;
    }
    return Container();
  }

  void _setIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomTabBar(
        _selectedPageIndex,
        _setIndex,
      ),
    );
  }
}
