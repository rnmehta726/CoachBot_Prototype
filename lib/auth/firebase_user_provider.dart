import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class CoachBotFirebaseUser {
  CoachBotFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

CoachBotFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<CoachBotFirebaseUser> coachBotFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<CoachBotFirebaseUser>(
            (user) => currentUser = CoachBotFirebaseUser(user!));
