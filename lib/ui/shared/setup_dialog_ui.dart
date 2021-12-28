import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/custom_dialogs/collect_credits/collect_credits_dialog_view.dart';
import 'package:afkcredits/ui/custom_dialogs/found_treasure/found_treasure_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/marker_collected/collected_marker_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/money_transfer_dialog_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/dialog/travelled_distance_dialog_view.dart';
import 'package:afkcredits/ui/views/gift_cards/dialog/raised_purchased_dialogview.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();
  final builders = {
    DialogType.MoneyTransfer: (context, sheetRequest, completer) =>
        MoneyTransferDialogView(request: sheetRequest, completer: completer),
    DialogType.PurchaseGiftCards: (context, sheetRequest, completer) =>
        RaisedPurchasedDialogView(request: sheetRequest, completer: completer),
    DialogType.CollectCredits: (context, sheetRequest, completer) =>
        CollectCreditsDialogView(request: sheetRequest, completer: completer),
    DialogType.CollectedMarker: (context, sheetRequest, completer) =>
        CollectedMarkerDialog(request: sheetRequest, completer: completer),
    DialogType.CheckTravelledDistance: (context, sheetRequest, completer) =>
        TravelledDistanceDialogView(
            request: sheetRequest, completer: completer),
    DialogType.FoundTreasure: (context, sheetRequest, completer) =>
        FoundTreasureDialog(
            request: sheetRequest, completer: completer),
    // DialogType.Onboarding: (context, sheetRequest, completer) =>
    //     OnboardingDialogView(request: sheetRequest, completer: completer),
  };
  dialogService.registerCustomDialogBuilders(builders);
}
