import 'package:decal/helpers/general_helper.dart';
import 'package:decal/helpers/modal_helper.dart';
import 'package:flutter/material.dart';

class ImageLinkInput extends StatelessWidget {
  const ImageLinkInput({
    super.key,
    required this.setImageLink,
    required this.removeImageLink,
    required this.images,
  });
  final Function setImageLink;
  final Function removeImageLink;
  final Map<String, String> images;

  Widget _buildImageLinkChip(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    // debugPrint(imageUrl);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      padding: const EdgeInsets.only(
        left: 10,
      ),
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      // height: 40,
      child: Row(
        children: [
          Text(
            title,
          ),
          FadeInImage(
            placeholder: const AssetImage(
              'assets/images/defaults/product.jpeg',
            ),
            image: NetworkImage(
              GeneralHelper.genReducedImageUrl(
                imageUrl,
                params: [
                  'w_60',
                ],
              ),
            ),
            width: 60,
            height: 40,
          ),
          Flexible(
            child: Text(
              imageUrl,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () => removeImageLink(
              title,
            ),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.cancel_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            label: Text(
              'Images',
            ),
            hintText: 'Link seperated by space',
          ),
          controller: textController,
          onChanged: (value) {
            if (value.contains(' ')) {
              final temp = value.trim();
              if (!temp.contains('res.cloudinary.com')) {
                ModalHelpers.createAlertDialog(
                  context,
                  'Image URL Error',
                  'Only cloudinary links are accepted',
                );
                textController.text = '';
              } else {
                final isValueAlreadyPresent = images.values.contains(temp);
                if (temp != '' && !isValueAlreadyPresent) {
                  setImageLink(temp);
                  textController.text = '';
                }
                if (isValueAlreadyPresent) {
                  textController.text = '';
                }
              }
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: images.entries.map((entry) {
            return _buildImageLinkChip(
              context,
              entry.key,
              entry.value,
            );
          }).toList(),
        ),
      ],
    );
  }
}
