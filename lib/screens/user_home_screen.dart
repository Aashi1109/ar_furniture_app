import 'package:decal/providers/notification_provider.dart';
import '../widgets/notifications/notification_modal.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/products_provider.dart';
import '../providers/rating_review_provider.dart';

import '../widgets/user_home_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user/user_header.dart';

class UserHomeScreen extends StatelessWidget {
  static const namedRoute = '/';
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final List<Future> futures = [
      Provider.of<ProductProviderModel>(context, listen: false)
          .getAndSetProducts(),
      Provider.of<ReviewRatingProviderModel>(context, listen: false)
          .getAndSetReviews(),
      Provider.of<AuthProviderModel>(context, listen: false)
          .getAndSetAuthData(),
      Provider.of<CartProviderModel>(context, listen: false)
          .getAndSetCartData(),
      Provider.of<OrderProviderModel>(context, listen: false)
          .getAndSetOrdersData(),
    ];
    return Stack(
      children: [
        Scaffold(
          body: FutureBuilder(
              future: Future.wait(futures),
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
        ),
        Consumer<NotificationProviderModel>(
          builder: (_, provider, ch) {
            return provider.notiWindowStatus
                ? Positioned(
                    right: 20,
                    top: mediaQuery.viewPadding.top + 30,
                    child: NotificationModalWindow(
                      mediaQuery: mediaQuery,
                    ),
                  )
                : ch!;
          },
          child: const SizedBox(),
        ),
      ],
    );
  }
}
