import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_util.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_transform/stream_transform.dart';
import 'firebase_user_provider.dart';

export 'email_auth.dart';

/// Tries to sign in or create an account using Firebase Auth.
/// Returns the User object if sign in was successful.

signOut() {
  FirebaseAuth.instance.signOut();
}

Future deleteUser(BuildContext context) async {
  try {
    if (currentUser?.user == null) {
      print('Error: delete user attempted with no logged in user!');
      return;
    }
    await currentUser?.user?.delete();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Too long since most recent sign in. Sign in again before deleting your account.')),
      );
    }
  }
}

Future resetPassword(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message}')),
    );
    return null;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Password reset email sent')),
  );
}

// Future sendEmailVerification() async =>
//     currentUser?.user?.sendEmailVerification();
//
// String _currentJwtToken = '';
//
// String get currentUserEmail =>
//     currentUserDocument?.email ?? currentUser?.user?.email ?? '';
//
// String get currentUserUid => currentUser?.user?.uid ?? '';
//
// String get currentUserDisplayName =>
//     currentUserDocument?.displayName ?? currentUser?.user?.displayName ?? '';
//
// String get currentUserPhoto =>
//     currentUserDocument?.photoUrl ?? currentUser?.user?.photoURL ?? '';
//
// String get currentPhoneNumber =>
//     currentUserDocument?.phoneNumber ?? currentUser?.user?.phoneNumber ?? '';
//
// String get currentJwtToken => _currentJwtToken ?? '';
//
// bool get currentUserEmailVerified {
//   // Reloads the user when checking in order to get the most up to date
//   // email verified status.
//   if (currentUser?.user != null && !currentUser!.user.emailVerified) {
//     currentUser.user
//         .reload()
//         .then((_) => currentUser.user = FirebaseAuth.instance.currentUser);
//   }
//   return currentUser?.user?.emailVerified ?? false;
// }

