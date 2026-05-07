import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ================= CURRENT USER =================

  User? get currentUser => auth.currentUser;

  // ================= GET USER STREAM =================

  Stream<DocumentSnapshot> getUserData() {
    final user = currentUser;

    return firestore.collection('users').doc(user!.uid).snapshots();
  }

  // ================= SAVE PROFILE =================

  Future<void> saveProfile({
    required String name,
    required String email,
  }) async {
    final user = currentUser;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'name': name.trim(),
        'email': email.trim(),
      }, SetOptions(merge: true));
    }
  }
}
