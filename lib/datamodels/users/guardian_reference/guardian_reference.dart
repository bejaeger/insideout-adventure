import 'package:afkcredits/enums/authentication_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'guardian_reference.freezed.dart';
part 'guardian_reference.g.dart';

///
/// Model that holds a reference to a guardian
/// in the scenario where the explorer does not
/// have his own phone.
/// The guardian can switch to his account
/// with a reference stored in this datamodel.
///

@freezed
class GuardianReference with _$GuardianReference {
  factory GuardianReference({
    required String uid,
    AuthenticationMethod? authMethod,
    String? deviceId,
    required bool withPasscode,
  }) = _GuardianReference;

  factory GuardianReference.fromJson(Map<String, dynamic> json) =>
      _$GuardianReferenceFromJson(json);
}
