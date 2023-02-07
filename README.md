# InsideOutAdventure
This is the mobile adventure app of InsideOutAdventure

## Legacy naming
Some classes still use legacy names. This is a list of terms that are used interchangeably:
- Sponsor = Parent, Explorer = Child
- Payment = Money Transfer = Credit Transfer
- AFK(Credits) = Hercules(Credits) = InsideOut(Credits) = Credits
- In project settings/names sometimes afkcredits or hercules is still used instead of insideout(adventure)

## Setup
- Google Maps key
  - Set environment variable: `GOOGLE_MAPS_API_KEY_ENVIRONMENT_VARIABLE` called in
    - Android: in `android/local.properties`
    - iOS: in `ios/Flutter/Debug.xcconfig` and `ios/Flutter/Release.xcconfig`.
- Google Authentication
  - Android: TBA
  - iOS: Currently `ios/Runner/Info.plist`
- iOS Authentication
  - 
- Firebase Key
  - Use firebase CLI. 
  - Use `configure-flutterfire-dev.sh` and `configure-flutterfire-prod.sh`
  - `ios/Runner/GoogleService-Info.plist` might still be necessary

## Firebase configuration
We use the firebase CLI. 
```
# install firebase tools
npm install -g firebase-tools
# log in to firebase with the Google account used for the Firebase projects.
firebase login
# list all projects with 
firebase projects:list
# switch projects with 
firebase use <project_id>
```
The project IDs of our development database is `afk-credits-112d2`, our production database has the id `afk-credits-prod` (afk-credits is a legacy name). 
Now you can generate the firebase configuration file with flutterfire
```
# for the dev environment (only setup for Android)
source configure-flutterfire-dev.sh
# for the prod environment (select both, Android and iOS
source configure-flutterfire-prod.sh
```
This will generate the necessary files to be able to register the app with firebase.