import 'package:decal/providers/auth_provider.dart';
import 'package:decal/providers/cart_provider.dart';
import 'package:decal/providers/orders_provider.dart';
import 'package:decal/providers/products_provider.dart';

import 'package:decal/widgets/user_home_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user/user_header.dart';

class UserHomeScreen extends StatefulWidget {
  static const namedRoute = '/';
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late List<Future> _futures;

  @override
  void initState() {
    _futures = [
      Provider.of<ProductProviderModel>(context, listen: false)
          .getAndSetProducts(),
      Provider.of<AuthProviderModel>(context, listen: false)
          .getAndSetAuthData(),
      Provider.of<CartProviderModel>(context, listen: false)
          .getAndSetCartData(),
      Provider.of<OrderProviderModel>(context, listen: false)
          .getAndSetOrdersData(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // late List<Future> _stateInitFutures = ;

    // print(productProvider.products.toString());

    return Scaffold(
      body: FutureBuilder(
          future: Future.wait(_futures),
          // future: productProvider.getAndSetProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
            }
            return Padding(
              padding: const EdgeInsets.only(
                top: 50,
                right: 20,
                left: 20,
                bottom: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    UserHeader(),
                    UserHomeContent(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
