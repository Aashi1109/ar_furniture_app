import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';

import '../helpers/firebase/profile_helper.dart';
import '../helpers/firebase/screenshot_helper.dart';
import '../helpers/firebase/settings_helper.dart';
import '../helpers/general_helper.dart';

class ScreenshotItemModel {
  final String id;
  final String productId;
  final String imageUrl;

  ScreenshotItemModel({
    required this.productId,
    required this.imageUrl,
    String? id,
  }) : id = id ?? DateTime.now().toString();
}

/// It provides data related to user app settings and screenshots data
/// and exposes
/// various methods to read and write that data.
class GeneralProviderModel extends ChangeNotifier {
  // This is for settings
  static const dataSaverKey = 'isDataSaverOn';
  static const currencyKey = 'currencyInUs\$';
  bool _isSettingDataInit = true;
  Map<String, dynamic> _settings = {
    dataSaverKey: false,
    currencyKey: true,
  };

  // getter and setter for imageQuality
  bool get isDataSaverOn {
    return _settings[dataSaverKey];
  }

  bool get isCurrencyInUs {
    return _settings[currencyKey];
  }

  set setDataSaver(bool highQuality) {
    _settings[dataSaverKey] = highQuality;

    // notifyListeners();
    saveSettings();
  }

  set setCurrency(bool inUS) {
    _settings[currencyKey] = inUS;
    // notifyListeners();
    saveSettings();
  }

  Future<void> getAndSetSettings() async {
    return GeneralHelper.getAndSetWrapper(_isSettingDataInit, () async {
      debugPrint('in set auth');
      final loadedSettings =
          await SettingHelper.getSettingsFromFirestore().get();
      // debugPrint(loadedSettings.data().toString());
      if (!loadedSettings.exists) {
        await saveSettings();
      } else {
        _settings = Map<String, dynamic>.from(loadedSettings.data()!);
        _isSettingDataInit = false;
        notifyListeners();
      }
    });
    // if (_isSettingDataInit) {
    //   try {
    //     final loadedSettings =
    //         await SettingHelper.getSettingsFromFirestore().get();
    //     // debugPrint(loadedSettings.data().toString());
    //     if (!loadedSettings.exists) {
    //       await saveSettings();
    //     } else {
    //       _settings = Map<String, dynamic>.from(loadedSettings.data()!);
    //       _isSettingDataInit = false;
    //       notifyListeners();
    //     }
    //   } catch (error) {
    //     debugPrint(
    //         'error in fetching settings from firestore ${error.toString()}');
    //   }
    // } else {
    //   return;
    // }
  }

  Future<void> saveSettings() async {
    try {
      await SettingHelper.setSettingsInFirestore({..._settings});
    } catch (error) {
      debugPrint('error in saving settings in firestore ${error.toString()}');
    }
  }

  // This is for screenshots
  List<ScreenshotItemModel> _screenshots = [];
  bool _isSSDataInit = true;

  List<ScreenshotItemModel> get screenshots {
    return [..._screenshots];
  }

  Future<void> addScreenshot(
    Uint8List image,
    String productId,
  ) async {
    try {
      final downloadUrl = await (await ProfileHelper.uploadImage(
        imageData: image,
        uploadPath: ScreenshotHelper.screenshotStoragePath,
      ))
          .ref
          .getDownloadURL();
      _screenshots.insert(
        0,
        ScreenshotItemModel(
          productId: productId,
          imageUrl: downloadUrl,
        ),
      );
      notifyListeners();
      await ScreenshotHelper.saveSsToFirestore({
        'productId': productId,
        'imageUrl': downloadUrl,
      });
    } catch (error) {
      debugPrint('error uploading file to storage ${error.toString()}');
    }
  }

  void deleteScreenshot(String ssId) async {
    try {
      _screenshots.removeWhere((element) => element.id == ssId);
      await ScreenshotHelper.deleteSsFromFirestore(ssId);
    } catch (error) {
      debugPrint('error deleting ss from firestore ${error.toString()}');
    }
    notifyListeners();
  }

  Future<void> getAndFetchScreenshots() async {
    return GeneralHelper.getAndSetWrapper(_isSSDataInit, () async {
      final loadedSs = await ScreenshotHelper.getSsFromFirestore();
      List<ScreenshotItemModel> tempSs = [];
      for (var ss in loadedSs.docs) {
        tempSs.add(
          ScreenshotItemModel(
            productId: ss.data()['productId'],
            imageUrl: ss.data()['imageUrl'],
            id: ss.id,
          ),
        );
      }
      _isSSDataInit = false;
      if (_screenshots.isEmpty) {
        // _screenshots = List<ScreenshotItemModel>.from(tempSs);
        _screenshots = tempSs;
      } else {
        _screenshots.addAll(tempSs);
      }
      notifyListeners();
    });
    // if (_isSSDataInit) {
    //   try {
    //     final loadedSs = await ScreenshotHelper.getSsFromFirestore();
    //     List<ScreenshotItemModel> tempSs = [];
    //     for (var ss in loadedSs.docs) {
    //       tempSs.add(
    //         ScreenshotItemModel(
    //           productId: ss.data()['productId'],
    //           imageUrl: ss.data()['imageUrl'],
    //           id: ss.id,
    //         ),
    //       );
    //     }
    //     _isSSDataInit = false;
    //     if (_screenshots.isEmpty) {
    //       // _screenshots = List<ScreenshotItemModel>.from(tempSs);
    //       _screenshots = tempSs;
    //     } else {
    //       _screenshots.addAll(tempSs);
    //     }
    //     notifyListeners();
    //   } catch (error) {
    //     debugPrint('error fetching ss data ${error.toString()}');
    //   }
    // } else {
    //   return;
    // }
  }
}
