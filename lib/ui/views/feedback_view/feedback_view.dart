import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/feedback_view/feedback_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feedback_view.form.dart';

@FormView(
  fields: [
    FormTextField(name: 'feedback'),
  ],
)
class FeedbackView extends StatelessWidget with $FeedbackView {
  FeedbackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedbackViewModel>.reactive(
      viewModelBuilder: () => FeedbackViewModel(),
      onModelReady: (model) {
        listenToFormUpdated(model);
        model.initialize();
      },
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: "Feedback",
            onBackButton: model.popView,
          ),
          floatingActionButton: AFKFloatingActionButton(
            icon: Icon(Icons.send, color: Colors.white),
            width: 140,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            title: "Send feedback",
            onPressed: () async {
              await model.sendFeedback();
              feedbackController.clear();
              model.notifyListeners();
            },
            isBusy: model.isBusy,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kHorizontalPadding, vertical: 20.0),
              child: model.isInitializing
                  ? AFKProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (model.feedbackCampaignInfo?.questions != null &&
                        //     model.feedbackCampaignInfo!.questions.length > 0)
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       verticalSpaceSmall,
                        //       AfkCreditsText.headingThree(
                        //           "Question of the week"),
                        //       verticalSpaceSmall,
                        //       Container(
                        //         height: 80,
                        //         padding: const EdgeInsets.all(15.0),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(16.0),
                        //           color: kcGreenWhiter,
                        //           boxShadow: [
                        //             BoxShadow(
                        //                 spreadRadius: 0.3,
                        //                 offset: Offset(1, 1),
                        //                 blurRadius: 0.4,
                        //                 color: kcShadowColor),
                        //           ],
                        //         ),
                        //         alignment: Alignment.center,
                        //         child: AfkCreditsText.headingFour(
                        //             model.feedbackCampaignInfo!.questions[0]),
                        //       ),
                        //       verticalSpaceMedium,
                        //     ],
                        //   ),
                        // AfkCreditsButton(
                        //     onTap: model.sendFeedback,
                        //     title: "Answer question of the week",
                        //     leading: Icon(Icons.send, color: Colors.white),
                        //     ),
                        verticalSpaceSmall,
                        AfkCreditsText.headingThree("General feedback"),
                        verticalSpaceSmall,
                        AfkCreditsText.bodyItalic(
                            "Found bugs? Have suggestions? Anything else? Please let us know."),
                        verticalSpaceSmall,
                        AfkCreditsInputField(
                          maxLines: 5,
                          controller: feedbackController,
                          placeholder: 'Add feedback here...',
                          errorText: model.feedbackInputValidationMessage,
                        ),
                        verticalSpaceMedium,
                        AfkCreditsText.bodyItalic(
                            "Upload a screenshot of the bug"),
                        verticalSpaceSmall,
                        GestureDetector(
                          // When we tap we call selectImage
                          onTap: () => model.selectImage(),
                          child: Container(
                            height: 150,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            // If the selected image is null we show "Tap to add post image"
                            child: model.selectedImage == null
                                ? Icon(Icons.add_a_photo_outlined,
                                    color: kcMediumGrey, size: 30)
                                // If we have a selected image we want to show it
                                : Image.file(model.selectedImage!),
                          ),
                        ),
                        verticalSpaceMedium,
                        if (model.feedbackCampaignInfo?.surveyUrl != null &&
                            model.feedbackCampaignInfo?.surveyUrl != "")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalSpaceSmall,
                              AfkCreditsText.headingThree("Take our survey"),
                              verticalSpaceSmall,
                              GestureDetector(
                                onTap: () => _launchUrl(
                                    model.feedbackCampaignInfo!.surveyUrl),
                                child: Container(
                                  height: 80,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: kcOrangeWhite,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 0.3,
                                          offset: Offset(1, 1),
                                          blurRadius: 0.4,
                                          color: kcShadowColor),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: AfkCreditsText.bodyItalic(
                                                "Survey link"),
                                          ),
                                          Spacer(),
                                          Icon(Icons.arrow_forward_ios,
                                              color: kcMediumGrey, size: 22),
                                        ],
                                      ),
                                      verticalSpaceTiny,
                                      AfkCreditsText(
                                          text: model
                                              .feedbackCampaignInfo!.surveyUrl,
                                          style: captionStyle.copyWith(
                                              overflow: TextOverflow.ellipsis))
                                    ],
                                  ),
                                ),
                              ),
                              verticalSpaceMedium,
                            ],
                          ),
                        verticalSpaceMassive,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    // Uri uri = Uri.https(authority, path);
    if (await canLaunchUrl(uri)) {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    } else {
      print("=> Can't launch URL");
    }
  }
}