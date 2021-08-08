enum Flavor { unknown, dev, prod }

class FlavorConfigProvider {
  Flavor flavor = Flavor.unknown;
  void configure(Flavor flavorIn) {
    flavor = flavorIn;
  }

  String get appName {
    switch (this.flavor) {
      case Flavor.dev:
        return "The Good Wallet - Dev";
      case Flavor.prod:
        return "The Good Wallet";
      default:
        return "The Good Wallet - Dev";
    }
  }
}
