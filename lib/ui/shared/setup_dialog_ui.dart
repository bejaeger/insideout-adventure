import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/money_transfer_dialog_view.dart';
import 'package:afkcredits/ui/views/giftcards/dialog/raised_purchased_dialogview.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();
  final builders = {
    DialogType.MoneyTransfer: (context, sheetRequest, completer) =>
        MoneyTransferDialogView(request: sheetRequest, completer: completer),
    DialogType.purchaseGiftCards: (context, sheetRequest, completer) =>
        RaisedPurchasedDialogView(request: sheetRequest, completer: completer),
    // DialogType.Onboarding: (context, sheetRequest, completer) =>
    //     OnboardingDialogView(request: sheetRequest, completer: completer),
  };
  dialogService.registerCustomDialogBuilders(builders);
}
