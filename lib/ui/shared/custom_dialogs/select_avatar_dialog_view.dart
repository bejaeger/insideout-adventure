import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/select_avatar_dialog_viewmodel.dart';
import 'package:afkcredits/ui/widgets/selectable_box.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

class SelectAvatarDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const SelectAvatarDialogView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectAvatarViewModel>.reactive(
      viewModelBuilder: () => SelectAvatarViewModel(),
      builder: (context, model, child) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth(context, percentage: 0.04),
              ),
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpaceSmall,
                    AfkCreditsText.headingThree(
                        'Hi ${model.currentUser.fullName}!'),
                    verticalSpaceSmall,
                    AfkCreditsText.body('Choose your favorite avatar'),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SelectableBox(
                          selected: model.selectedCharacter == 1,
                          onTap: () => model.selectCharacter(1),
                          child:
                              Image.asset(kLottieChillDudeHeadPng, height: 50),
                        ),
                        SelectableBox(
                          selected: model.selectedCharacter == 2,
                          onTap: () => model.selectCharacter(2),
                          child: Lottie.asset(
                            kLottieWalkingGirl,
                            height: 50,
                            frameRate: FrameRate(10),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SelectableBox(
                          selected: model.selectedCharacter == 3,
                          onTap: () => model.selectCharacter(3),
                          child: Lottie.asset(
                            kLottieWalkingBoy,
                            height: 50,
                            frameRate: FrameRate(10),
                          ),
                        ),
                        SelectableBox(
                          selected: model.selectedCharacter == 4,
                          onTap: () => model.selectCharacter(4),
                          child: Lottie.asset(
                            kLottieColoredSportsFigure,
                            height: 50,
                            frameRate: FrameRate(10),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    Lottie.asset(
                      model.selectedCharacter == 1
                          ? kLottieChillDude
                          : model.selectedCharacter == 2
                              ? kLottieWalkingGirl
                              : model.selectedCharacter == 3
                                  ? kLottieWalkingBoy
                                  : kLottieColoredSportsFigure,
                      height: 120,
                    ),
                    verticalSpaceMedium,
                    TextButton(
                      onPressed: () => completer(
                        DialogResponse(
                            confirmed: true, data: model.selectedCharacter),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AfkCreditsButton(
                            title: 'Choose avatar',
                            // trailing: Icon(Icons.arrow_forward,
                            //     size: 20, color: Colors.white),
                            width: 180,
                            height: 45,
                          ),
                          // horizontalSpaceTiny,
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 4),
                          //   child: Icon(Icons.arrow_forward,
                          //       size: 20, color: kcPrimaryColor),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -45,
              child: CircleAvatar(
                  minRadius: 16,
                  maxRadius: 38,
                  backgroundColor: kcPrimaryColor,
                  child: Image.asset(kHerculesWorldLogo, height: 45)
                  // Icon(
                  //   Icons.favorite,
                  //   size: 28,
                  //   color: Colors.white,
                  // ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}