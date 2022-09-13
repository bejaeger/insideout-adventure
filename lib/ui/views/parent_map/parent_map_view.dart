import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/ui/views/map/google_map_screen.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/parent_map/parent_map_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/animations/map_loading_overlay.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/quest_reload_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ParentMapView extends StatelessWidget {
  const ParentMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParentMapViewModel>.reactive(
      viewModelBuilder: () => ParentMapViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              title: "Quests",
              onBackButton: model.popView,
            ),
            floatingActionButton: AFKFloatingActionButton(
              icon: Icon(Icons.add, size: 32, color: Colors.white),
              onPressed: model.navToCreateQuest,
            ),
            body: Stack(
              children: [
                // bottom layer
                //if (!model.isBusy)
                model.isBusy
                    ? MapLoadingOverlay(show: true)
                    : GoogleMapScreen(
                        model: locator<MapViewModel>(),
                        callback: () => model.notifyListeners(),
                      ),
                ReloadQuestsButton(
                  show: model.showReloadQuestButton,
                  onPressed: model.loadNewQuests,
                  isBusy: model.isReloadingQuests,
                ),
                if (model.isDeletingQuest)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: AFKProgressIndicator(
                      alignment: Alignment.bottomCenter,
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
