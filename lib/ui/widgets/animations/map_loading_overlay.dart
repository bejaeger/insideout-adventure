import 'package:afkcredits/ui/widgets/fading_widget.dart';
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
              loadingQuests && !show
                  ? AfkCreditsText.subheading("Loading Quests...")
                  : AfkCreditsText.subheading("Loading Map..."),
            ],
          ),
        ),
      ),
    );
  }
}
