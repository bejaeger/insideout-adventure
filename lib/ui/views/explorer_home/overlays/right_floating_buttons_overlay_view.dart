import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/right_floating_buttons_overlay_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RightFloatingButtonsView extends StatelessWidget {
  final void Function() onZoomPressed;

  // !!! Temporary
  final void Function()? onChangeCharacterTap;

  const RightFloatingButtonsView({
    Key? key,
    //required this.bearing,
    required this.onZoomPressed,
    this.onChangeCharacterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RightFloatingButtonsOverlayViewModel>.reactive(
      viewModelBuilder: () => RightFloatingButtonsOverlayViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        // print("-->> rebuild floating buttons");
        return Stack(
          children: [
            if (onChangeCharacterTap != null)
              Align(
                alignment: Alignment(-1, 0.65),
                child: Container(
                  color: Colors.grey[200]!.withOpacity(0.3),
                  width: 55,
                  height: 55,
                  child: GestureDetector(onTap: onChangeCharacterTap!),
                ),
              ),
            Align(
              alignment: Alignment(1, -0.35),
              child: Padding(
                //color: Colors.red,
                padding: const EdgeInsets.only(
                    right: 15, bottom: 8.0, top: 8.0, left: 8.0),
                child: AnimatedOpacity(
                  opacity: (model.bearing > 5 || model.bearing < -5) ? 1 : 1,
                  duration: Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: model.rotateToNorth, //onCompassTap,
                    child: Transform.rotate(
                      angle: model.angle,
                      child: Image.asset(
                        kCompassIcon,
                        height: 38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IgnorePointer(
                ignoring: model.hasActiveQuest,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: (model.isShowingQuestDetails || model.hasActiveQuest)
                      ? 0
                      : 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 120,
                      right: 10,
                    ),
                    child: GestureDetector(
                      onTap:
                          (model.isShowingQuestDetails || model.hasActiveQuest)
                              ? null
                              : onZoomPressed,
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: kcShadowColor,
                                  //offset: Offset(1, 1),
                                  blurRadius: 0.5,
                                  spreadRadius: 0.2)
                            ],
                            border: Border.all(
                                color: Colors.grey[800]!, width: 2.0),
                            borderRadius: BorderRadius.circular(90.0),
                            color: Colors.white.withOpacity(0.9)),
                        alignment: Alignment.center,
                        child: model.isAvatarView == true
                            ? Icon(Icons.my_location_rounded)
                            : Icon(Icons.location_searching),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
