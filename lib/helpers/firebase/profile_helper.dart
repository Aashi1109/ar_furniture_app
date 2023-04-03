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

  static UploadTask uploadImage(File image, String imageName,
      {String uploadPath = userProfileImagesPath}) {
    final ref =
        FirebaseStorage.instance.ref().child(uploadPath).child(imageName);

    return ref.putFile(image);
  }

  static Future<void> saveExtraUserDataInFirestore(
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
}
