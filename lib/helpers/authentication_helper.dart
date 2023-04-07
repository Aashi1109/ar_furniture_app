import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthenticationHelper {
  static Future<OAuthCredential> authWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return credential;

    // // Once signed in, get the user information from Google
    // final user = await FirebaseAuth.instance.signInWithCredential(credential);
    // return user;
  }

  //static Future<OAuthCredential> authWithFacebook() async {
    // Trigger the sign-in flow
  //  final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
  //  final OAuthCredential facebookAuthCredential =
   //     FacebookAuthProvider.credential(result.accessToken!.token);

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance
    //     .signInWithCredential(facebookAuthCredential);
  //  return facebookAuthCredential;
  //}
}
