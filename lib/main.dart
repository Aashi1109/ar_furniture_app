import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'widgets/main_app.dart';
import 'screens/email_verification_screen.dart';
import 'providers/notification_provider.dart';
import 'screens/screenshots_screen.dart';
import 'providers/general_provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/products_provider.dart';
import 'providers/rating_review_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/favourite_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/user_account_edit_screen.dart';
import 'screens/view_more_screen.dart';
import 'screens/forget_password_screen.dart';
import 'screens/user_account_screen.dart';
import 'screens/view_ar_screen.dart';
import 'screens/auth_screen.dart';
import 'helpers/material_helper.dart';
import 'screens/order_screen.dart';
import 'screens/review_rating_screen.dart';
import 'helpers/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences preferences = await SharedPreferencesHelper.preferences;
  final isOnboardShown = preferences.getBool('viewedOnboard');

  runApp(
    MyApp(
      isOnboardShown ?? false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(this.isOnboardingShown, {super.key});
  final bool isOnboardingShown;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GeneralProviderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProviderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProviderModel(),
        ),
        ChangeNotifierProxyProvider<NotificationProviderModel,
            ReviewRatingProviderModel>(
          create: (context) => ReviewRatingProviderModel(),
          update: (context, notiProvider, ratingProvider) {
            ratingProvider?.notificationProvider = notiProvider;
            return ratingProvider!;
          },
        ),
        ChangeNotifierProxyProvider<NotificationProviderModel,
            AuthProviderModel>(
          create: (context) => AuthProviderModel(),
          update: (_, notiProvider, authProvider) {
            authProvider?.notificationProvider = notiProvider;
            return authProvider!;
          },
        ),
        ChangeNotifierProxyProvider<NotificationProviderModel,
            CartProviderModel>(
          create: (_) => CartProviderModel(),
          update: (_, notiProvider, cartProvider) {
            cartProvider?.notificationProvider = notiProvider;
            return cartProvider!;
          },
        ),
        ChangeNotifierProxyProvider<NotificationProviderModel,
            OrderProviderModel>(
          create: (context) => OrderProviderModel(),
          update: (_, notificationProvider, orderProvider) {
            orderProvider?.notificationProvider = notificationProvider;
            return orderProvider!;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Decal',
        debugShowCheckedModeBanner: false,
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
            bool showOnboard = isOnboardingShown;
            SharedPreferencesHelper.preferences.then((value) {
              showOnboard = value.getBool('viewedOnboard') ?? true;
            });
            if (snapshot.data != null) {
              if (FirebaseAuth.instance.currentUser?.emailVerified ?? true) {
                return const MainApp();
              }
              return EmailVerificationScreen();
            }

            return showOnboard ? const AuthScreen() : const OnboardScreen();
            // return const CircularProgressIndicator();
          },
        ),
        routes: {
          MainApp.namedRoute: (context) => const MainApp(),
          ForgetPasswordScreen.namedRoute: (context) =>
              const ForgetPasswordScreen(),
          EmailVerificationScreen.namedRoute: (context) =>
              EmailVerificationScreen(),
          CartScreen.namedRoute: (context) => const CartScreen(),
          OrderScreen.namedRoute: (context) => const OrderScreen(),
          FavouriteScreen.namedRoute: (context) => const FavouriteScreen(),
          UserAccountScreen.namedRoute: (context) => const UserAccountScreen(),
          ViewARScreen.namedRoute: (context) => ViewARScreen(),
          ViewMoreScreen.namedRoute: (context) => const ViewMoreScreen(),
          ProductDetailScreen.namedRoute: (context) =>
              const ProductDetailScreen(),
          ReviewRatingScreen.namedRoute: (context) =>
              const ReviewRatingScreen(),
          UserAccountEditScreen.namedRoute: (context) =>
              const UserAccountEditScreen(),
          AuthScreen.namedRoute: (context) => const AuthScreen(),
          ScreenshotsScreen.namedRoute: (context) => const ScreenshotsScreen()
        },
      ),
    );
  }
}
