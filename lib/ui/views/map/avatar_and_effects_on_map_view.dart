import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/ui/views/map/avatar_and_effects_on_map_viewmodel.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:stacked/stacked.dart';

class AvatarAndEffectsOnMapView extends StatefulWidget {
  const AvatarAndEffectsOnMapView({
    Key? key,
  }) : super(key: key);

  @override
  State<AvatarAndEffectsOnMapView> createState() =>
      _AvatarAndEffectsOnMapViewState();
}

class _AvatarAndEffectsOnMapViewState extends State<AvatarAndEffectsOnMapView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AvatarAndEffectsOnMapViewModel>.reactive(
      viewModelBuilder: () => AvatarAndEffectsOnMapViewModel(
        stopAnimation: () => _controller.stop(),
        startAnimation: () => _controller.repeat(),
      ),
      onModelReady: (model) => model.listenToData(),
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
                    controller: _controller,
                    height: 200,
                    width: 200,
                    frameRate: FrameRate.max,
                  ),
                ),
              ),
            Positioned(
              //alignment: Alignment(0, 0.4),
              bottom: model.characterNumber == 3
                  ? 168
                  : model.characterNumber == 1
                      ? 175
                      : 190,
              left: 2,
              right: 2,
              child: FadingWidget(
                show: model.show,
                ignorePointer: true,
                child: Container(
                    height: screenHeight(context,
                        percentage: model.characterNumber == 0 ? 0.22 : 0.22),
                    child:
                        // Image.asset(
                        //   kLottieChillDudePng,
                        // ),
                        // characterNumber == 0
                        //     ?
                        Lottie.asset(
                      kLottieChillDude,
                      frameRate: FrameRate.max,
                      controller: _controller,
                      onLoaded: (composition) {
                        // Configure the AnimationController with the duration of the
                        // Lottie file and start the animation.
                        // TODO: Understand this line of code
                        _controller
                          ..duration = composition.duration
                          ..repeat();
                      },
                    )
                    //     // .network(
                    //     //     // chilling dude
                    //     //     'https://assets2.lottiefiles.com/packages/lf20_0w4fvbov.json',
                    //     //     fit: BoxFit.contain,
                    //     //   )
                    //     : characterNumber == 1
                    //         ?
                    //         // Left!
                    //         Lottie.asset(
                    //             kLottieWalkingGirl,
                    //             frameRate: FrameRate(0.01),
                    //           )
                    //         // walking normal girl
                    //         //'https://assets6.lottiefiles.com/private_files/lf30_afru6l2d.json',
                    //         //fit: BoxFit.contain,
                    //         //)
                    //         : characterNumber == 2
                    //             ? Lottie.asset(kLottieWalkingBoy)
                    //             // dude walking to the right
                    //             // 'https://assets3.lottiefiles.com/packages/lf20_4jip3mqj.json',
                    //             : Lottie.asset(
                    //                 // colored stick figure walking to the left
                    //                 kLottieColoredSportsFigure,
                    //               )
                    // characterNumber == 4
                    //     ? Lottie.network(
                    //         // colored stick figure walking to the left
                    //         'https://assets3.lottiefiles.com/packages/lf20_tbbtmun4.json',
                    //         fit: BoxFit.contain,
                    //       )
                    //     : Lottie.asset(kLottieTestV1),
                    ),

                // Lottie.network(
                //     // weird figure walking to the right
                //     //'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/walking.json',
                //     height: 200,
                //     width: 180,
                //   ),
              ),
            ),
          ],
        );
      },
    );
  }
}
