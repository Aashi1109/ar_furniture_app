import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class CircleImageInput extends StatefulWidget {
  const CircleImageInput(this.setImage, {super.key});
  final Function setImage;

  @override
  State<CircleImageInput> createState() => _CircleImageInputState();
}

class _CircleImageInputState extends State<CircleImageInput> {
  File? _pickedImage;

  _pickImageHandler() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      _pickedImage = File(pickedImage.path);
      widget.setImage(_pickedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage!) as ImageProvider
              : const AssetImage(
                  'assets/icons/default_user.png',
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
