import 'dart:io';
import 'package:flutter/material.dart';

import '../../screens/auth/forget_password_screen.dart';
import '../../helpers/material_helper.dart';
import '../../helpers/modal_helper.dart';
import '../inputs/circle_image_input.dart';
import 'auth_bottom_button.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(
    this.setFormData,
    this.isLoading, {
    super.key,
    this.isEditForm = false,
    this.type = 'login',
    this.editData = const {},
    this.canChangePass = true,
  });
  final Function setFormData;
  final bool isLoading;
  final bool isEditForm;
  final String type;
  final Map<String, String> editData;
  final bool canChangePass;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  late bool _isLoginForm;
  bool _autoValidate = false;

  void _getSelectedImage(File image) => _selectedImage = image;
  void _authWithHandler(String handler) {
    widget.setFormData({
      'handler': handler,
    }, '');
  }

  Map<String, Object> _enteredData = {
    'name': '',
    'email': '',
    'password': '',
    'image': '',
  };

  void _submitData() {
    bool isFormValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isFormValid) {
      if (_selectedImage == null && !_isLoginForm) {
        ModalHelpers.createAlertDialog(context, 'Error Profile Image',
            'Please Select a Profile image to continue');
      } else {
        _formKey.currentState!.save();
        if (!_isLoginForm || widget.isEditForm) {
          _enteredData['image'] = _selectedImage?.path ?? '';
        }

        widget.setFormData(_enteredData, _isLoginForm ? 'login' : 'signup');
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void initState() {
    _isLoginForm = widget.type == 'signup' ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeTextTheme = Theme.of(context).textTheme;
    final themeColorScheme = Theme.of(context).colorScheme;
    // debugPrint(widget.canChangePass.toString());

    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        width:
            widget.isEditForm ? double.infinity : mediaQuery.size.width * .85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: Colors.amber,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            children: [
              if (!widget.isEditForm)
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _isLoginForm ? 'Login' : 'Signup',
                    style: themeTextTheme.titleSmall
                        ?.copyWith(color: themeColorScheme.primary),
                  ),
                ),
              Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      if (!_isLoginForm || widget.isEditForm) ...[
                        CircleImageInput(
                          _getSelectedImage,
                          prevImageUrl: widget.editData['imageUrl'] ?? '',
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Name'),
                            hintText: 'Your name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter valid name';
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredData['name'] = newValue!.trim();
                          },
                          initialValue: widget.isEditForm
                              ? widget.editData['name']
                              : null,
                        ),
                      ],
                      if (!widget.isEditForm)
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Email'),
                            hintText: 'Your Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (!value!.contains('@')) {
                              return 'Email address should contain @';
                            }
                            if (value.isEmpty) return 'Enter valid email';
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredData['email'] = newValue!.trim();
                          },
                        ),
                      if (widget.isEditForm && widget.canChangePass)
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Current Password'),
                            hintText: 'Your Current Password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter valid password';
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredData['prevPassword'] = newValue!.trim();
                          },
                        ),
                      if (widget.canChangePass)
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(widget.isEditForm
                                ? 'New Password'
                                : 'Password'),
                            hintText: widget.isEditForm
                                ? 'Your new password'
                                : 'Your Password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter valid password';
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredData['password'] = newValue!.trim();
                          },
                        ),
                      if (_isLoginForm && !widget.isEditForm) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: const Alignment(1, 0),
                          child: MaterialHelper.buildWholeClickableText(
                            text: 'Forget Password?',
                            onPressHandler: () {
                              Navigator.of(context)
                                  .pushNamed(ForgetPasswordScreen.namedRoute);
                            },
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: themeColorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 20,
                      ),
                      if (widget.isLoading) const CircularProgressIndicator(),
                      if (!widget.isLoading) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            minimumSize: const Size.fromHeight(
                              40,
                            ),
                          ),
                          onPressed: _submitData,
                          child: Text(
                            widget.isEditForm
                                ? 'Save Data'
                                : _isLoginForm
                                    ? 'Login'
                                    : 'Signup',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (!widget.isEditForm)
                          MaterialHelper.buildClickableText(
                            context,
                            _isLoginForm
                                ? 'Don\'t have an account ? '
                                : 'Have account ? ',
                            _isLoginForm ? 'Signup' : 'Login',
                            () {
                              setState(() {
                                _isLoginForm = !_isLoginForm;
                              });
                            },
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!widget.isEditForm)
                if (!widget.isLoading)
                  AuthBottom(
                    _isLoginForm,
                    _authWithHandler,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
