import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SponsorHomeView),
    MaterialRoute(page: ExplorerHomeView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),

    // Services
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
