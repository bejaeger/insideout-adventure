import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/common_viewmodels/activated_quest_panel_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActivatedQuestPanel extends StatelessWidget {
  final double heightAppBar;

  const ActivatedQuestPanel({Key? key, required this.heightAppBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActivatedQuestPanelViewModel>.reactive(
      //onModelReady: (model) => model.setTimer(),
      viewModelBuilder: () => ActivatedQuestPanelViewModel(),
      builder: (context, model, child) => AnimatedContainer(
        height: model.hasActiveQuest
            ? model.expanded
                ? heightAppBar + kActiveQuestPanelMaxHeight
                : heightAppBar + kActiveQuestMinSize
            : 0,
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
            : Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kHorizontalPadding, vertical: 8.0),
                child: GestureDetector(
                  onTap: model.navigateToRelevantActiveQuestView,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: heightAppBar),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Icon(Icons.explore, color: Colors.grey[50]),
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
                                          if (model.gpsAccuracyInfo != null &&
                                              (model.useSuperUserFeatures ||
                                                  model.isDevFlavor))
                                            Text(model.gpsAccuracyInfo!,
                                                style: TextStyle(
                                                    color: kWhiteTextColor,
                                                    fontSize: 12))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              model.isBusy
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Column(
                                      children: [
                                        SmallButton(
                                            title: "Finish",
                                            withShadow: model.expanded,
                                            onPressed: model.isBusy
                                                ? () => null
                                                : () async => await model
                                                    .cancelOrFinishQuest()),
                                      ],
                                    ),
                            ],
                          ),
                          // AnimatedContainer(
                          //   duration: Duration(seconds: 1),
                          //   height: model.expanded
                          //       ? kActiveQuestPanelMaxHeight -
                          //           kActiveQuestMinSize -
                          //           20
                          //       : 0,
                          //   child: model.isBusy
                          //       ? CircularProgressIndicator(color: Colors.white)
                          //       : Column(
                          //           children: [
                          //             SmallButton(
                          //                 title: "Finish Quest",
                          //                 withShadow: model.expanded,
                          //                 onPressed: model.isBusy
                          //                     ? () => null
                          //                     : () async => await model
                          //                         .checkQuestAndFinishWhenCompleted()),
                          //           ],
                          //         ),
                          // ),
                          // GestureDetector(
                          //   // onTap: model.navigateToRelevantActiveQuestView,
                          //   onTap: model.toggleExpanded,
                          //   // child: widget(
                          //   child: Container(
                          //     color: Colors.green,
                          //     width: screenWidth(context),
                          //     child: Column(
                          //       children: [
                          //         Flexible(
                          //           child: model.expanded
                          //               ? Icon(Icons.arrow_drop_up,
                          //                   size: 32, color: Colors.white)
                          //               : Icon(Icons.arrow_drop_down,
                          //                   size: 32, color: Colors.white),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
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
  final bool withShadow;

  const SmallButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.withShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: withShadow
                ? [
                    BoxShadow(
                        spreadRadius: 1, blurRadius: 1, color: Colors.black12)
                  ]
                : [],
            border: Border.all(style: BorderStyle.solid, color: Colors.white30),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: kColorActivatedQuest.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[50], fontSize: 16))),
    );
  }
}

