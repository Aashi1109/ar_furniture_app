import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';

class GeneralHelper {
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

  static Future<File> resizeImageFile(String imagePath,
      {int? width, int? height}) async {
    final imageFile = File(imagePath);
    final image = Img.decodeImage(await imageFile.readAsBytes());
    final resizedImage = Img.copyResize(
      image!,
      width: width ?? 200,
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
