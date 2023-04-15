import 'dart:io';
import 'package:decal/helpers/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';

import '../helpers/firebase/profile_helper.dart';

import '../constants.dart';

/// Contains some general helpers methods.
/// List of available methods.
/// - `genReducedImageUrl()` it return tranformed url for images which are
/// optimized. Works for cloudinary urls only.
///
/// - `resizeImage()` resize images to a particular size.
/// - `getIconDataString()` converts IconData to string.
/// - `getIconDataFromIconString()` returns IconData from string.
/// - `getTimeAgoString()` returns how much time it has been from creation time of item.
/// - `getAndSetWrapper()` returns a wrapper function around try and catch.
class GeneralHelper {
  /// It return tranformed url for images which are optimized. Works for
  /// cloudinary urls only. `params` contains the transformations which have to
  /// be applied. By default tranformation `[w_200]` is used which returns
  /// image of width `200px`.
  static String genReducedImageUrl(String imageUrl,
      {List params = const ['w_200']}) {
    final split1 = imageUrl.split('/');
    final split2 = split1[split1.length - 1].split('.');
    final id = split2[0];
    final paramsFort = params.join(",");
    String reducedUrl =
        "http://res.cloudinary.com/aashish1109/image/upload/$paramsFort/v1/MajorProject/AR_Furniture_App/$id";

    return reducedUrl;
  }

  /// Resize images to a particular size. By defining width and height image of
  /// that size can be obtained. By default image in resized to width of 100.
  static Future<File> resizeImageFile(String imagePath,
      {int? width, int? height}) async {
    final imageFile = File(imagePath);
    final image = Img.decodeImage(await imageFile.readAsBytes());
    final resizedImage = Img.copyResize(
      image!,
      width: width ?? 100,
      height: height,
    );

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/${DateTime.now().toString()}.jpg';
    final resizedImageFile = File(tempPath);
    await resizedImageFile.writeAsBytes(Img.encodeJpg(resizedImage));
    return resizedImageFile;
  }

  static String getIconDataString(IconData iconData) {
    return iconData.codePoint.toString();
  }

  static IconData getIconDataFromIconString(String iconString) {
    return IconData(int.parse(iconString), fontFamily: 'MaterialIcons');
  }

  static String getTimeAgoString(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return '0 s';
    }
  }

  static getAndSetWrapper(bool initVariable, VoidCallback tryPart,
      {VoidCallback? elsePart}) {
    elsePart ??= () {
      return;
    };

    if (initVariable) {
      try {
        tryPart();
      } catch (error) {
        debugPrint('error happened in wrapper ${error.toString()}');
      }
    } else {
      elsePart();
    }
  }

  static Future<bool> checkAdminRight(String code) async {
    final userProfileData =
        await ProfileHelper.getUserProfileDataFromFirestore();
    final isUserHaveAdminRight = userProfileData.data()?['isAdmin'] ?? false;
    final resCode = await FirebaseHelper.getAccessCode('adminAccess');
    final adminAcessCode = resCode.data()?['code'] ?? '';
    if (adminAcessCode == '') {
      return false;
    }

    if (isUserHaveAdminRight) {
      // debugPrint('in check after admin check');
      // final res = code == 'aaKsl09d2';
      final res = code == adminAcessCode;
      // debugPrint('code incoming $code, res value $res');
      return res;
    }
    return false;
  }

  static String removeZerosFromPrice(
    double numDouble, {
    bool isUs = true,
  }) {
    // String numStr = num.toString();
    String numStr = numDouble.toString();
    if (!isUs) {
      numStr = (numDouble * 80).toStringAsFixed(2);
    }
    List<String> parts = numStr.split(".");
    if (parts.length == 2 && parts[1].split("").every((d) => d == "0")) {
      return parts[0];
    } else {
      return numStr;
    }
  }

  static Map<String, Object> formatImagesToDataMap(Map<String, String> data) {
    Map<String, Object> temp = {};
    for (var entry in data.entries) {
      if (entry.key == 'main') {
        temp['main'] = entry.value;
      } else {
        if (temp.containsKey('all')) {
          (temp['all'] as List<String>).add(entry.value);
        } else {
          temp['all'] = [entry.value];
        }
      }
    }
    if (data.length == 1) {
      temp['all'] = [
        temp['main'],
      ];
    }

    return temp;
  }

  static formatImageToInputMap(Map<String, Object> data) {
    // debugPrint(data.toString());
    Map<String, String> temp = {};
    for (var entry in data.entries) {
      if (entry.key == 'main') {
        temp['main'] = entry.value as String;
      }
      if (entry.key == 'all') {
        int index = 1;
        for (var link in data[entry.key] as List) {
          temp['link$index'] = link;
          index++;
        }
      }
    }

    return temp;
  }
}

class VerificationCodeTimerModel {
  VerificationCodeTimerModel() {
    start();
  }

  Stream<int> _timerStreamFunc() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (i) => i,
    ).take(kVerificationCodeTimeoutSeconds);
  }

  Stream<int>? _timerStream;

  void start() {
    _timerStream = _timerStreamFunc();
  }

  Stream<int> get timerStream {
    if (_timerStream != null) {
      return _timerStream!;
    }
    return const Stream.empty();
  }
}
