import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class AvatarOnMap extends StatelessWidget {
  final int characterNumber;
  final bool show;
  const AvatarOnMap({
    this.characterNumber = 0,
    required this.show,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //alignment: Alignment(0, 0.4),
      bottom: characterNumber == 3
          ? 168
          : characterNumber == 1
              ? 175
              : 190,
      left: 2,
      right: 2,
      child: FadingWidget(
        show: show,
        ignorePointer: true,
        child: Container(
          height: screenHeight(context,
              percentage: characterNumber == 0 ? 0.22 : 0.22),
          child: Image.asset(
            kLottieChillDudePng,
          ),
          // characterNumber == 0
          //     ? Lottie.asset(kLottieChillDude, frameRate: FrameRate.max)
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
    );
  }
}
