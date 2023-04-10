import 'dart:typed_data';

import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/providers/general_provider.dart';
import 'package:decal/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/material_helper.dart';
import 'package:flutter/material.dart';
import '../widgets/ar_handler.dart';
import 'package:screenshot/screenshot.dart';

class ViewARScreen extends StatelessWidget {
  ViewARScreen({super.key});
  static const namedRoute = '/view-ar';
  ScreenshotController _screenshotController = ScreenshotController();
  // Uint8List? _imageFile;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final ssProvider = Provider.of<GeneralProviderModel>(
      context,
      listen: false,
    );
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    debugPrint(routeArgs.toString());
    final productId = routeArgs['productId'];
    final modelUrl = routeArgs['modelUrl'];
    final vector = routeArgs['vector'];

    return Scaffold(
      body: Stack(
        children: [
          Screenshot(
            child: Container(
              color: Colors.amber,
              height: double.infinity,
              width: double.infinity,
            ),
            controller: _screenshotController,
          ),
          Positioned(
            left: 10,
            top: mediaQuery.padding.top + 20,
            child: MaterialHelper.buildRoundedElevatedButton(
              context,
              null,
              themeColorScheme,
              () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: mediaQuery.padding.top + 20,
            right: 10,
            child: MaterialHelper.buildRoundedElevatedButton(
              context,
              Icons.camera_alt_rounded,
              themeColorScheme,
              () async {
                final ssCaptured = await _screenshotController.capture();
                debugPrint(ssCaptured.toString());
                if (ssCaptured != null) {
                  debugPrint('in capture section');
                  ssProvider.addScreenshot(
                    ssCaptured,
                    productId ?? '',
                  );
                }
              },
              iconSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
