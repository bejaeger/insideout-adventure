import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/ui/views/map/avatar_and_effects_on_map_viewmodel.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class AvatarAndEffectsOnMapView extends StatefulWidget {
  final int avatarIdx;
  const AvatarAndEffectsOnMapView({
    Key? key,
    required this.avatarIdx,
  }) : super(key: key);

  @override
  State<AvatarAndEffectsOnMapView> createState() =>
      _AvatarAndEffectsOnMapViewState();
}

class _AvatarAndEffectsOnMapViewState extends State<AvatarAndEffectsOnMapView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _controllerRipple;
  @override
  void initState() {
    super.initState();
    // durations will be overwritten
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controllerRipple =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerRipple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AvatarAndEffectsOnMapViewModel>.reactive(
      viewModelBuilder: () => AvatarAndEffectsOnMapViewModel(stopAnimation: () {
        _controller.stop();
        _controllerRipple.stop();
      }, startAnimation: () {
        _controller.repeat();
        _controllerRipple.repeat();
      }),
      onModelReady: (model) {
        model.listenToData();
      },
      builder: (context, model, child) {
        return Stack(
          children: [
            // ripple effect when treasure location search is active!
            if (model.activeQuestNullable?.quest.type ==
                    QuestType.TreasureLocationSearch &&
                model.activeQuestNullable?.status != QuestStatus.success)
              Positioned(
                //alignment: Alignment(0, 0.4),
                bottom: 105,
                left: 2,
                right: 2,
                child: IgnorePointer(
                  child: Lottie.asset(
                    kLottieRippleEffect,
                    controller: _controllerRipple,
                    height: 200,
                    width: 200,
                    onLoaded: (composition) {
                      // Configure the AnimationController with the duration of the
                      // Lottie file and start the animation.
                      _controllerRipple
                        ..duration = composition.duration
                        ..repeat();
                    },
                  ),
                ),
              ),
            Positioned(
              //alignment: Alignment(0, 0.4),
              bottom: widget.avatarIdx == 1
                  ? screenHeight(context, percentage: 0.27)
                  : screenHeight(context, percentage: 0.25),
              left: 2,
              right: 2,
              child: FadingWidget(
                show: model.showAvatar,
                ignorePointer: true,
                child: Container(
                    height: screenHeight(context,
                        percentage: widget.avatarIdx == 1 ? 0.22 : 0.24),
                    child: Lottie.asset(
                      widget.avatarIdx == 1
                          ? kLottieChillDude
                          : kLottieWalkingGirl,
                      //frameRate: FrameRate.max,
                      controller: _controller,
                      onLoaded: (composition) {
                        // Configure the AnimationController with the duration of the
                        // Lottie file and start the animation.
                        _controller
                          ..duration = composition.duration
                          ..repeat();
                      },
                    )),
              ),
            ),
          ],
        );
      },
    );
  }
}
