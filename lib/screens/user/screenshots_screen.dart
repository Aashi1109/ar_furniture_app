import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/material_helper.dart';
import '../../providers/general_provider.dart';
import '../../widgets/screenshots/screenshots_gridview.dart';

class ScreenshotsScreen extends StatelessWidget {
  const ScreenshotsScreen({super.key});
  static const namedRoute = '/screenshots';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(
              context,
              'Screenshots',
            ),
            const Text(
              'Low quality image settings will not be applied.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Divider(),
            FutureBuilder(
              future: Provider.of<GeneralProviderModel>(
                context,
                listen: false,
              ).getAndFetchScreenshots(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const ScreenshotsGridview();
              },
            ),
          ],
        ),
      ),
    );
  }
}
