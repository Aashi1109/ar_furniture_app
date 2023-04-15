import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/general_provider.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<GeneralProviderModel>(
      context,
      listen: false,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          value: settingProvider.isDataSaverOn,
          onChanged: (value) {
            setState(() {});
            // debugPrint(value.toString());
            settingProvider.setDataSaver = value;
          },
          title: const Text(
            'Data Saver',
          ),
          subtitle: const Text(
            'Load reduced quality images',
          ),
        ),
        SwitchListTile(
          value: settingProvider.isCurrencyInUs,
          onChanged: (value) {
            setState(() {});
            // debugPrint(value.toString());
            settingProvider.setCurrency = value;
          },
          title: const Text(
            'Currency',
          ),
          subtitle: const Text(
            'Show price in US \$',
          ),
        ),
      ],
    );
  }
}
