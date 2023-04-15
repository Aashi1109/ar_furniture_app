import 'package:flutter/material.dart';

class AdminUserItem extends StatelessWidget {
  const AdminUserItem({
    super.key,
    required this.userId,
    required this.userName,
    required this.imageUrl,
  });
  final String userId;
  final String userName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: themeColorScheme.tertiary,
        ),
        color: themeColorScheme.onPrimary,
      ),
      child: Column(
        children: [
          Image.network(
            imageUrl,
            height: 40,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            userName.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
