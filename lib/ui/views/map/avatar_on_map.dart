import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:flutter/material.dart';
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
      bottom: 185,
      left: 2,
      right: 2,
      child: FadingWidget(
        show: show,
        ignorePointer: true,
        child: characterNumber == 0
            ? Lottie.network(
                // chilling dude
                'https://assets2.lottiefiles.com/packages/lf20_0w4fvbov.json',
                height: 150,
                width: 150,
              )
            : characterNumber == 1
                ?
                // Left!
                Lottie.network(
// walking normal girl
                    'https://assets6.lottiefiles.com/private_files/lf30_afru6l2d.json',
                    height: 165,
                    width: 165,
                  )
                : characterNumber == 2
                    ? Lottie.network(
                        // stick figure running to the right
                        // Stick figure does not work from notion as link changes
                        'https://assets6.lottiefiles.com/private_files/lf30_afru6l2d.json',
                        // 'https://s3.us-west-2.amazonaws.com/secure.notion-static.com/aa05bafe-251b-414e-80c6-a13c67abc438/lf30_editor_als8jeb9.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220328%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220328T011103Z&X-Amz-Expires=86400&X-Amz-Signature=d31cc104bb17397362cb996cd5671ce304385bbf282626b8cdf47e21d5e97e99&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22lf30_editor_als8jeb9.json%22&x-id=GetObject',
                        height: 150,
                        width: 150,
                      )
                    : characterNumber == 3
                        ? Lottie.network(
                            // dude walking to the right
                            'https://assets3.lottiefiles.com/packages/lf20_4jip3mqj.json',

                            height: 160,
                            width: 160,
                          )
                        : characterNumber == 4
                            ? Lottie.network(
                                // colored stick figure walking to the left
                                'https://assets3.lottiefiles.com/packages/lf20_tbbtmun4.json',
                                height: 165,
                                width: 165,
                              )
                            : Lottie.network(
                                // weird figure walking to the right
                                'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/walking.json',
                                height: 150,
                                width: 150,
                              ),
      ),
    );
  }
}
