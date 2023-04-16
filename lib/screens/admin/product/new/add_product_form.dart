import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/general_helper.dart';
import '../../../../providers/products_provider.dart';
import '../../../../widgets/inputs/tag_input.dart';
import '../../../../widgets/inputs/image_link_input.dart';
import '../../../../helpers/material_helper.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({
    super.key,
    this.isUpdateForm = false,
    this.productId,
  });
  final bool isUpdateForm;
  final String? productId;
  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  int _imageLinkIndex = 0;
  bool _isLoading = false;
  final Map<String, Object> _enteredData = {
    'title': '',
    'price': '',
    'vector': '',
    'modelUrl': '',
    'description': '',
    'category': [
      'all',
    ],
    'images': {}
  };
  final _formGlobalKey = GlobalKey<FormState>();
  // bool _autoValidate = false;

  void _submitHandler() async {
    final formIsvalid = _formGlobalKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (formIsvalid ?? false) {
      _formGlobalKey.currentState?.save();
      final formattedImagesMap = GeneralHelper.formatImagesToDataMap(
        Map<String, String>.from(
          _enteredData['images'] as Map,
        ),
      );

      _enteredData['imagesFor'] = formattedImagesMap;

      setState(() {
        _isLoading = true;
      });

      if (widget.isUpdateForm) {
        Provider.of<ProductProviderModel>(
          context,
          listen: false,
        )
            .updateProductById(
          widget.productId!,
          _enteredData,
        )
            .then((value) {
          Navigator.of(context).pop();
        });
      } else {
        Provider.of<ProductProviderModel>(
          context,
          listen: false,
        )
            .addProduct(
          _enteredData,
        )
            .then((value) {
          Navigator.of(context).pop();
        });
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      // setState(() {
      //   _autoValidate = true;
      // });
    }
  }

  void _getCategory(String category) {
    setState(() {
      (_enteredData['category'] as List).insert(
        0,
        category,
      );
    });
  }

  void _removeCategory(String category) {
    setState(() {
      (_enteredData['category'] as List).remove(category);
    });
  }

  void _addImageLink(String link) {
    if (_imageLinkIndex == 0) {
      (_enteredData['images'] as Map).putIfAbsent(
        'main',
        () => link,
      );
    }
    if (_imageLinkIndex != 0) {
      (_enteredData['images'] as Map).putIfAbsent(
        'link$_imageLinkIndex',
        () => link,
      );
    }
    _imageLinkIndex++;
    setState(() {});
  }

  void _removeImageLink(String imageLinkKey) {
    setState(() {
      (_enteredData['images'] as Map).removeWhere(
        (key, value) => key == imageLinkKey,
      );
    });
  }

  @override
  void initState() {
    if (widget.isUpdateForm && widget.productId != null) {
      final foundProduct = Provider.of<ProductProviderModel>(
        context,
        listen: false,
      ).getProductById(
        widget.productId!,
      );
      _enteredData['title'] = foundProduct.title;
      _enteredData['price'] = foundProduct.price.toStringAsFixed(
        2,
      );
      _enteredData['description'] = foundProduct.description;
      _enteredData['vector'] = foundProduct.vector;
      _enteredData['modelUrl'] = foundProduct.modelUrl;
      _enteredData['images'] = GeneralHelper.formatImageToInputMap(
        Map<String, Object>.from(
          foundProduct.images,
        ),
      );
      _enteredData['category'] = foundProduct.categories;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text(
                'Title',
              ),
            ),
            initialValue: _enteredData['title'] as String,
            onSaved: (value) {
              _enteredData['title'] = value?.trim() ?? '';
            },
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Invalid title';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(
                'Price',
              ),
              hintText: 'Price in \$',
            ),
            initialValue: _enteredData['price'] as String,
            keyboardType: TextInputType.number,
            onSaved: (value) {
              _enteredData['price'] = value?.trim() ?? '';
            },
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Invalid price';
              }
              if (value != null && double.parse(value) < 10) {
                return 'Price is very less';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(
                'Description',
                textAlign: TextAlign.start,
              ),
            ),
            initialValue: _enteredData['description'] as String,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 7,
            textAlign: TextAlign.start,
            onSaved: (value) {
              _enteredData['description'] = value?.trim() ?? '';
            },
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Invalid description';
              }
              if (value != null && value.length < 30) {
                return 'Description should be 30 characters long';
              }

              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(
                'Model URL',
              ),
              hintText: 'Github url',
            ),
            onSaved: (value) {
              _enteredData['modelUrl'] = value?.trim() ?? '';
            },
            initialValue: _enteredData['modelUrl'] as String,
            validator: (value) {
              // if (value != null && value.isEmpty) {
              //   return 'No URL provided';
              // }
              // if (value != null &&
              //     !(value.contains('http') || value.contains('https'))) {
              //   return 'Not valid URL';
              // }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text(
                  'Vector3',
                ),
                hintText: 'Vector3(1.0, 1.0, 1.0)'),
            onSaved: (value) {
              _enteredData['vector'] = value?.trim() ?? '';
            },
            initialValue: _enteredData['vector'] as String,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Invalid vector';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TagInput(
            _enteredData['category'] as List<String>,
            _getCategory,
            _removeCategory,
          ),
          const SizedBox(
            height: 10,
          ),
          ImageLinkInput(
            images: Map<String, String>.from(
              _enteredData['images'] as Map,
            ),
            setImageLink: _addImageLink,
            removeImageLink: _removeImageLink,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .07,
          ),
          MaterialHelper.buildLargeElevatedButton(
            context,
            widget.isUpdateForm ? 'Update Product' : 'Add Product',
            pressHandler: _isLoading ? null : _submitHandler,
          ),
        ],
      ),
    );
  }
}
