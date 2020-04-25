import 'package:eventapp/model/user.dart';
import 'package:eventapp/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  emailNotVerified,
  userProfileNotCreated,
  loggedIn,
  loggedOut,
}

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository;

  static final AuthService instance = AuthService(UserRepository());

  AuthService(this._userRepository);

  Future<User> getUserIfLoggedIn() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser == null) return null;
    User user = await _userRepository.getById(firebaseUser.uid);
    if (user == null) return null;
    user.isVerified = firebaseUser.isEmailVerified;
    return user;
  }

  Future<User> getCurrentUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser == null) return null;
    return User(id: firebaseUser.uid, email: firebaseUser.email);
  }

  Future<AuthStatus> getAuthStatus() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser == null) return AuthStatus.loggedOut;
    if (!firebaseUser.isEmailVerified) return AuthStatus.emailNotVerified;
    User user = await _userRepository.getById(firebaseUser.uid);
    if (user == null) return AuthStatus.userProfileNotCreated;
    user.isVerified = firebaseUser.isEmailVerified;
    return AuthStatus.loggedIn;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
