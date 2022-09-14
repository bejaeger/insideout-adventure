import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/ui/views/map/bottomsheet/raise_quest_bottom_sheet_view.dart';
import 'package:afkcredits/ui/views/parent_home/bottom_sheet/switch_area_bottom_sheet_view.dart';
import 'package:stacked_services/stacked_services.dart';

void setupBottomSheetUi() {
  final BottomSheetService? _bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.questInformation: (context, request, completer) =>
        RaiseQuestBottomSheetView(request: request, completer: completer),
    BottomSheetType.switchArea: (context, request, completer) =>
        SwitchAreaBottomSheetView(request: request, completer: completer),
  };
  _bottomSheetService!.setCustomSheetBuilders(builders);
}
