import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class ReloadQuestsButton extends StatelessWidget {
  final void Function() onPressed;
  final bool isBusy;
  final bool show;
  const ReloadQuestsButton(
      {Key? key,
      required this.onPressed,
      required this.show,
      required this.isBusy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadingWidget(
      show: show,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IgnorePointer(
            child: SizedBox(
                height: screenHeight(context) - kAppBarExtendedHeight - 100),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 0,
                ),
                child: Container(
                  width: 190,
                  height: 50,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: kcGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kcShadowColor,
                        spreadRadius: 0.5,
                        blurRadius: 0.3,
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                  child: isBusy
                      ? AFKProgressIndicator(
                          alignment: Alignment.center,
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_outlined, color: Colors.white),
                            horizontalSpaceSmall,
                            Expanded(
                              child: AfkCreditsText(
                                text: "Load new quests",
                                style: bodyStyleSofia.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
