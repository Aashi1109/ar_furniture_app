import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../helpers/general_helper.dart';

class CircleImageInput extends StatefulWidget {
  const CircleImageInput(this.setImage, {super.key, this.prevImageUrl = ''});
  final Function setImage;
  final String prevImageUrl;

  @override
  State<CircleImageInput> createState() => _CircleImageInputState();
}

class _CircleImageInputState extends State<CircleImageInput> {
  File? _pickedImage;

  _pickImageHandler() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    // File originalFile = File(pickedImage.path);
    // debugPrint('original size ${await originalFile.length()}');
    File tempFile = await GeneralHelper.resizeImageFile(pickedImage.path);
    // debugPrint('reduced size ${await tempFile.length()}');
    setState(() {
      _pickedImage = tempFile;
      widget.setImage(_pickedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage:
              (_pickedImage == null && widget.prevImageUrl.isNotEmpty)
                  ? NetworkImage(widget.prevImageUrl)
                  : _pickedImage != null
                      ? FileImage(_pickedImage!) as ImageProvider
                      : const AssetImage(
                          'assets/images/defaults/default_user.png',
                        ),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          radius: 40,
        ),
        Positioned(
          bottom: -10,
          right: -10,
          child: Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(
                Icons.add_photo_alternate_rounded,
              ),
              onPressed: _pickImageHandler,
            ),
          ),
        ),
      ],
    );
  }
}
