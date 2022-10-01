import 'package:afkcredits/enums/authentication_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sponsor_reference.freezed.dart';
part 'sponsor_reference.g.dart';

/////////////////////////////////
///
/// Model that holds a reference to a sponsor
/// in the scenario where the explorer does not
/// have his own phone.
/// The sponsor can switch to his account
/// with a reference stored in this datamodel.
///
//////////////////////////////////////

@freezed
class SponsorReference with _$SponsorReference {
  factory SponsorReference({
    required String uid,
    AuthenticationMethod? authMethod,
    String? deviceId,
    required bool withPasscode,
  }) = _SponsorReference;

  factory SponsorReference.fromJson(Map<String, dynamic> json) =>
      _$SponsorReferenceFromJson(json);
}
