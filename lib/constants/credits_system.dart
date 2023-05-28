const double kDollarToCreditsConversionFactor = 10;
const double kCentsToCreditsConversionFactor =
    kDollarToCreditsConversionFactor * 0.01;

class CreditsSystem {
  static const double kCreditsToScreenTimeConversionFactor =
      1; // 1 credit = 1 minute

  static const double kDistanceInMeterToActivityMinuteConversion =
      0.001 * 30; // 1km -> 30min

  static const double kMinuteActivityToScreenTimeConversion = 0.5 *
      kCreditsToScreenTimeConversionFactor; // 20 min activity -> 10 min screen time

  static const double kMinuteActivityToCreditsConversion = 1 / 3;
  // 30 min activity -> 10 min screen time * (credits / screentime factor)

  static const double kSimpleDistanceMarkersToDistanceWalkScaling = 1.2;

  static int screenTimeToCredits(int minutes) {
    return (minutes / CreditsSystem.kCreditsToScreenTimeConversionFactor)
        .round();
  }

  static int creditsToScreenTime(num credits) {
    return (credits * CreditsSystem.kCreditsToScreenTimeConversionFactor)
        .round();
  }
}
