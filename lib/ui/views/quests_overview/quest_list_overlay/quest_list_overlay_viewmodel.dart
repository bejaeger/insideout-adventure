import 'dart:async';

import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:stacked/stacked.dart';

// TODO: Clean up QuestsOverviewViewModel
class QuestListOverlayViewModel extends QuestsOverviewViewModel {
  StreamSubscription? subscription;

  void listenToLayout() {
    if (subscription == null) {
      subscription = layoutService.isShowingQuestListSubject.listen((show) {
        notifyListeners();
      });
    } else {
      log.wtf("isShowingQuestListSubject already listened to");
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
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
