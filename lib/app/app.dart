import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/map/map_view.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SponsorHomeView),
    MaterialRoute(page: ExplorerHomeView),
    MaterialRoute(page: MapView, initial: true),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),

    // Services
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
