import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked/stacked.dart';

class MainFooterViewModel extends BaseModel with NavigationMixin {
  // state variables
  bool isMenuOpen = false;

  // TODO: Maybe make this a reactive value!
  void listenToLayout() {
    layoutService.isShowingQuestListSubject.listen((show) {
      notifyListeners();
    });
  }

  // //------------------------------------------------------------
  // // Reactive Service Mixin Functionality from stacked ReactiveViewModel!
  // late List<ReactiveServiceMixin> _reactiveServices;
  // MainFooterViewModel() {
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
