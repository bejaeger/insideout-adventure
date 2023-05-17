import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_user_info.freezed.dart';
part 'public_user_info.g.dart';

// class holding public info of user

@freezed
class PublicUserInfo with _$PublicUserInfo {
  factory PublicUserInfo({
    required String uid,
    required String name,
    String? email,
    String? errorMessage,
    bool? hasGuardian,
  }) = _PublicUserInfo;

  factory PublicUserInfo.fromJson(Map<String, dynamic> json) =>
      _$PublicUserInfoFromJson(json);
}
