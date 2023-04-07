import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_helper.dart';

import 'package:firebase_storage/firebase_storage.dart';

class ProfileHelper {
  static const userProfileImagesPath = 'profileImages';
  static const userProfileDataPath = 'profileData';

  static CollectionReference<Map<String, dynamic>>
      getUserProfileImagesCollection() {
    final userProfileImagesCollection =
        FirebaseHelper.getUserDoc().collection(userProfileImagesPath);

    return userProfileImagesCollection;
  }

  static CollectionReference<Map<String, dynamic>> getUserProfileDataCollection(
      {String? userId}) {
    final userProfileImagesCollection =
        FirebaseHelper.getUserDoc(uid: userId).collection(userProfileDataPath);

    return userProfileImagesCollection;
  }

  static UploadTask uploadImage(String imagePath,
      {String uploadPath = userProfileImagesPath}) {
    final image = File(imagePath.toString());
    final imagePathSplit = imagePath.toString().split('/');
    final imageName = imagePathSplit[imagePathSplit.length - 1];

    final ref =
        FirebaseStorage.instance.ref().child(uploadPath).child(imageName);

    return ref.putFile(image);
  }

  static Future<void> saveProfileDataInFirestore(
    Map<String, dynamic> data,
  ) {
    final userProfilesCollection = getUserProfileDataCollection();
    // print(userProfilesCollection.toString());
    return userProfilesCollection.doc('profileData').set(
        data,
        SetOptions(
          merge: true,
        ));
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getUserProfileDataFromFirestore({String? userId}) {
    final userProfileDataCollection = getUserProfileDataCollection(
      userId: userId,
    );
    return userProfileDataCollection.doc(userProfileDataPath).get();
  }

  static Future<void> saveUserDataInFirestore(
    String imgPath,
    String name, {
    bool isUpdate = false,
    String? imageUrl,
  }) async {
    Map<String, dynamic> dataToPush = {
      'name': name,
    };
    if (imgPath.isNotEmpty) {
      final imageUploadTask = ProfileHelper.uploadImage(imgPath);
      dataToPush['imageUrl'] =
          await (await imageUploadTask).ref.getDownloadURL();
    }
    if (!isUpdate) {
      dataToPush['createdAt'] = Timestamp.now();
    }
    if (imageUrl != null) {
      dataToPush['imageUrl'] = imageUrl;
    }
    await ProfileHelper.saveProfileDataInFirestore(dataToPush);
  }
}
