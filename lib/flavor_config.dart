enum Flavor { unknown, dev, prod }

class FlavorConfigProvider {
  Flavor flavor = Flavor.unknown;
  void configure(Flavor flavorIn) {
    flavor = flavorIn;
  }

  String get appName {
    switch (this.flavor) {
      case Flavor.dev:
        return "AFK Credits - Dev";
      case Flavor.prod:
        return "AFK Credits";
      default:
        return "AFK Credits - Dev";
    }
  }

  String get testUserEmail {
    return "test@gmail.com";
  }

  String get testUserPassword {
    return "m1m1m1";
  }

  String get testUserId {
    switch (this.flavor) {
      case Flavor.dev:
        return "anLaRoIZCXU0TgZYTmp1AVnRhnD3";
      case Flavor.prod:
        return "";
      default:
        return "anLaRoIZCXU0TgZYTmp1AVnRhnD3";
    }
  }
}
