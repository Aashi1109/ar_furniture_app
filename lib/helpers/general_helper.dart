import 'dart:io';
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

  static Future<File> resizeImageFile(File imgFile,
      {int? width, int? height}) async {
    final image = Img.decodeImage(await imgFile.readAsBytes());
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
}
