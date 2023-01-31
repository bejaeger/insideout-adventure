import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/custom_dialogs/child_stat_card/child_total_stats_card_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/collect_credits/collect_credits_dialog_view.dart';
import 'package:afkcredits/ui/custom_dialogs/credit_conversion_info_dialog.dart/credit_conversion_info_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/explorer_settings/explorer_settings_dialog_view.dart';
import 'package:afkcredits/ui/custom_dialogs/explorer_settings_for_parents/explorer_settings_for_parents_view.dart';
import 'package:afkcredits/ui/custom_dialogs/found_treasure/found_treasure_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/in_area_alert/in_area_alert_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/marker_collected/collected_marker_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/super_user_dialog/super_user_dialog_view.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/custom_screen_time_dialog_view.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/money_transfer_dialog_view.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/beware_of_surroundings_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/number_quests_founds_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/onboarding_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/select_avatar_dialog_view.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();
  final builders = {
    DialogType.MoneyTransfer: (context, sheetRequest, completer) =>
        MoneyTransferDialogView(request: sheetRequest, completer: completer),
    DialogType.CollectCredits: (context, sheetRequest, completer) =>
        CollectCreditsDialogView(request: sheetRequest, completer: completer),
    DialogType.CollectedMarker: (context, sheetRequest, completer) =>
        CollectedMarkerDialog(request: sheetRequest, completer: completer),
    DialogType.FoundTreasure: (context, sheetRequest, completer) =>
        FoundTreasureDialog(request: sheetRequest, completer: completer),
    DialogType.SuperUserSettings: (context, sheetRequest, completer) =>
        SuperUserDialogView(request: sheetRequest, completer: completer),
    DialogType.QrCodeInArea: (context, sheetRequest, completer) =>
        InAreaAlertDialogView(
            request: sheetRequest, completer: completer, isQrCodeInArea: true),
    DialogType.CheckpointInArea: (context, sheetRequest, completer) =>
        InAreaAlertDialogView(
            request: sheetRequest, completer: completer, isQrCodeInArea: false),
    DialogType.ChildStatCard: (context, sheetRequest, completer) =>
        ChildTotalStatsCardDialog(request: sheetRequest, completer: completer),
    DialogType.CreditConversionInfo: (context, sheetRequest, completer) =>
        CreditConversionInfoDialog(request: sheetRequest, completer: completer),
    DialogType.OnboardingDialog: (context, sheetRequest, completer) =>
        OnboardingDialog(request: sheetRequest, completer: completer),
    DialogType.BewareOfSurroundings: (context, sheetRequest, completer) =>
        BewareOfSurroundingsDialog(request: sheetRequest, completer: completer),
    DialogType.CustomScreenTime: (context, sheetRequest, completer) =>
        CustomScreenTimeDialogView(request: sheetRequest, completer: completer),
    DialogType.NumberQuests: (context, sheetRequest, completer) =>
        NumberQuestsFoundDialog(request: sheetRequest, completer: completer),
    DialogType.AvatarSelectDialog: (context, sheetRequest, completer) =>
        SelectAvatarDialogView(request: sheetRequest, completer: completer),
    DialogType.ExplorerSettings: (context, sheetRequest, completer) =>
        ExplorerSettingsDialogView(request: sheetRequest, completer: completer),
    DialogType.ExplorerSettingsForParents: (context, sheetRequest, completer) =>
        ExplorerSettingsForParentsDialogView(request: sheetRequest, completer: completer),
  };
  dialogService.registerCustomDialogBuilders(builders);
}
