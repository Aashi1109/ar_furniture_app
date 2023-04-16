import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../providers/general_provider.dart';
import '../../helpers/material_helper.dart';
import '../../widgets/ar_handler.dart';

class ViewARScreen extends StatelessWidget {
  ViewARScreen({super.key});
  static const namedRoute = '/view-ar';
  final _screenshotController = ScreenshotController();
  // Uint8List? _imageFile;

  @override
  Widget build(BuildContext context) {
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
            child: ArHandler(
              modelUrl ?? '',
              vector ?? '',
            ),
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
        ],
      ),
    );
  }
}
