import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/select_avatar_dialog_viewmodel.dart';
import 'package:afkcredits/ui/widgets/selectable_box.dart';
import 'package:insideout_ui/insideout_ui.dart';
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
                    InsideOutText.headingThree(
                        'Hi ${model.currentUser.fullName}!'),
                    verticalSpaceSmall,
                    InsideOutText.body('Choose your favorite avatar'),
                    verticalSpaceLarge,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: SelectableBox(
                            height: 80,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            selected: model.selectedCharacter == 1,
                            onTap: () => model.selectCharacter(1),
                            child: Image.asset(kLottieChillDudeHeadPng,
                                height: 50),
                          ),
                        ),
                        Expanded(
                          child: SelectableBox(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            height: 80,
                            selected: model.selectedCharacter == 2,
                            onTap: () => model.selectCharacter(2),
                            child:
                                Image.asset(kLottieWalkingGirlPng, height: 50),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    Stack(
                      children: [
                        Align(
                          // top: 10,
                          // bottom: 10,
                          // left: 10,
                          // right: 10,
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              SizedBox(height: 130),
                              Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  //shape: BoxShape.circle,
                                  borderRadius: BorderRadius.all(
                                    Radius.elliptical(50, 30),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kcShadowColor,
                                      spreadRadius: 0.4,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 180,
                          //height: screenHeight(context, percentage: 0.2),
                          //color: Colors.red,
                          alignment: Alignment.center,
                          child: Container(
                            //color: Colors.green,
                            constraints: BoxConstraints(
                                maxHeight:
                                    model.selectedCharacter == 1 ? 150 : 180),
                            child: Lottie.asset(
                              model.selectedCharacter == 1
                                  ? kLottieChillDude
                                  : model.selectedCharacter == 2
                                      ? kLottieWalkingGirl
                                      : model.selectedCharacter == 3
                                          ? kLottieWalkingBoy
                                          : kLottieColoredSportsFigure,
                            ),
                          ),
                        ),
                      ],
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
                          InsideOutButton(
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
