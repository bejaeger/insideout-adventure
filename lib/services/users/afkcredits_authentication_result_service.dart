import 'package:afkcredits/datamodels/users/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

/// AFK Credits authentication result
/// We need this abstraction because we
/// can have users not authenticated with
/// firebase authentication (explorer accounts
/// added from sponsors)

class AFKCreditsAuthenticationResultService {
  final User? user;
  Map<String, User> supportedExplorers = {};

  final firebase.User? firebaseUser;
  final String? uid;

  final bool fromLocalStorage;
  final FirebaseAuthenticationResult? firebaseAuthenticationResult;

  final String? errorMessage;

  AFKCreditsAuthenticationResultService.authenticatedUser({this.firebaseUser})
      : errorMessage = null,
        user = null,
        fromLocalStorage = false,
        uid = firebaseUser?.uid,
        firebaseAuthenticationResult = null;

  AFKCreditsAuthenticationResultService.fromFirebaseAuthenticationResult(
      {this.firebaseAuthenticationResult})
      : errorMessage = firebaseAuthenticationResult?.errorMessage,
        firebaseUser = firebaseAuthenticationResult?.user,
        uid = firebaseAuthenticationResult?.user?.uid,
        fromLocalStorage = false,
        user = null;

  AFKCreditsAuthenticationResultService.explorerCreatedFromSponsor({this.user})
      : errorMessage = null,
        firebaseUser = null,
        uid = user?.uid,
        fromLocalStorage = false,
        firebaseAuthenticationResult = null;

  AFKCreditsAuthenticationResultService.fromLocalStorage({this.uid})
      : errorMessage = null,
        firebaseUser = null,
        user = null,
        fromLocalStorage = true,
        firebaseAuthenticationResult = null;

  AFKCreditsAuthenticationResultService.error({this.errorMessage})
      : user = null,
        firebaseUser = null,
        uid = null,
        fromLocalStorage = false,
        firebaseAuthenticationResult = null;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  bool get isExplorerCreatedFromSponsor =>
      (firebaseUser == null && user != null) ||
      (firebaseUser == null && user == null && uid != null);

  List<User> get supportedExplorersList {
    List<User> list = [];
    supportedExplorers.forEach((key, value) {
      list.add(value);
    });
    return list;
  }
}
