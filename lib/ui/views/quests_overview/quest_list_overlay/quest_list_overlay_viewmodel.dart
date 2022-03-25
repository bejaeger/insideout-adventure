import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:stacked/stacked.dart';

// TODO: Clean up QuestsOverviewViewModel
class QuestListOverlayViewModel extends QuestsOverviewViewModel {
  void listenToLayout() {
    layoutService.isShowingQuestListSubject.listen((show) {
      notifyListeners();
    });
  }

  // TODO: Still explore whether this approach is better
  // //------------------------------------------------------------
  // // Reactive Service Mixin Functionality from stacked ReactiveViewModel!
  // late List<ReactiveServiceMixin> _reactiveServices;
  // QuestListOverlayViewModel() {
  //   _reactToServices(reactiveServices);
  // }
  // List<ReactiveServiceMixin> get reactiveServices =>
  //     [layoutService]; // _reactiveServices;
  // void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
  //   _reactiveServices = reactiveServices;
  //   for (var reactiveService in _reactiveServices) {
  //     reactiveService.addListener(_indicateChange);
  //   }
  // }

  // void _indicateChange() {
  //   notifyListeners();
  // }
}
