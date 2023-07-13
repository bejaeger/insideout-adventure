import 'package:afkcredits/enums/user_role.dart';

import 'constants/constants.dart';

enum Flavor { unknown, dev, prod }

class AppConfigProvider {
  // TODO: Add this to a specific flavor!
  // We should add a "test" flavor!

  bool allowDummyMarkerCollection = false;
  bool enableGPSVerification = true;

  // if true the dummy quests configued in dummy_data.dart
  // are going to be pushed to firestore and are also the ones
  // used for running the app
  bool pushAndUseDummyQuests = false;

  // dummy checks for quest completion for testing purposes
  bool dummyQuestCompletionVerification = false;

  // variable that is set when the app starts to check whether
  // AR functionality is available or not (defaults to false)
  bool isARAvailable = false;

  Flavor flavor = Flavor.unknown;
  void configure(Flavor flavorIn) {
    flavor = flavorIn;
  }

  bool get isDevFlavor => flavor == Flavor.dev;

  String get versionName => "1.0.0+2";
  String get contactEmail => "patrick.mayerhofer@icloud.com";

  String get appName {
    switch (this.flavor) {
      case Flavor.dev:
        return "InsideOut Adventure - Dev";
      case Flavor.prod:
        return "InsideOut Adventure - v0.1.1+2";
      default:
        return "InsideOut Adventure - Dev";
    }
  }

  void setIsARAvailable(bool set) {
    isARAvailable = set;
  }

  String getTestUserEmail(UserRole? role) {
    if (role == UserRole.ward) {
      return "test@gmail.com";
    } else if (role == UserRole.guardian) {
      return "test2@gmail.com";
    } else if (role == UserRole.admin) {
      return "adminMaster@gmail.com";
    } else if (role == UserRole.admin) {
      return "admin@gmail.com";
    } else if (role == UserRole.superUser) {
      return "superuser@gmail.com";
    } else {
      return "";
    }
  }

  String getTestUserPassword() {
    return "m1m1m1";
  }

  String get authority {
    switch (this.flavor) {
      case Flavor.dev:
        return AUTHORITYDEV;
      case Flavor.prod:
        return AUTHORITYPROD;
      default:
        return AUTHORITYDEV;
    }
  }

  String get uripathprepend {
    switch (this.flavor) {
      case Flavor.dev:
        return URIPATHPREPENDDEV;
      case Flavor.prod:
        return URIPATHPREPENDPROD;
      default:
        return URIPATHPREPENDDEV;
    }
  }

  String get notionFeedbackToken {
    switch (this.flavor) {
      case Flavor.dev:
        return kDevNotionFeedbackToken;
      case Flavor.prod:
        return kProdNotionFeedbackToken;
      default:
        return kDevNotionFeedbackToken;
    }
  }

  String get notionFeedbackDatabaseId {
    switch (this.flavor) {
      case Flavor.dev:
        return kDevNotionFeedbackDatabaseId;
      case Flavor.prod:
        return kProdNotionFeedbackDatabaseId;
      default:
        return kDevNotionFeedbackDatabaseId;
    }
  }
}
