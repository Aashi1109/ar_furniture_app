import 'dart:io';
import 'package:decal/constants.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';

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
