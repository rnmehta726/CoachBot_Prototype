import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


Future<User?> signInWithEmail(BuildContext context, String email, String password) async {
  // final signInFunc = () =>
  try{
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: password);
    return user.user;
  } on FirebaseAuthException catch (e){
    return null;
  }
  // return signInOrCreateAccount(context, signInFunc);
}

// Future<User?> createAccountWithEmail(
//     BuildContext context, String email, String password) async {
//   final createAccountFunc = () => FirebaseAuth.instance
//       .createUserWithEmailAndPassword(email: email.trim(), password: password);
//   return signInOrCreateAccount(context, createAccountFunc);
// }
