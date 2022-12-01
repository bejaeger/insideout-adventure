import 'package:afkcredits/ui/views/help_desk/help_desk_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HelpDeskView extends StatelessWidget {
  const HelpDeskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HelpDeskViewModel>.reactive(
      viewModelBuilder: () => HelpDeskViewModel(),
      onModelReady: (model) => model.getData(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: "Help Desk",
            onBackButton: model.popView,
          ),
          body: SingleChildScrollView(
            child: model.isBusy
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AFKProgressIndicator(),
                  )
                : model.faqs.answers.length == 0
                    ? Container(
                        padding: const EdgeInsets.all(20.0),
                        child: AfkCreditsText.subheading(
                            "Sorry, content could not be downloaded"),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            verticalSpaceSmall,
                            ExpansionPanelList(
                              elevation: 1,
                              expansionCallback: model.expansionCallback,
                              children: List.generate(
                                model.faqs.answers.length,
                                (int index) {
                                  String answer = model.faqs.answers[index];
                                  String question = model.faqs.questions[index];
                                  if (!question.endsWith("?") &&
                                      !question.endsWith("? ")) {
                                    question = question + "?";
                                  }
                                  return ExpansionPanel(
                                    canTapOnHeader: true,
                                    isExpanded: model.isExpanded[index],
                                    headerBuilder: (context, isExpanded) {
                                      return Container(
                                          padding: EdgeInsets.only(
                                              top: 20.0,
                                              left: 20.0,
                                              right: 20.0,
                                              bottom: isExpanded ? 5 : 20.0),
                                          child: AfkCreditsText.headingFour(
                                              question));
                                    },
                                    body: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                          bottom: 20.0,
                                          left: 20.0,
                                          right: 20.0),
                                      child: AfkCreditsText.body(
                                        answer,
                                        align: TextAlign.left,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
