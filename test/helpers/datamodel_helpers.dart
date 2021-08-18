import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/user_role.dart';

User getTestUserSponsor() {
  return User(
    uid: "testId",
    fullName: "testName",
    email: "test@email.com",
    role: UserRole.sponsor,
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
  );
}

User getTestUserExplorer() {
  return User(
    uid: "testId",
    fullName: "testName",
    email: "test@email.com",
    role: UserRole.explorer,
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
  );
}

User getTestUserAdmin() {
  return User(
    uid: "testId",
    fullName: "testName",
    email: "test@email.com",
    role: UserRole.admin,
    sponsorIds: [],
    explorerIds: [],
    newUser: false,
  );
}
