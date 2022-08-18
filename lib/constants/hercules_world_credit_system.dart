const double kDollarToAfkCreditsConversionFactor = 10;
const double kCentsToAfkCreditsConversionFactor =
    kDollarToAfkCreditsConversionFactor * 0.01;

class HerculesWorldCreditSystem {
  static const double kCreditsToScreenTimeConversionFactor =
      1; // 1 credit = 1 minute

  static const double kDistanceInMeterToActivityMinuteConversion =
      0.001 * 20; // 1km -> 20min

  static const double kMinuteActivityToScreenTimeConversion = 0.5 *
      kCreditsToScreenTimeConversionFactor; // 20 min activity -> 10 min screen time

  static const double kMinuteActivityToCreditsConversion = 0.5 /
      kCreditsToScreenTimeConversionFactor; // 20 min activity -> 10 min screen time * (credits / screentime factor)
}
