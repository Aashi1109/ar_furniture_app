import 'package:flutter/material.dart';

import 'admin_user_item.dart';
import '../../../helpers/material_helper.dart';
import '../../../helpers/firebase_helper.dart';
import '../../../constants.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});
  static const namedRoute = '/admin-user-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          kDefaultPadding,
        ),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(
              context,
              'Users',
            ),
            Expanded(
              child: FutureBuilder(
                future: FirebaseHelper.getUserCollection(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final usersData = snapshot.data?.docs;
                    if (usersData != null) {
                      debugPrint(usersData.toString());
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) => AdminUserItem(
                          userId: usersData[index].id,
                          imageUrl: usersData[index]['profileData']
                              ['profileData']['imageUrl'],
                          userName: usersData[index]['profileData']
                              ['profileData']['name'],
                        ),
                        itemCount: usersData.length,
                      );
                    }
                  }
                  if (snapshot.hasError) {
                    debugPrint('error in fetching user data ${snapshot.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
