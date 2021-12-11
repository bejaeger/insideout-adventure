import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/common_viewmodels/activated_quest_panel_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActivatedQuestPanel extends StatelessWidget {
  final double height;

  const ActivatedQuestPanel({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActivatedQuestPanelViewModel>.reactive(
      //onModelReady: (model) => model.setTimer(),
      viewModelBuilder: () => ActivatedQuestPanelViewModel(),
      builder: (context, model, child) => AnimatedContainer(
        height: model.hasActiveQuest ? height + kActiveQuestPanelHeight : 0,
        decoration: BoxDecoration(
          color: kColorActivatedQuest,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black26,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0)),
        ),
        duration: Duration(seconds: 1),
        //clipBehavior: Clip.none,
        width: screenWidth(context),
        child: !model.hasActiveQuest
            ? SizedBox(height: 0, width: 0)
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height),
                  Expanded(
                    child: GestureDetector(
                      onTap: model.navigateToRelevantActiveQuestView,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      horizontalSpaceMedium,
                                      Icon(Icons.explore,
                                          color: Colors.grey[50]),
                                      horizontalSpaceTiny,
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ActiveQuestInfoTex(
                                                text: model
                                                    .lastActivatedQuestInfoText),
                                            if (model.gpsAccuracyInfo != null)
                                              Text(model.gpsAccuracyInfo!,
                                                  style: TextStyle(
                                                      color: kWhiteTextColor))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      model.isBusy
                                          ? CircularProgressIndicator(
                                              color: Colors.white)
                                          : SmallButton(
                                              title: "Finish Quest",
                                              onPressed: model.isBusy
                                                  ? () => null
                                                  : () async => await model
                                                      .checkQuestAndFinishWhenCompleted()),
                                      // horizontalSpaceMedium,
                                      // SmallButton(
                                      //     title: "Complete Quest",
                                      //     onPressed: model.finishQuest),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ActiveQuestInfoTex extends StatelessWidget {
  final String text;
  const ActiveQuestInfoTex({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: textTheme(context)
            .bodyText1!
            .copyWith(color: Colors.grey[50], fontSize: 16));
  }
}

class SmallButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const SmallButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 1, blurRadius: 1, color: Colors.black12)
            ],
            border: Border.all(style: BorderStyle.solid, color: Colors.white30),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: kColorActivatedQuest.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Text(title,
              style: TextStyle(color: Colors.grey[50], fontSize: 16))),
    );
  }
}
