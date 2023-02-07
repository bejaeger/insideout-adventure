# InsideOutAdventure
This is the mobile adventure app of InsideOutAdventure

## Legacy naming
Some classes still use legacy names. This is a list of terms that are used interchangeably:
- Sponsor = Parent, Explorer = Child
- Payment = Money Transfer = Credit Transfer
- AFK(Credits) = Hercules(Credits) = InsideOut(Credits) = Credits

## Setup
- Google Maps key
  - Set environment variable: `GOOGLE_MAPS_API_KEY_ENVIRONMENT_VARIABLE` called in
    - Android: in `android/local.properties`
    - iOS: in `ios/Flutter/Debug.xcconfig` and `ios/Flutter/Release.xcconfig`.
- Google Authentication key
  - Android: TBA
  - iOS: Currently `ios/Runner/Info.plist`
- Firebase Key
  - Use firebase CLI. 
  - Use `configure-flutterfire-dev.sh` and `configure-flutterfire-prod.sh`
  - `ios/Runner/GoogleService-Info.plist` might still be necessary