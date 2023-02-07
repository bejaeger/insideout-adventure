# InsideOutAdventure
This is the mobile adventure app of InsideOutAdventure

# Setup instructions

## Get code and packages
The current version is tested with
```
Flutter 3.0.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision f1875d570e (7 months ago) • 2022-07-13 11:24:16 -0700
Engine • revision e85ea0e79c
Tools • Dart 2.17.6 • DevTools 2.12.2
```
Checkout the correct flutter version, clone the repo and run
```bash
flutter pub get
# set necessary env variables with api keys
source setup.sh # (requires .env file to be present)
```

## Firebase configuration
We use the firebase CLI. 
```bash
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
Now we can generate the firebase configuration file with flutterfire
```bash
# for the dev environment 
source configure-flutterfire-dev.sh
# for the prod environment
source configure-flutterfire-prod.sh
```
Among other files, this will generate a `android/app/google-service.json` and `ios/Runner/GoogleService-Info.plist` that configures the app with firebase. To conveniently switch between dev and prod project, move the `google-service.json` file to `android/app/src/dev` and `andoird/app/src/prod`, respectively. For iOS, the above command currently needs to be re-executed whenever the firebase project is switched.

## Running the app with different flavors
We use different Flutter flavors to run the app with the different firebase projects. The following runs the app in development flavor calling the `main_dev.dart` file as entry point
```bash
flutter run --flavor dev -t lib/main_dev.dart --debug
```
To run the prod environment switch the firebase project and run
```bash
flutter run --flavor prod -t lib/main_prod.dart --debug
```
Note that some warnings are currently expected when building the app.
For iOS, it is recommended to run in `--release` mode, because otherwise the app cannot be used on the phone standalone. 
For convenience, different modes are configured in `.vscode/launch.json`

# Developer Wiki
## Framework / state Management

- We use the stacked solution as state management as it is one of the cleanest solution out there (Find an introduction video [here](https://www.youtube.com/watch?v=hEy_36LPcgQ&ab_channel=FilledStacks))
- Example commit with addition of datamodel, new service, firestore api connection: commit `2fa8996` ([link](https://github.com/bejaeger/afk-credits/commit/2fa8996faddc2a9290766953fa34b220f0a88158))
- Example commit for adding a new view: commit `2bcf41b` ([link](https://github.com/bejaeger/afk-credits/commit/2bcf41bf0f28713b12f627b55c89e395e641091b))

## Coding Guidelines
- Generally we follow the guidelines from the stacked framework. 
- Please log what the code is doing with an appropriate logger level (Tip: filter for `flutter` in the debug console to only get our logger outputs)
- Please try to write self-documenting code and only add comments when it is really necessary to understand the logic or to explain the reason behind a code snippet that otherwise might be forgotten.

## Code Generation
- We use the `StackedGenerator` to generate the code for our locator (dependency injection) as well as the necessary router information. This happens in `lib/app/app.dart`.
- We use [freezed](https://pub.dev/packages/freezed) and [json_serializable](https://pub.dev/packages/json_serializable) to generate the code for our datamodels.
- Run `source runCodeGen.sh` to generate all required snippets.
- `watchCodeGen.sh` can be used to continuously update all generated code whenever a file changes.

## Version control
- We follow a [feature branch workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)

# Information about status of code

## Legacy naming
Some classes or packages still use legacy names. This is a list of terms that are used interchangeably:
- Sponsor = Parent, Explorer = Child
- Payment = Money Transfer = Credit Transfer
- AFK(Credits) = Hercules(Credits) = InsideOut(Credits) = Credits
- In project settings/names sometimes afkcredits or hercules is still used instead of insideout(adventure)

