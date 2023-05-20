# InsideOutAdventure
This is the mobile adventure app of InsideOutAdventure

# Setup instructions

## Get code and packages
### Xcode
Version: **14.1** released November 1, 2022
[Release Notes Summary](https://developer.apple.com/documentation/xcode-release-notes/xcode-14_2-release-notes)
> Xcode 14.1 includes Swift 5.7 and SDKs for iOS 16.1, iPadOS 16.1, tvOS 16.1, watchOS 9.1, and macOS Ventura.
> The Xcode 14.1 release supports on-device debugging in iOS 11 and later, tvOS 11 and later, and watchOS 4 and later.
> Xcode 14.1 requires a Mac running macOS Monterey 12.5 or later.

Relevant excerpts re: supportability ([source](https://developer.apple.com/support/xcode/))
```
Xcode Version
  Xcode 14.1
Minimum OS Required
  macOS Monterey 12.5
SDK
  iOS 16.1
  macOS 13
Deployment Targets
  iOS 11-16.1
  macOS 10.13-13
Simulator
  iOS 12.4-16.1
Swift
  Swift 4
  Swift 4.2
  Swift 5.7
```

### Flutter
The current version of the app is tested with:
```
Flutter 3.0.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision f1875d570e (7 months ago) • 2022-07-13 11:24:16 -0700
Engine • revision e85ea0e79c
Tools • Dart 2.17.6 • DevTools 2.12.2
```
Checkout the correct flutter version, clone the repo, and in the root folder of the repository run
```bash
flutter pub get
```
to define the necessary api keys as env variables run
```bash
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

We also use the flutterfire CLI
```bash
# install the flutterfire CLI
dart pub global activate flutterfire_cli

# as per the post-install prompt (at least on MacOS),
# add this to your shell's config file (.bashrc, .bash_profile, etc.):
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

The project IDs of our development database is `afk-credits-112d2`, our production database has the id `afk-credits-prod` (afk-credits is a legacy name). 
Now we can generate the necessary firebase configuration file with flutterfire
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
To run the prod environment (use with caution) switch the firebase project and run
```bash
flutter run --flavor prod -t lib/main_prod.dart --debug
```
Note that some warnings are currently expected when building the app.
For iOS, it is recommended to run in `--release` mode, because otherwise the app cannot be used on the phone standalone. 

## IDE Setup Notes

Just listing items specific to this project here.

### Visual Studio Code
For convenience, different modes (flavors) are configured in `.vscode/launch.json`.

### Jetbrains (IntelliJ IDEA)
For convenience, different modes (flavors) are configured in `.iml` files inside `.intellij/.run`

**TODO: Prod Flavor**

#### Optimize Imports and 'dart format'
TODO: Find a way to exclude these in the future or customize this functionality for our project

These locations were reverted since the emitted changes were messy:
* `functions/` - Javascript code
* `insideout_ui/lib/insideout_ui.dart` - Export commands are interleaved with comments which gets mangled
* `lib/app/app.locator.dart` - Comments re: generated code get deleted

## Troubleshooting
### iOS
- When building iOS, and error might appear saying `error: Unexpected duplicate tasks`. To solve it, delete the `GoogleService-Info.plist` file from the Compile Sources of the Build Phases of your target in xcode. See [here](https://stackoverflow.com/questions/73653470/error-xcode-unexpected-duplicate-tasks-target-runner-has-copy-command-from).

# Developer Wiki
## Framework / state management
- We use the stacked framework. It is one of the cleanest and most scalable solutions out there. (Find an introduction video [here](https://www.youtube.com/watch?v=hEy_36LPcgQ&ab_channel=FilledStacks))
- We also have a youtube search tool available, to pull up relevant FilledStacks video snippets with great explanations on various concepts: https://huggingface.co/spaces/bejaeger/filled-stacks-search (try for example: 'How does stacked work?'). Note that some details in the videos are outdated, the general concepts are, however, still very relevant.

## File structure
- Our structure is adopted from the recommendations from the stacked framework
- In addition, we use a separate package for standard UI elements. It is found under the `insideout_ui/` directory. 

## Coding Guidelines
- Generally, we follow the guidelines from the stacked framework. 
- Please use the logger and print information about the code including an appropriate logger level (Tip: when running the app, filter for `flutter` in the debug console to only get our logger outputs)
- Please try to write self-documenting code and only add comments when it is really necessary to understand the logic or to explain the reason behind a code snippet that otherwise might be forgotten.

## Code Generation
- We use the `StackedGenerator` to generate the code for our locator (dependency injection) as well as the necessary router information. This happens in `lib/app/app.dart`.
- We use [freezed](https://pub.dev/packages/freezed) and [json_serializable](https://pub.dev/packages/json_serializable) to generate the code for our datamodels.
- Run `source runCodeGen.sh` to generate all required snippets.
- `watchCodeGen.sh` can be used to continuously update all generated code whenever a file changes.

## Collaboration / version control
- We follow a [feature branch workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow). In short: For any change to the app:
  1. create a new branch
  2. create a PR and ask for review
  3. revise the code if necessary
  4. ask it to be merged to master whenever it is considered ready

# Information about status of code

## Legacy naming
Some classes or packages still use legacy names. This is a list of terms that are used interchangeably:
- 'Payment' = 'Money Transfer' = 'Credit Transfer'
- 'AFK(Credits)' = 'Hercules(Credits)' = 'InsideOut(Credits)' = 'Credits'
- Also in the project settings/names 'afkcredits' or 'hercules' may still be used instead of 'insideout' or 'insideoutadventure'

