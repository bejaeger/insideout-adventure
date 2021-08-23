import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

// This is needed with flutter's new null-safety
// @see https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md
class MockFirebaseUser extends Mock implements User {
  @override
  String get uid =>
      super.noSuchMethod(Invocation.getter(#uid), returnValue: "uid");
  @override
  String get displayName => super.noSuchMethod(Invocation.getter(#displayName),
      returnValue: "displayName");
  @override
  String get email =>
      super.noSuchMethod(Invocation.getter(#email), returnValue: "email");
}
