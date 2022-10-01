import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:afkcredits/exceptions/datamodel_exception.dart';

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
    required List<String> sponsorIds,
    required List<String> explorerIds,
    required UserRole role,
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
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
  );
}
