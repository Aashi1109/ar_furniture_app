import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../firebase_helper.dart';

/// It holds all the methods to add and update profile data in
/// firestore. profile data is store in userDoc having id as
/// `[profileData]`.
/// The Structure of how profile's data is stored in firestore
/// `[users > userId > profileData > profileData > {...profile data...}]`.
/// No error handling is done is here it should be handled where you are using
/// it.
class ProfileHelper {
  static const userProfileImagesPath = 'profileImages';
  static const userProfileDataPath = 'profileData';

  /// Returns users profile images collection for current user
  static CollectionReference<Map<String, dynamic>>
      getUserProfileImagesCollection() {
    final userProfileImagesCollection =
        FirebaseHelper.getUserDoc().collection(userProfileImagesPath);

    return userProfileImagesCollection;
  }

  /// Returns user's profile data. [userId] can be used to get profile data for a
  /// particular user.
  static CollectionReference<Map<String, dynamic>> getUserProfileDataCollection(
      {String? userId}) {
    final userProfileImagesCollection =
        FirebaseHelper.getUserDoc(uid: userId).collection(userProfileDataPath);

    return userProfileImagesCollection;
  }

  /// Uploads images to a location. By default it is saved to `userProfileImagesPath`
  /// but can be set to other local too if required. [imageData] is dynamic but it
  /// can be only of `Uint8List` or `File` if not from these then file won't be
  /// uploaded properly
  static UploadTask uploadImage({
    String uploadPath = userProfileImagesPath,
    dynamic imageData,
    // Uint8List? imageList,
  }) {
    final ref = FirebaseStorage.instance.ref().child(uploadPath);
    if (imageData is File) {
      // final image = imageData;
      final imagePath = imageData.path;
      final imagePathSplit = imagePath.toString().split('/');
      final imageName = imagePathSplit[imagePathSplit.length - 1];

      final fileRef = ref.child(imageName);

      return fileRef.putFile(imageData);
    } else if (imageData is Uint8List) {
      final listRef = ref.child('ss_${Timestamp.now()}.jpg');
      return listRef.putData(imageData);
    }

    return ref.putData(Uint8List.fromList([]));
  }

  /// Saves user profile's data to `userProfileDataPath`. It doesn't override
  /// previous data but merge with it so that whenever some part is updated it
  /// won't delete previous.
  static Future<void> saveProfileDataInFirestore(
    Map<String, dynamic> data,
  ) {
    final userProfilesCollection = getUserProfileDataCollection();
    // print(userProfilesCollection.toString());
    return userProfilesCollection.doc(userProfileDataPath).set(
          data,
          SetOptions(
            merge: true,
          ),
        );
  }

  /// Returns user's profile data. By default it returns current user's data.
  /// By providing [userId] data for that user can also be obtained.
  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getUserProfileDataFromFirestore({String? userId}) {
    final userProfileDataCollection = getUserProfileDataCollection(
      userId: userId,
    );
    return userProfileDataCollection.doc(userProfileDataPath).get();
  }

  /// Saves user's profile data by internally calling [saveProfileData()] and
  /// [uploadImage()]. This method takes necessary params based on that it saves
  /// profile Data for user.
  /// - `imgPath` should be given when you are using local files
  /// - `imageUrl` should be used when you have hosted url of image file
  /// - `isUpdate` used when you are trying to update previous information. By
  /// setting it as false it is expected that you are creating new data.
  ///
  /// - `name` used to set display name.
  static Future<void> saveUserDataInFirestore({
    String? imgPath,
    String? name,
    bool isUpdate = false,
    String? imageUrl,
  }) async {
    Map<String, dynamic> dataToPush = {
      'name': name,
    };
    if (imgPath != null) {
      final imageUploadTask = ProfileHelper.uploadImage(
        imageData: File(imgPath),
      );
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
