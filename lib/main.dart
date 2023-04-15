import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants.dart';
import 'firebase_options.dart';

import 'screens/admin/product/admin_product_screen.dart';
import 'screens/admin/product/admin_add_product_screen.dart';
import 'screens/admin/users/admin_user_screen.dart';
import 'screens/admin/admin_screen.dart';
import 'helpers/material_helper.dart';
import 'widgets/auth/auth_stream_handler.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/general_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/products_provider.dart';
import 'providers/rating_review_provider.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/user/cart_screen.dart';
import 'screens/auth/email_verification_screen.dart';
import 'screens/auth/forget_password_screen.dart';
import 'widgets/app_launch.dart';
import 'screens/user/order_screen.dart';
import 'screens/product/review_rating_screen.dart';
import 'screens/product/view_ar_screen.dart';
import 'screens/product/view_more_screen.dart';
import 'screens/product/product_detail_screen.dart';
import 'screens/user/favourite_screen.dart';
import 'screens/user/screenshots_screen.dart';
import 'screens/user/user_account_edit_screen.dart';
import 'screens/user/user_account_screen.dart';
import 'widgets/main_app.dart';
import 'screens/user/user_settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // final bool isOnboardingShown;

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
              primaryColor,
            ),
          ).copyWith(
            tertiary: tertiaryColor,
            secondary: secondaryColor,
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
        home: const AppLaunch(),
        routes: {
          AdminProductScreen.namedRoute: (context) =>
              const AdminProductScreen(),
          AdminScreen.namedRoute: (context) => const AdminScreen(),
          AdminAddProductScreen.namedRoute: (context) =>
              const AdminAddProductScreen(),
          AdminUsersScreen.namedRoute: (context) => const AdminUsersScreen(),
          UserSettingsScreen.namedRoute: (context) =>
              const UserSettingsScreen(),
          AuthStreamHandler.namedRoute: (context) => const AuthStreamHandler(),
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
