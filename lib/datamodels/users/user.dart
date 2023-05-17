import 'package:afkcredits/datamodels/users/settings/user_settings.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/datamodel_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  static List<String> _checkIfKeywordsAreSet(List<String>? searchKeywords) {
    if (searchKeywords == null) {
      throw DataModelException(
          message:
              "User: You can't serialize User data that still has no 'keywordList' attached!",
          devDetails:
              "Please provide a 'keywordList' which will be used to query usernames with Firestore queries");
    } else
      return searchKeywords;
  }

  @JsonSerializable(explicitToJson: true)
  factory User({
    required String uid,
    required String fullName,
    String? email,
    required List<String> guardianIds,
    required List<String> explorerIds,
    required UserRole role,
    UserSettings? userSettings,
    AuthenticationMethod? authMethod,
    @Default(true)
        bool newUser,
    @JsonKey(
      toJson: User._checkIfKeywordsAreSet,
    )
        List<String>? fullNameSearch,
    String? createdByUserWithId,
    String? password,
    List<String>? tokens,
    String? deviceId,
    @Default(1)
        int? avatarIdx,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// Unfortunately json serializable only supports literals as default
// We simply create a top-level function to get an empty a user statistics
// model that is empty. This is used for creating the initial documents in firestore
User getEmptyUser() {
  return User(
    uid: "",
    fullName: "",
    email: "",
    role: UserRole.unassigned,
    authMethod: AuthenticationMethod.dummy,
    guardianIds: [],
    explorerIds: [],
    newUser: false,
    userSettings: UserSettings(),
  );
}
