import 'package:decal/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProviderModel>(context, listen: false);

    return ListTile(
      horizontalTitleGap: 10,
      contentPadding: EdgeInsets.zero,
      leading: Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            authProvider.userImageUrl,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        'Welcome',
        style: TextStyle(
          color: Colors.grey[600],
        ),
        // style: Theme.of(context).textTheme.displaySmall?.copyWith(
        //       color: themeColorScheme.primary,
        //       fontWeight: FontWeight.bold,
        //     ),
      ),
      subtitle: Text(
        authProvider.userName,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: themeColorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
      trailing: Stack(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size.square(38),
              maximumSize: const Size.square(38),
              padding: EdgeInsets.zero,
              backgroundColor: themeColorScheme.tertiary,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: themeColorScheme.primary,
            ),
          ),
          Positioned(
            top: 10,
            right: 13,
            child: CircleAvatar(
              backgroundColor: themeColorScheme.error,
              radius: 4,
            ),
          ),
        ],
      ),
    );
  }
}
