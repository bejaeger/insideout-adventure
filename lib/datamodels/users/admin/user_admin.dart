import 'package:afkcredits/enums/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_admin.freezed.dart';
part 'user_admin.g.dart';

@freezed
class UserAdmin with _$UserAdmin {
  factory UserAdmin({
    required String id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
  }) = _UserAdmin;
  factory UserAdmin.fromJson(Map<String, dynamic> json) =>
      _$UserAdminFromJson(json);
}
