import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// This class contains methods to signin with different authentication
/// providers e.g. `Google`.
/// For now only google authentication is implemented.
class AuthenticationHelper {
  /// It returns `OAuthCredential` which is obtained by signing in or signup with
  /// by selecting a google account from popup window which opens using
  /// `GoogleSignIn().signIn()` method. Doesn't signup or login handle it using
  /// `FirebaseAuth`.
  ///
  /// Before authentication process `GoogleSignIn().disconnect()` is used so that
  /// it shows popup window instead of automatically using previus email and then
  /// authenticating with it.
  static Future<OAuthCredential> authWithGoogle() async {
    // Trigger the authentication flow
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }

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
