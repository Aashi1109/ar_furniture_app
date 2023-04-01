import 'package:decal/helpers/shared_preferences_helper.dart';
import 'package:decal/screens/auth_screen.dart';
import 'package:decal/widgets/onboard/onboard_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final List<Map<String, String>> _onboardData = [
    {
      'image': 'assets/images/image2c.png',
      'text':
          'Explore World Class Top Furnitures as per your Requirements and Choice.'
    },
    {
      'image': 'assets/images/image1c.png',
      'text': 'Create your own Space and Design using Augmented Reality.'
    },
    {
      'image': 'assets/images/image6.png',
      'text':
          'View and Experience Furniture with the help of Augmented Reality.'
    },
  ];

  int _curIndex = 0;

  void _clickSwipeHandler() {
    setState(() {
      _curIndex = _curIndex < _onboardData.length - 1 ? _curIndex + 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: mediaQuery.viewPadding.top,
          ),

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                // bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
              child: Container(
                color: colorScheme.primary,
                child: Align(
                  alignment: const Alignment(-.5, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                        AuthScreen.namedRoute,
                        arguments: 'signup',
                      );
                    },
                    child: Text(
                      'Get Started ->',
                      style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.bold
                          // fontStyle: FontSty
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 550,
            // color: colorScheme.tertiary,
            child: OnboardItem(
              _onboardData[_curIndex]['image']!,
              _onboardData[_curIndex]['text']!,
            ),
          ),
          // const Spacer(),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100),
                // topRight: Radius.circular(100),
              ),
              child: Container(
                color: colorScheme.primary,
                width: double.infinity,
                // height: double.infinity,
                child: Align(
                  alignment: Alignment(
                    _curIndex == _onboardData.length - 1 ? 0 : .9,
                    0,
                  ),
                  child: InkWell(
                    onTap: _curIndex == _onboardData.length - 1
                        ? () async {
                            Navigator.of(context).pushReplacementNamed(
                              AuthScreen.namedRoute,
                              arguments: 'signup',
                            );
                            SharedPreferences preferences =
                                await SharedPreferencesHelper.preferences;
                            preferences.setBool('viewedOnboard', true);
                            debugPrint('after setting onboard data');
                          }
                        : _clickSwipeHandler,
                    child: Text(
                      _curIndex == _onboardData.length - 1
                          ? 'Login ->'
                          : 'Next ->',
                      style: textTheme.displayMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
