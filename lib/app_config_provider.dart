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

  String get versionName => "0.1.0+1";

  String get appName {
    switch (this.flavor) {
      case Flavor.dev:
        return "Hercules World - Dev";
      case Flavor.prod:
        return "Hercules World - v0.1.0+1";
      default:
        return "Hercules World - Dev";
    }
  }

  void setIsARAvailable(bool set) {
    isARAvailable = set;
  }

  String getTestUserEmail(UserRole? role) {
    /* if (role == null) return "";
    if (role == UserRole.explorer) {
      return "test@gmail.com";
    }
    if (role == UserRole.sponsor) {
      return "test2@gmail.com";
    } else {
      return "";
    } */

    if (role == UserRole.explorer) {
      return "test@gmail.com";
    } else if (role == UserRole.sponsor) {
      return "test2@gmail.com";
    } else if (role == UserRole.adminMaster) {
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

  String getTestUserId(UserRole role) {
    /* if (this.flavor == Flavor.prod) {
      return "";
    } else {
      if (role == UserRole.explorer) {
        return "anLaRoIZCXU0TgZYTmp1AVnRhnD3";
      }
      if (role == UserRole.sponsor) {
        return "N3INiSGUOvXsinbbyKZhFvq3AbW2";
      } else {
        return "";
      }
    } */
    if (this.flavor == Flavor.prod) {
      return "";
    } else {
      if (role == UserRole.explorer) {
        return "anLaRoIZCXU0TgZYTmp1AVnRhnD3";
      } else if (role == UserRole.sponsor) {
        return "N3INiSGUOvXsinbbyKZhFvq3AbW2";
      } else if (role == UserRole.adminMaster) {
        return "tSeaJAjbZteeHYYmcU9k5TvlOcS2";
      } else if (role == UserRole.admin) {
        return "RhLyUQmewCXH8pF7VQsFKADK9hs1";
      } else if (role == UserRole.superUser) {
        return "Ag0rQIXsayPbAL7A8Ohk5h6tyo92";
      } else {
        return "";
      }
    }
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
