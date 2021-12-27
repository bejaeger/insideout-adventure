import 'package:afkcredits/enums/user_role.dart';

import 'constants/constants.dart';

enum Flavor { unknown, dev, prod }

class FlavorConfigProvider {
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

  Flavor flavor = Flavor.unknown;
  void configure(Flavor flavorIn) {
    flavor = flavorIn;
  }

  String get appName {
    switch (this.flavor) {
      case Flavor.dev:
        return "AFK Credits - Dev";
      case Flavor.prod:
        return "AFK Credits - Proto v2";
      default:
        return "AFK Credits - Dev";
    }
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
      return "superUser@gmail.com";
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
}
