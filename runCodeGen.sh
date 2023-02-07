flutter pub run build_runner build --delete-conflicting-outputs

# !!! This is needed because the stacked generator prepends a MapViewModel to the class
# !!! specified in the presolveUsing function in app.dart
sed -i '' -e 's/MapViewModel.presolveMapViewModel/presolveMapViewModel/g' lib/app/app.locator.dart
echo -e "import 'package:afkcredits/services/maps/google_map_service.dart';\n$(cat lib/app/app.locator.dart)" > lib/app/app.locator.dart
