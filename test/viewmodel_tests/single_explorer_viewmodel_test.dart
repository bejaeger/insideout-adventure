import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/ui/views/single_explorer/single_explorer_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.dart';
import '../test_data/test_constants.dart';


SingleExplorerViewModel _getModel() => SingleExplorerViewModel(explorerUid: kTestUid);

void main() {
 group('SingleExplorerViewmodelTest -', (){
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

   group('switchToExplorerAccount -', () {

    test('When user selects to set pin navigate to select PIN view', () async {

      // arrange
      final bottomSheetService = getAndRegisterBottomSheetService(confirmed: true);
      final navigationService = getAndRegisterNavigationService();
      final model = _getModel();
      // act
      await model.handleSwitchToExplorerEvent();
      // assert
      verify(navigationService.navigateTo(Routes.setPinView));
    });

    test('When user selects to set pin navigate to select PIN view', () async {

      // arrange
      final bottomSheetService = getAndRegisterBottomSheetService(confirmed: true);
      final navigationService = getAndRegisterNavigationService();
      final model = _getModel();
      // act
      await model.handleSwitchToExplorerEvent();
      // assert
      verify(navigationService.navigateTo(Routes.setPinView));
    });


   });

 });
}