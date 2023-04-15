import 'dart:typed_data';

import '../../helpers/modal_helper.dart';
import '../../providers/general_provider.dart';
import '../../providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../../helpers/material_helper.dart';
import 'package:flutter/material.dart';
import '../../widgets/ar_handler.dart';
import 'package:screenshot/screenshot.dart';

class ViewARScreen extends StatelessWidget {
  ViewARScreen({super.key});
  static const namedRoute = '/view-ar';
  ScreenshotController _screenshotController = ScreenshotController();
  // Uint8List? _imageFile;
  final _globalKey = GlobalKey<ObjectGesturesWidgetState>();

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
    // debugPrint(routeArgs.toString());
    final productId = routeArgs['productId'];
    final modelUrl = routeArgs['modelUrl'];
    final vector = routeArgs['vector'];

    return Scaffold(
      body: Stack(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: StatefulBuilder(builder: (
              context,
              setstate,
            ) {
              return ArHandler(
                modelUrl ?? '',
                vector ?? '',
                key: _globalKey,
              );
            }),
          ),
          Positioned(
            left: 10,
            top: mediaQuery.padding.top + 20,
            child: MaterialHelper.buildRoundedElevatedButton(
              context,
              null,
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
          Positioned(
            bottom: 10,
            right: (MediaQuery.of(context).size.width / 2),
            child: ElevatedButton.icon(
              onPressed: _globalKey.currentState?.onRemoveEverything,
              icon: const Icon(
                Icons.remove_rounded,
              ),
              label: const Text('Remove Items'),
            ),
          ),
        ],
      ),
    );
  }
}
