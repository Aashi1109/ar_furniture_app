import 'package:decal/firebase_options.dart';
import 'package:decal/providers/auth_provider.dart';
import 'package:decal/providers/cart_provider.dart';
import 'package:decal/providers/orders_provider.dart';
import 'package:decal/providers/products_provider.dart';
import 'package:decal/providers/rating_review_provider.dart';
import 'package:decal/screens/cart_screen.dart';
import 'package:decal/screens/favourite_screen.dart';
import 'package:decal/screens/onboard_screen.dart';
import 'package:decal/screens/product_detail_screen.dart';
import 'package:decal/screens/user_account_edit_screen.dart';
import 'package:decal/screens/view_more_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:decal/screens/user_account_screen.dart';
import 'package:decal/screens/user_home_screen.dart';
import 'package:decal/screens/view_ar_screen.dart';

import 'package:decal/widgets/bottom_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/auth_screen.dart';
import './helpers/material_helper.dart';
import 'screens/order_screen.dart';
import 'screens/review_rating_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProviderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProviderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewRatingProviderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProviderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProviderModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Decal',
        theme: ThemeData(
          fontFamily: 'Overpass',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialHelper.createMaterialColor(
              const Color(0xff030A4E),
            ),
          ).copyWith(
            // primary: const Color(0x00030A4E),
            // tertiary: Color.fromARGB(255, 202, 201, 201),
            tertiary: const Color(0xfff3f3f3),
            secondary: const Color(0xff44bde2),
          ),
          textTheme: Theme.of(context).textTheme.copyWith(
                // titleLarge: const TextStyle(fontSize: 32),
                titleSmall: const TextStyle(fontSize: 32),
                displayLarge: const TextStyle(
                  fontSize: 26,
                ),
                displayMedium: const TextStyle(
                  fontSize: 24,
                ),
                displaySmall: const TextStyle(
                  fontSize: 20,
                ),
                bodySmall: const TextStyle(
                  fontSize: 16,
                ),
                bodyMedium: const TextStyle(
                  fontSize: 18,
                ),
              ),
        ),

        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MainApp();
            }
            // return OnboardScreen();
            return const AuthScreen();
          },
        ),
        routes: {
          CartScreen.namedRoute: (context) => const CartScreen(),
          OrderScreen.namedRoute: (context) => const OrderScreen(),
          FavouriteScreen.namedRoute: (context) => const FavouriteScreen(),
          UserAccountScreen.namedRoute: (context) => const UserAccountScreen(),
          ViewARScreen.namedRoute: (context) => const ViewARScreen(),
          ViewMoreScreen.namedRoute: (context) => const ViewMoreScreen(),
          ProductDetailScreen.namedRoute: (context) =>
              const ProductDetailScreen(),
          ReviewRatingScreen.namedRoute: (context) =>
              const ReviewRatingScreen(),
          UserAccountEditScreen.namedRoute: (context) =>
              const UserAccountEditScreen(),
        },
        // home: CatalogScreen(),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

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
      Navigator.of(context).pushNamed(CartScreen.namedRoute).then((value) {
        // Provider.of<CartProviderModel>(context, listen: false)
        //     .pushCartDataToFirestore();
        setState(() {
          _selectedPageIndex = 0;
          // resetIndex = true;
        });
      });
    }
    if (index == 3) {
      Navigator.of(context)
          .pushNamed(UserAccountScreen.namedRoute)
          .then((value) {
        setState(() {
          _selectedPageIndex = 0;
          // resetIndex = true;
        });
      });
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
