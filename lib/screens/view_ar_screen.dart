import 'package:decal/helpers/material_helper.dart';
import 'package:flutter/material.dart';
import '../widgets/ar_handler.dart';

class ViewARScreen extends StatelessWidget {
  const ViewARScreen({super.key});
  static const namedRoute = '/view-ar';

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(
          20,
        ),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              color: Colors.amber,
              child: ArHandler(),
            ),
            Positioned(
              left: -10,
              top: mediaQuery.padding.top,
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
              top: mediaQuery.padding.top,
              right: -10,
              child: MaterialHelper.buildRoundedElevatedButton(
                context,
                Icons.camera_alt_rounded,
                themeColorScheme,
                () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
