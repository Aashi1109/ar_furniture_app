import 'package:flutter/material.dart';

class TagInput extends StatelessWidget {
  const TagInput(this.tags, this.setData, this.removeData, {super.key});
  final Function setData;
  final Function removeData;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Use space to seperate tags.',
          ),
          controller: textEditingController,
          onChanged: (value) {
            if (value.contains(' ')) {
              final temp = value.trim().toLowerCase();
              // debugPrint(temp);
              final isValueAlreadyPresent = tags.contains(temp);
              // debugPrint(isValueAlreadyPresent.toString());
              if (temp != '' && !isValueAlreadyPresent) {
                // debugPrint('in assadjsadjsa');
                textEditingController.text = '';
                setData(temp);
              }
              if (isValueAlreadyPresent) {
                textEditingController.text = '';
              }
            }
          },
        ),
        Wrap(
          spacing: 10,
          // alignment: WrapAlignment.start,
          children: tags
              .map(
                (e) => Chip(
                  label: Text(e),
                  deleteIcon: e == 'all'
                      ? null
                      : const Icon(
                          Icons.close_rounded,
                        ),
                  onDeleted: e == 'all'
                      ? null
                      : () {
                          removeData(e);
                        },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
