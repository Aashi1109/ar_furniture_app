import '../helpers/modal_helper.dart';
import '../providers/general_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/notifications/notification_modal.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/products_provider.dart';

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
    final notiProvider =
        Provider.of<NotificationProviderModel>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProviderModel>(context, listen: false);
    final cartProvider = Provider.of<CartProviderModel>(context, listen: false);
    final orderProvider =
        Provider.of<OrderProviderModel>(context, listen: false);

    final List<Future> futures = [
      generalProvider.getAndSetSettings(),
      Provider.of<ProductProviderModel>(context, listen: false)
          .getAndSetProducts(),
      Provider.of<AuthProviderModel>(context, listen: false)
          .getAndSetAuthData(),
      cartProvider.getAndSetCartData(),
      orderProvider.getAndSetOrdersData(),
      notiProvider.getAndSetNotiData(),
    ];
    return GestureDetector(
      onTap: () {
        if (notiProvider.notiWindowStatus == true) {
          notiProvider.toggleNotiWindow();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: WillPopScope(
              onWillPop: () async {
                bool? exit = await ModalHelpers.createAlertDialog<bool>(
                  context,
                  'Exit Decal',
                  'Do you want to exit?',
                  closeContent: false,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'No',
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Yes',
                      ),
                    ),
                  ],
                );

                if (exit != null) {
                  if (exit == true) {
                    final saveFutures = [
                      generalProvider.saveSettings(),
                      cartProvider.pushCartDataToFirestore(),
                    ];

                    await Future.wait(saveFutures);
                    return true;
                  }
                }
                return false;
              },
              child: FutureBuilder(
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
      ),
    );
  }
}
