import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits/ui/widgets/hercules_world_logo.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class MapLoadingOverlay extends StatelessWidget {
  final bool show;
  final bool loadingQuests;
  const MapLoadingOverlay(
      {Key? key, required this.show, required this.loadingQuests})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadingWidget(
      show: show || loadingQuests,
      //duration: Duration(milliseconds: 500),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: loadingQuests && !show ? 200 : null,
          height: loadingQuests && !show ? 120 : null,
          decoration: BoxDecoration(
            boxShadow: loadingQuests && !show
                ? [
                    BoxShadow(
                        blurRadius: 0.4,
                        spreadRadius: 0.3,
                        offset: Offset(1, 1),
                        color: kcShadowColor),
                  ]
                : [],
            borderRadius: BorderRadius.circular(15.0),
            color: kcCultured,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // HerculesWorldLogo(
              //   sizeScale: 1,
              // ),
              // verticalSpaceSmall,
              loadingQuests && !show
                  ? AfkCreditsText.subheading("Loading Quests...")
                  : AfkCreditsText.subheading("Loading Map..."),
              // AFKProgressIndicator(
              //     //color: kcOrange,
              //     )
            ],
          ),
        ),
      ),
    );
  }
}
