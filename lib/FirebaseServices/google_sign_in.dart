import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestoreServices {
  static final GoogleSignIn _google = GoogleSignIn.instance;
  static bool isInitialize = false;

  static Future<void> _intiSignIn() async {
    if (!isInitialize) {
      await _google.initialize(
        serverClientId:
            '384637728273-g29laasgh1n8t8tfu5c4b7ktebki6q8m.apps.googleusercontent.com',
      );
    }
    isInitialize = true;
  }

  static Future<UserCredential> signInWithGoogle() async {
    _intiSignIn();
    GoogleSignInAccount account = await _google.authenticate();
    final idToken = account.authentication.idToken;
    final authClient = account.authorizationClient;
    GoogleSignInClientAuthorization? auth = await authClient
        .authorizationForScopes(['email', 'profile']);
    final accessToken = auth?.accessToken;
    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
