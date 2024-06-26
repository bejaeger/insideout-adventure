import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/custom_dialogs/collect_credits/collect_credits_dialog_view.dart';
import 'package:afkcredits/ui/custom_dialogs/credits_conversion_info_dialog.dart/credits_conversion_info_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/found_treasure/found_treasure_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/in_area_alert/in_area_alert_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/marker_collected/collected_marker_dialog.dart';
import 'package:afkcredits/ui/custom_dialogs/super_user_dialog/super_user_dialog_view.dart';
import 'package:afkcredits/ui/custom_dialogs/ward_settings/ward_settings_dialog_view.dart';
import 'package:afkcredits/ui/custom_dialogs/ward_settings_for_guardian/ward_settings_for_guardian_view.dart';
import 'package:afkcredits/ui/custom_dialogs/ward_stat_card/ward_total_stats_card_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/beware_of_surroundings_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/custom_screen_time_dialog_view.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/number_quests_founds_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/onboarding_dialog.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/select_avatar_dialog_view.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/transfer_dialog_view.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();
  final builders = {
    DialogType.Transfer: (context, sheetRequest, completer) =>
        TransferDialogView(request: sheetRequest, completer: completer),
    DialogType.CollectCredits: (context, sheetRequest, completer) =>
        CollectCreditsDialogView(request: sheetRequest, completer: completer),
    DialogType.CollectedMarker: (context, sheetRequest, completer) =>
        CollectedMarkerDialog(request: sheetRequest, completer: completer),
    DialogType.FoundTreasure: (context, sheetRequest, completer) =>
        FoundTreasureDialog(request: sheetRequest, completer: completer),
    DialogType.SuperUserSettings: (context, sheetRequest, completer) =>
        SuperUserDialogView(request: sheetRequest, completer: completer),
    DialogType.CheckpointInArea: (context, sheetRequest, completer) =>
        InAreaAlertDialogView(
            request: sheetRequest, completer: completer, isQrCodeInArea: false),
    DialogType.WardStatCard: (context, sheetRequest, completer) =>
        WardTotalStatsCardDialog(request: sheetRequest, completer: completer),
    DialogType.CreditsConversionInfo: (context, sheetRequest, completer) =>
        CreditsConversionInfoDialog(
            request: sheetRequest, completer: completer),
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
    DialogType.WardSettings: (context, sheetRequest, completer) =>
        WardSettingsDialogView(request: sheetRequest, completer: completer),
    DialogType.WardSettingsForGuardian: (context, sheetRequest, completer) =>
        WardSettingsForGuardianDialogView(
            request: sheetRequest, completer: completer),
  };
  dialogService.registerCustomDialogBuilders(builders);
}
